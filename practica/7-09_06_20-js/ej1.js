// vacia
let vacia = {
    esVacia: function() { return true; },
    cons: function(o) {
        let res = Object.create(this)
        res.esVacia = () => true;
        res.head = () => o;
        res.tail = () => this;
        return res;
    },
};

let lista12 = vacia.cons(2).cons(1)

// string
String.prototype.head = function() {return this[0];}
String.prototype.tail = function() {return this.slice(1);}

// trie
// esta mal, ni idea es la 1 am
let Trie = function(esFinal, hijos) {
    this.esFinal = esFinal;
    this.hijos = hijos;
    this.contienePalabra = function(p) {
        let actual = this;
        for (let c in p) {
            if (!(p[c] in actual.hijos)) {
                return false;
            }

            for (let k in actual.hijos) {
                if (k == p[c]) {
                    actual = actual.hijos[k];
                    break;
                }
            }
        }       

        return actual.esFinal
    }
}

Trie(false, {
    "b": Trie(false, {
        "a": Trie(true, {}),
    }),
})

// secuencia infinita
let InfiniteSequence = function() {
    this.val = 1;
    this.next = function() {
        let res = Object.assign({}, this); // puede ser Object.create(this)
        res.val++;
        return res;
    }
}