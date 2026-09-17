// JavaScript source code
/* 02.js */
name = prompt("What's your name?", "Hong, Gil Dong");
// 취소 선택 시 'null' 입력
if (name != 'null' && name != '') {
    document.write("~ Welcome. " + name + ". ~<br>");
}
