// ej1 con prototipos
let c1i = {
    r: 1,
    i: 1,
    sumar: function(c) {
        let c2 = Object.create(this)
        console.log(c2)
        c2.i += c.i
        c2.r += c.r

        return c2
    }
}

console.log(c1i.sumar(c1i))
console.log(c1i)

let c = c1i.sumar(c1i)
c.restar = function(c) {
    let c2 = Object.create(this)
    c2.i -= c.i
    c2.r -= c.r
    return c2
}

console.log(c.restar(c1i))