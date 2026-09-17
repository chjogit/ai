def answer(country):
    '나라명을 입력 받은 후 llm 모델을 거쳐 수도명을 받아 return '
    from langchain_ollama import ChatOllama
    from langchain_core.prompts import PromptTemplate
    llm = ChatOllama(model='llama3.2:1b')
    prompt_template = PromptTemplate(
        template='What is the capital of {country}',
        input_variables = ['country']
    )
    result = llm.invoke(prompt_template.invoke(country))
    return result.content

if __name__=='__main__':
    country = input('수도가 궁금한 나라의 영어명 :')
    print(answer(country))