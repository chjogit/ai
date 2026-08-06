// 일반적인 호출
console.log(pow(5,3));

// 선언된 매개변수 보다 많은 매개변수로 호출
console.log(pow(5,3,2), 'idx = 0부터 순서대로 매개변수에 전달');

// 선언된 매개변수 보다 적은 매개변수로 호출
console.log(pow(), '각 매개변수는 undefined 형태로 매개변수에 전달');

function pow(x, y) {
    console.log(`함수 내의 x=${x}, y=$${y}`);
    // x^y를 return하되, NaN을 출력하지 않는 함수
    result = 0;
    for(let cnt=1 ; cnt<=y ; cnt++){
        result *= x; // result = result * x 즉, x ** y
    }
    return result;
}

// function pow(x, y) {
//     console.log(`함수 내의 x=${x}, y=$${y}`);
//     result = 0;
//     for(let cnt=1 ; cnt<=y ; cnt++){
//         result *= x;
//     }
//     // return이 없을 경우, undefined가 출력됨
// }