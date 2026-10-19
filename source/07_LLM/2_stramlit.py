import streamlit as st
st.set_page_config(page_title="AI summary", page_icon="🤖")

st.title("first streamlit wep app") # h1 태그 효과
st.header("summary assistant") # h2 태그 효과
st.subheader("요약 어시스턴트") # h3 태그 효과
st.text("요약 어시스턴트는 한국어 텍스트를") # text(div>span)
st.write("요약하는 전문 어시스턴트입니다.") # write(div>p)
st.caption("스트림릿을 이용하여 웹페이지를 만들 수 있습니다.") # caption(div>p)
st.markdown("---")

message = st.text_area("요약할 텍스트를 입력하세요")
if st.button("요약하기"):
    st.info('요약 중...'+ message)

if prompt := st.chat_input("요약할 텍스트를 입력하세요"):
    st.chat_message("assistant").write(f"요약 중... {prompt}")
    st.chat_message("ai").write(prompt)
    st.chat_message("user").write(prompt)
    st.chat_message("홍길동").write(prompt)