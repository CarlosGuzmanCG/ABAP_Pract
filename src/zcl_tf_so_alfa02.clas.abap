CLASS zcl_tf_so_alfa02 DEFINITION
  PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.
   interfaces if_amdp_marker_hdb.
   CLASS-METHODS GET FOR TABLE FUNCTION ZTF_SO_ALFA02.
ENDCLASS.



CLASS zcl_tf_so_alfa02 IMPLEMENTATION.
  METHOD get BY DATABASE FUNCTION FOR HDB
    LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING MARC makt.


    lt_plant_filter = APPLY_FILTER (marc, :sel_opt);

    return SELECT selec_opt.mandt as mandt,
            selec_opt.matnr as material,
            selec_opt.werks as plant,
            text.maktx as description -- no existe en la tabla marc por eso se usa la tabla makt
        from :lt_plant_filter as selec_opt
            INNER JOIN marc as plant_data on
            selec_opt.mandt = plant_data.mandt
            and selec_opt.matnr = plant_data.matnr
            and selec_opt.werks = plant_data.werks
        INNER JOIN makt as text -- alias
            on text.mandt = plant_data.mandt
            and text.matnr = plant_data.matnr
            and text.spras = :lang
         WHERE plant_data.mandt = :clnt; -- filtro

  ENDMETHOD.

ENDCLASS.
