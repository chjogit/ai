var cnt = 0;
var startTime = new Date().getTime(); //1970.01.01부터 현재까지의 밀리초(ms) 반환
// console.log(startTime);

while(new Date().getTime()<=startTime+1000) {
    cnt++;
}

console.log(
    '1초 동안 while문 수행 횟수 :', cnt
);

cnt = 0;
startTime = new Date().getTime();
do{
    cnt++;
}while(new Date().getTime()<=startTime+1000);

console.log(
    '1초 동안 do-while문 수행 횟수 :', cnt
);