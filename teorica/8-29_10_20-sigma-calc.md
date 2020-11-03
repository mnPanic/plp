# Calculo sigma

Los objetos los podemos pensar como una coleccion de registros, las cosas que
podemos pedirles a esos objetos.

En general hay una divison clara entre atributos (representacion del estado) y
metodos (definiciones que dicen como respondo a un mensaje). Pero en el calculo
sigma se representan los atributos como metodos constantes.

Objeto: registro de metodos. Proveen dos operaciones

- Envio de mensajes (invocacion de un metodo)
- Redefinición de un método: es util con los prototipos, porque creo un obj como
  copia de otro objeto y luego modifico la copia. Y por eso requiero poder
  redefinir (o asignar un nuevo valor a un atributo).

## Sintaxis

o, p =
    | x
    | [l_i = \sigma(x_i)b_i^{i\in 1..n }]       
    | o.l                                       enviar el msj l al objeto
    | o.l <- \sigma(x)b                         redefinir el metodo l