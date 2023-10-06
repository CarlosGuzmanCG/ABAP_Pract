*&---------------------------------------------------------------------*
*& Report ZPOO_50_SINGLETON_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPOO_50_SINGLETON_ALFA02.

data: gr_singleton type ref to  zcl_singleton_alfa02,
      gr_single2 type ref to zcl_singleton_alfa02.

  zcl_singleton_alfa02=>obtener_instancia(
    IMPORTING
      instancia =    gr_singleton              " SINGLETON
  ).

  wait up to 2 SECONDS.

  zcl_singleton_alfa02=>obtener_instancia(
    IMPORTING
      instancia = gr_single2                 " SINGLETON
  ).

  write: / gr_singleton->hora_creacion ENVIRONMENT TIME FORMAT,
         / gr_single2->hora_creacion ENVIRONMENT TIME FORMAT.
