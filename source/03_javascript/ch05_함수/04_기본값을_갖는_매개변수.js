console.log(pow(5,3));
console.log(pow(5));
console.log(pow(y=2, x=3)); // 첫번째 매개변수 x(2), 두번째 매개변수 y(3) ; 
// 서순 지정 불가
console.log(pow());

function pow(x=5, y=2) {
    console.log(`함수 내의 x=${x}, y=$${y}`);
    // x^y를 return
    result = x ** y;
    return result;
}