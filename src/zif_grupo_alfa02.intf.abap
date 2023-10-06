interface ZIF_GRUPO_ALFA02
  public .


  types: begin of DETALLES_GRUPO,
          sector type SPART, grupocliente type KDGRP, solicitudes type KUNAG,
          end of detalles_grupo.

  types DOCUMENTOS type ref to ZIF_DOCUMENTOS_ALFA02 .

  class-data GRUPO_CLIENTE type KDGRP .
  data DES_MERCANCIA type KUNWE .

  events AVISAR_CANAL_DISTRIBUICION
    exporting
      value(CANAL_DIST) type VTWEG .

  methods SET_METODO
    importing
      !DEST_MERCANCIA type KDGRP .
endinterface.
