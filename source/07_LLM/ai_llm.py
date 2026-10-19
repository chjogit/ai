from langchain_upstage import ChatUpstage, UpstageEmbeddings
from langchain_pinecone import PineconeVectorStore

from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough

from ai_functions import categorize_content, extract_articles_from_docs, format_documents
import cohere
from dotenv import load_dotenv

UPSTAGE_LLM_MODEL = "solar-pro4"
UPSTAGE_EMBEDDING_MODEL = "embedding-query" # 차원수 4096
PINECONE_INDEX_NAME = "better-rag-index"

def get_llm(model = UPSTAGE_LLM_MODEL):
    'llm 생성'
    llm = ChatUpstage(model_name=model)
    return llm    

def keyword_dictionary_chain(llm):
    # 키워드 사전을 활용한 질문 변경
    keyword_dict  = [
        "사람을 나타내는 표현 -> 거주자",
        "직장인 -> 근로소득이 있는 거주자", 
        "월급쟁이 -> 근로소득이 있는 거주자",
        "회사원 -> 근로소득이 있는 거주자",
        "연봉 -> 종합소득",
        "월급 -> 근로소득",
        "세금 -> 소득세",
        "공제받다 -> 공제를 적용받다",
        "얼마나 내야하나 -> 세액은 얼마인가",
        "계산해줘 -> 계산하면 얼마인가"
    ]
    prompt = ChatPromptTemplate.from_template(f"""사용자의 질문을 보고, 우리의 사전을 참고해서 사용자 질문을
    변경해 주세요. 만약 변경할 필요가 없을 경우, 사용자의 질문을 변경하지 않아도 됩니다. 오직 질문만 리턴해 주세요.
    사전 : {keyword_dict}
    질문 : {{question}}""")
    keyword_chain = prompt | llm | StrOutputParser()
    return keyword_chain

def get_retriever(normalized_query, model=UPSTAGE_EMBEDDING_MODEL, k=15):
    'vector store에서 normalize query와 유사한 query를 검색하여 retriever로 반환'
    embedding = UpstageEmbeddings(model=model)
    vectorStore = PineconeVectorStore(
        embedding=embedding,
        index_name=PINECONE_INDEX_NAME
    )
    filter_condition = {'category':{'$in':categorize_content(normalized_query)}}
    retriever = vectorStore.as_retriever(
        search_type='similarity',
        search_kwargs = {
            'k':k,
            'filter' : filter_condition
        }
    )
    return retriever


def rerank_by_title(query:str, documents:list, top_k:int=3) -> list:
    '''
    cohere의 rerank API를 사용한 documents 재정렬
    Args:
    - query : 사용자 질문
    - documents : retriever로 검색된 Document 객체 list
    - top_k : 재정렬 후 반환할 문서 개수
    Returns:
    - title 및 page_content 유사도 기준으로 재정렬된 Document list
    '''
    # Document 객체에서 title과 page_content 추출
    docs_text = [doc.metadata.get('title')+' '+doc.page_content for doc in documents]
    
    # cohere 클라이언트 객체
    co = cohere.Client()
    
    # rerank
    results = co.rerank(
        model = 'rerank-multilingual-v3.0',
        query = query,
        documents=docs_text,
        top_n=top_k
    )
    rerank_docs = [documents[r.index] for r in results.results]
    return rerank_docs

def rag_chain(llm):
    template = f"""당신은 최고의 한국 소득세법 전문가입니다. 다음 문맥을 참고하여 질문에 답하세요. 답을 모를 경우, 알 수 없는 정보라고 대답하세요.
    질문 : {{query}}
    문맥 : {{context}}
    답변 : """
    prompt = ChatPromptTemplate.from_template(template)
    prompt_chain = prompt | llm | StrOutputParser()
    return prompt_chain

def ask_with_reference(query:str, k:int=15, top_k:int=3, chathistory:list=None):
    """
    query의 수정된 query, 답변, 참고조항을 반환하는 함수
    Args:
    - query : 질문
    - k : 검색할 문서 개수 (기본값 : 10)
    - top_k : 재정렬 후 사용할 문서 개수 (기본값 : 3)
    """
    llm = get_llm()
    ### chathistory에 질문이 있을 경우 query를 재구성 ###
    if chathistory:
        history_list = [f"{'사용자' if msg['role']=='user' else 'ai'}: {msg['content']}" for msg in chathistory]
        history_text = "\n".join(history_list)
        rewrite_prompt = ChatPromptTemplate.from_template(
            f"""이전 대화를 참고하여 대화를 재구성 해주세요.
            이전 대화 : {history_text}
            현재 질문 : {query}
            재구성된 질문 : """
        ) 
        query = (rewrite_prompt | llm | StrOutputParser()).invoke({"history":history_text, "question":query})
    ###    ###    ###
    keyword_chain = keyword_dictionary_chain(llm)
    normalized_query = keyword_chain.invoke({"question":query})

    retriever = get_retriever(normalized_query, k=10)
    retrieverd_docs = retriever.invoke(normalized_query)

    reranked_docs = rerank_by_title(
        query=normalized_query,
        documents=retrieverd_docs,
        top_k=3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    )

    referenced_articles = extract_articles_from_docs(reranked_docs)

    prompt_chain = rag_chain(llm)
    answer = prompt_chain.invoke({
        'query':normalized_query,
        'context':format_documents(reranked_docs)
    })
    result = f'📝답변 : {answer}',\
        f'📢참고 조항 : {referenced_articles}',\
        '⚠️위 답변은 AI에 의해 작성된 답변이므로 근소한 차액이 발생할 수 있습니다'
    return "\n\n".join(result)

if __name__ == "__main__":
    query = input("질문을 입력하세요: ")
    result = ask_with_reference(query)
    print(result)