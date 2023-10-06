*&---------------------------------------------------------------------*
*& Report Z16_SEL_SING_UPD2_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z16_SEL_SING_UPD2_ALFA02.

  data gwa_zs type zspflialfa02.

  select single for update * from zspflialfa02
    into gwa_zs  where carrid = 'SQ' and CONNID eq '2'.

  IF sy-subrc eq 0.

     update zspflialfa02 from gwa_zs.

     IF sy-dbcnt eq 1.

        write 'Datos actualizados'.

     ELSE.

       WRITE 'ERROR'.

     ENDIF.

   ELSE.

     write 'Datos no encontrados'.

  ENDIF.
