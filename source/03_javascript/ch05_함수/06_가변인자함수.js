// 가변인자함수 : 매개변수의 개수에 따라 변하는 함수, 화살표 함수는 불가함
// 내장함수 Array()

// 배열 생성 방식과 동일하게 작동
var arr1 = [1, 2, '셋', 4];

// 2개 이상의 인자를 전달하면 전달된 값들을 요소로 가짐
var arr2 = Array(1, 2, '셋'); 

// 요소 개수가 3인 빈 배열, ','의 개수 = 요소 개수
var arr3 = [ , , , ]; 

// 숫자인 단일 인자 n을 넣으면 요소가 채워지지 않은 길이 n의 배열 생성
var arr4 = Array(3); 

console.log(arr1);

console.log(arr2);

console.log(arr3[0],arr3[1],arr3[2])

console.log(arr4);