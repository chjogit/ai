import streamlit as st
from openai import OpenAI
from dotenv import load_dotenv
from ai_functions import askGPT

def main():
    load_dotenv()
    st.set_page_config(page_title="AI summary", page_icon="🤖")
    st.header("summary assistant")
    st.subheader("한국어 텍스트 요약을 지원합니다.")
    message = st.text_area("요약할 텍스트를 입력하세요")
    if st.button("요약하기"):
        st.info(askGPT(message))

if __name__ == "__main__":
    main()