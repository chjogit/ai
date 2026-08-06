/* array 함수 : 가변인자함수 (함수표현식 활용)
 * 매개변수 0개 : 빈 배열 [] 생성 (length가 0인 배열)
 * 매개변수 1개 : 해당 숫자를 길이(length)로 갖는 빈 희소 배열 생성
 * 매개변수 2개 이상 : 전달받은 모든 인자들을 요소로 포함하는 배열 생성
 */

// array()를 Array()로 작동하도록 구현
function array() { // 가변인자함수에서, 매개변수는 지정하지 않음
    let result = [];
    // arguments : 함수에 전달된 인자들을 담고 있는 유사 배열 객체
    // arguments.length : 매개변수 개수
    if(arguments.length==1){
        for(let cnt=1 ; cnt<=arguments[0] ; cnt ++){
            result.push(undefined);
        }// for
    } else if(arguments.length>=2){
        for(let data of arguments){
            result.push(data);
        }//for
    }//if
    return result;
};

var arr1 = array(1, 2, '셋', 4);
var arr2 = array(1, 2, '셋'); 
var arr3 = array(); 

// array()와 Array()의 다른 부분
var arr4 = array(3); 
var arr5 = Array(3); 

console.log(arr1);
console.log(arr2);
console.log(arr3[0],arr3[1],arr3[2])
console.log(arr4);
console.log(arr5);