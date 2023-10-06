*&---------------------------------------------------------------------*
*& Report Z_DEBUG_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_DEBUG_ALFA02.

data: numero type i,
      resultado type i,
      cadena type string.

numero = 5.

cadena = 'hola'.

resultado = cadena + numero.

write resultado.
