let funVar = function() {
    console.log('1. 일반함수 호출'); // 동일한 형태 유지 
};
funVar();

funVar = () => {
    console.log('2. 매개변수가 없거나 2개 이상인 화살표함수 호출');
};
funVar();

funVar = i => {
    console.log('3. 매개변수가 하나인 화살표 함수 호출');
    console.log('\t매개변수 i = ', i);
};
funVar(10);

funVar = i => console.log('4. 매개변수가 하나고, \
    한 줄의 구현부를 가진 화살표 함수 호출', i);
funVar(10);


funVar = i => i*i;
console.log('5. 매개변수가 하나고, 하나의 리턴값를 가진 화살표 함수 호출', funVar(10));

funVar = (i, j) => i+j;
console.log('6. 매개변수가 2개 이상이고, \
    하나의 리턴값을 가지는 화살표 함수 호출', funVar(10,20));