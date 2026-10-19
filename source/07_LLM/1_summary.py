from dotenv import load_dotenv
from openai import OpenAI

def askGPT(message):
    '''
    GPT 모델을 활용하여 message를 요약한 결과를 반환.
    '''
    load_dotenv()
    client = OpenAI()
    response = client.chat.completions.create(
        model="gpt-4.1-mini",
        messages=[
        {'role':'system','content':'당신은 한국어 텍스트를 요약하는 전문 어시스턴트 입니다.'},
        {'role':'user','content':f'다음의 텍스트를 한 줄로 요약하고, 글 머리표를 사용하여 출력하세요. text: {message}'}
        ],
        temperature=0.7        
    )
    return response.choices[0].message.content

if __name__ == "__main__":
    message = input("요약할 텍스트를 입력하세요: ")
    summary = askGPT(message)
    print(summary)