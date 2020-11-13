# Resolución SLD

Ultima teórica

prolog recorre de forma determinista

las clausulas no son conjuntos de literales, y un programa no es un conjunto,
sino que son listas porque importa el orden.

Clausulas -> Lista de literales (fórmula atómica o F.A negada).
Un programa no es más un conjunto de cláusulas, sino una lista.

- Regla de búsqueda: usamos la primera del programa que puede usar para resolver
  (de arriba a abajo)
- Regla de selección: De la clausula donde todos son negativos, tomás el átomo
  más a la izquierda.

Ante un clash de nombres, renombrar las reglas y no el goal.

P => C es valido
~(P => C) insatisfactible
~(~P \/ C) <=> P /\ ~C

