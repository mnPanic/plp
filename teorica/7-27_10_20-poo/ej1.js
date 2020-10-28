// JavaScript, notas de la clase
// variables
let miVar = 1
const constante = 10

console.log(miVar)
console.log(constante)

/* Tipado
* Dinamico (tiempo de ejecucion)
* Debil (conversion implicita de tipos)
*/

let a = 1
typeof a
a += "1"
typeof a
//console.log(a)

// funciones
function suma(a, b) {
    return a + b
}

let suma2 = function(a, b) {
    return a + b
}

let suma3  = (a, b) => a + b

// objetos

let o = {
    a: 1,
    b: function(n) {
        return this.a + n
    }
}

// ej1
// a. definir c1i que representa el numero complejo 1 + i. Tiene las propiedades
// r e i de tipo number.

let c1i = {
    r: 1,
    i: 1,
    sumar: function(c2) {
        return {
            r: this.r + c2.r,
            i: this.i + c2.i,
            sumar: this.sumar,
        }
    }
}

//console.log(c1i.sumar(c1i))
// 1d

//console.log(c1i.sumar(c1i).sumar(c1i))
//console.log(c1i)

// 1f
let c = c1i.sumar(c1i)
c.restar = function(c2) {
    return {
        r: this.r - c2.r,
        i: this.i - c2.i,
        sumar: this.sumar,
    }
}

//console.log(c1i.restar(c))