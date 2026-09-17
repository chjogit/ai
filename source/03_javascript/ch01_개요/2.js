/* 변수 선언 시 var(전역 변수), let(지역 변수), const(상수) */
let sum = 0;

// for (초기화;조건;증감) {반복문}
/* 1부터 시작하여 ; i가 5보다 작거나 같을 때까지 ; {}를 반복 실행 (i++ = i 값 1씩 증가) */
for (var i=1 ; i<=5 ; i++) {
    sum += i;
    console.log('i=', i-1,'까지 누적 합 :', sum);
}
console.log('for문 종료');
console.log('for문 종료 후 i값 : '+i);