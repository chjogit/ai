Date.prototype.getNumberOfDays = function(thatday){
    let interval = Math.abs(this.getTime() - thatday.getTime()); // 두 날짜 간격의 절대값
    let day;
    day = Math.trunc(interval/(1000*60*60*24)); // 소수점에서 자름
    /*
    day = Math.floor(interval/(1000*60*60*24)); // 소수점에서 더 작은 정수로 내림
    day = Math.round(interval/(1000*60*60*24)); // 소수점에서 반올림
    day = Math.ceil(interval/(1000*60*60*24)); // 소수점에서 더 큰 정수로 올림
    */
    return day;
};

// test

// let now = new Date();
// let limitday = new Date(2026, 10, 19, 18, 0, 0);

// console.log(now.getNumberOfDays(limitday));
// console.log(limitday.getNumberOfDays(now));
// console.log(now.getNumberOfDays(now));