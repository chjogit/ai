// 매개변수가 없으면 -999를 리턴하고 매개변수가 1개 이상이면 누적합을 리턴하는 
// 가변인자함수 sumAll()을 작성한 자바스크립트 파일(sumAll.js)을 이용하시오.

function sumAll() {
    let result = 0;
    if(arguments.length==0){
        result = -999;
    } else if(arguments.length>0){
        for(let idx=0 ; idx<arguments.length ; idx ++){
            result += arguments[idx];
        }//for
    }//if
    return result;
};

// console.log(sumAll());
// console.log(sumAll(1, 2, 3));

/* for in */
function sumAll1() {
    let result = 0;
    if(arguments.length==0){
        result = -999;
    } else if(arguments.length>0){
        for(let idx in arguments){
            result += arguments[idx];
        }//for
    }//if
    return result;
};

// console.log(sumAll1());
// console.log(sumAll1(1, 2, 3));

/* for of */
function sumAll1() {
    let result = 0;
    if(arguments.length==0){
        result = -999;
    } else if(arguments.length>0){
        for(let data of arguments){
            result += data;
        }//for
    }//if
    return result;
};

// console.log(sumAll1());
// console.log(sumAll1(1, 2, 3));