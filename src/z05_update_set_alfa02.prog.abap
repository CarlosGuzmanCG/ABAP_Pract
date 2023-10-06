*&---------------------------------------------------------------------*
*& Report Z05_UPDATE_SET_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z05_update_set_alfa02.

" Actualiza todos los registros de la columna CURRCODE
*  update zscarralfa02 set currcode = 'EUR'.

" Actualiza todos los registros de la columna CURRCODE y URL
*  update zscarralfa02 set currcode = 'USB'
*         url = 'https://google.com'.

" Actualiza solamente si se cumple la condicion
*  UPDATE zscarralfa02 SET currcode = 'EUR'
*         url = 'https://google.com'
*  WHERE carrid EQ 'AA'.

  "Podemos actualizar con mas de una condicion SET:

  update zscarralfa02 set: currcode = 'USD'
                           url = 'google' where carrid eq 'AA',

                           currcode =' EUR'
                           url = 'google.com' where carrid eq 'AF'.


  IF sy-subrc EQ 0.

    WRITE  / 'Se han actactualizado todos los registros'.

  ELSE.

    WRITE / 'No se han actualizado todos los registros'.

  ENDIF.
