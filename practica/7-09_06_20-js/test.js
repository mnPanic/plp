let o1 = { a :1, b: function () { return this.a }}
let o2 = Object . create ( o1 )
o2.a =2
o2.b()