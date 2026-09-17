let num1 = 20;
let num2 = 20;

// let difference;
// if(num1>num2) {
//     difference = num1 - num2;
// } else {
//     difference = num2 - num1;
// }

let difference = (num1>num2) ? num1-num2 : num2-num1;
let msg = (num1>num2) ? `첫번째 수가 ${difference}만큼 더 큽니다.`:
            (num2>num1) ? `두번째 수가 ${difference}만큼 더 큽니다.` :
                '두 수는 같습니다.';

console.log(msg);