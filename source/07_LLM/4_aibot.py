import streamlit as st
from ai_llm import ask_with_reference

st.set_page_config(page_title="AI bot", page_icon="🎃")
st.title("AI bot")
st.caption("소득세에 대한 질문에 답변하고 참고조항을 출력합니다.")

if user_question := st.chat_input(placeholder="질문을 입력하세요"):
    with st.chat_message("AI"):
        st.write(user_question)
    with st.spinner("질문을 처리하는 중..."):
        result = ask_with_reference(user_question)
        with st.chat_message("AI"):
            st.write(result)