p(a).
p(b).
p(c).
s(e).
s(f).
q(a, e).
q(a, f).
q(b, f).
r(X, Y) :- p(X), !, q(X, Y).

max2(X, Y, Y) :- X =< Y, !.
%max2(X, Y, X) :- X > Y.
max2(X, Y, X).

animal(perro).
animal(gato).
vegetal(X) :- not(animal(X)).

firefighter_candidate(X) :-
    not(pyromaniac(X)),
    punctual(X).
pyromaniac(attila).
punctual(jeanne_d_arc).

firefighter_candidate2(X) :-
    punctual(X),
    not(pyromaniac(X)).