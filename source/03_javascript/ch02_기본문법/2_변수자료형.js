// 자료형 : string, number, boolean, function, object(array), undefined, null

// undefined : 변수 초기화 없을 경우 기본값
var variable; // 할당 없이 변수 선언 가능
console.log('1.variable type :', typeof(variable), '- value :', variable);

// null : 할당을 통해 생성된 결측치
variable = null;
console.log('2.variable type :', typeof(variable), '- value :', variable);

// " " 내부에 '' 삽입 가능
variable = "이름은 '홍길동' 입니다.";
console.log('3.variable type :', typeof(variable), '- value :', variable);

// format 활용 예시
let name = '홍길동';
variable = `이름은 '${name}' 입니다.`;
console.log('4.variable type :', typeof(variable), '- value :', variable);

// number
variable = -3.2323;
console.log('5.variable type :', typeof(variable), '- value :', variable);

// boolean
variable = true;
console.log('6.variable type :', typeof(variable), '- value :', variable);

// number
variable = -3.2323;
console.log('7.variable type :', typeof(variable), '- value :', variable);

// function
variable = function(){alert('Hello')};
console.log('8.variable type :', typeof(variable), '- value :', variable);

// 객체 - object
variable = {'name':'홍길동', 'age':20}
console.log('9.variable type :', typeof(variable), '- value :', variable);
console.log('9-1.variable type :', typeof(variable), '- value :', variable['name']);

// array - object
variable = [1, 2, '홍길동', function(){}, true, [1, 3], {'name':'홍길동'}];
console.log('10.variable type :', typeof(variable), '- value :', variable);
console.log('10.variable type :', typeof(variable), '- value :', variable[5]);