*&---------------------------------------------------------------------*
*& Report z_sat_alfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_sat_alfa02.

data gv_number type i.

while gv_number <> 10.  " bucle infinito
 perform get_flights.
 gv_number = sy-index.
ENDWHILE.

write 'fin'.

form get_flights.
  select * from sflight into table @Data(lt_result).
ENDFORM.
