function Complejo(r, i) {
    this.r = r;
    this.i = i;
    this.sumar = function(c) {
        return new Complejo(
            this.r + c.r,
            this.i + c.i,
        )
    };
}

let c1i = new Complejo(1, 1)
let c = c1i.sumar(c1i)
console.log(c, c1i)
c.restar = function(c2) {
    return new Complejo(
        this.r - c2.r,
        this.i - c2.i,
    )
}

console.log(c.restar(c1i))