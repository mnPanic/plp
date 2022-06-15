% p(a).
% p(b).
% p(c).
% s(e).
% s(f).
% q(a, e).
% q(a, f).
% q(b, f).
% r(X, Y) :- p(X), !, q(X, Y).

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

iesimo(0, [Y|_], Y).
iesimo(I, [_|L], X) :- I >= 0, J is I-1, iesimo(J, L, X).

s(X):- p(X).
s(0).

p(X) :- q(X).
p(1).

q(X):- r(X),!.
q(2).

r(3).
r(4).

bombero(tomi).

% TODO: anotar: ! hace falta en not porque sino devuelve siempre true (hace
% backtracking).
nah(G) :- G, fail.
nah(G).