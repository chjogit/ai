import streamlit as st
from ai_llm import ask_with_reference

st.set_page_config(page_title="소득세법 AI챗봇", page_icon="🎃")
st.title("소득세법 AI챗봇")
st.caption("소득세에 대한 질문에 답변하고 참고조항을 출력합니다.")

# 대화 이력 초기화
if 'messages' not in st.session_state:
    st.session_state.messages = []

for msg in st.session_state.messages:
    st.chat_message(msg['role']).write(msg['content'])

if user_question := st.chat_input(placeholder="질문을 입력하세요"):
    with st.chat_message("AI"):
        st.write(user_question)
        st.session_state.messages.append({"role":"user","content":user_question}) # 질문 이력 추가
    with st.spinner("질문을 처리하는 중..."):
        result = ask_with_reference(user_question, chathistory=st.session_state.messages[:-1])
        with st.chat_message("AI"):
            st.write(result)
            st.session_state.messages.append({"role":"ai","content":result}) # 답변 이력 추가