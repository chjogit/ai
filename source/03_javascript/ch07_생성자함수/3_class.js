// ECMA script6 이상을 지원하는 브라우저에서 사용 가능
// caniuse.com에서 ES6 지원 여부 확인 가능
class Student{
    constructor(name, kor, mat, eng) { // 생성자 constructor
        this.name = name;
        this.kor = kor;
        this.mat = mat;
        this.eng = eng;
    }

    // class 내부에서 정의된 메소드는 자동적으로 prototype 형식으로 실행됨
    getSum(){
        return this.kor + this.mat + this.eng;
    };

    getAvg(){
        return (this.getSum() / 3).toFixed(1);
    };

    toString(){
        return  'name : ' + this.name +
                ' kor : ' + this.kor +
                ' mat : ' + this.mat +
                ' eng : ' + this.eng +
                ' sum : ' + this.getSum() +
                ' avg : ' + this.getAvg();
    }; //toString
} //class

let hong = new Student('홍길동', 98, 100, 86);

console.log(hong);
console.log(hong.toString());
console.log(`${hong}`); // 템플릿 리터럴은 toString()을 자동호출함
document.write(hong);