// false로 해석되는 값 : 0, NaN, undefined, null, '' /-- 유의 --/ [],' ' = true

var i;

//false
console.log(Boolean(i));
console.log(Boolean(0));
console.log(Boolean(NaN));
console.log(Boolean(undefined));
console.log(Boolean(null));
console.log(Boolean(''));

//true
console.log(Boolean(' '));
console.log(Boolean([]));