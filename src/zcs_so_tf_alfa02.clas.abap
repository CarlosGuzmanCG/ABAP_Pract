CLASS zcs_so_tf_alfa02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.

    INTERFACES IF_AMDP_MARKER_HDB.

    CLASS-METHODS get_flights FOR TABLE FUNCTION Z_TF_SO_ALFA02.



ENDCLASS.



CLASS zcs_so_tf_alfa02 IMPLEMENTATION.

  METHOD get_flights by database FUNCTION FOR HDB LANGUAGE SQLSCRIPT
                     OPTIONS READ-ONLY USING SFLIGHT .

       lt_fldate = APPLY_FILTER ( SFLIGHT , :sel_opt );

     RETURN select sel_opt.mandt,
                   sel_opt.carrid,
                   sel_opt.connid,
                   sel_opt.fldate,
                   sel_opt.price
                from :lt_fldate as sel_opt inner join  SFLIGHT as bbdd
                    on sel_opt.mandt = bbdd.mandt and
                               sel_opt.carrid = bbdd.carrid and
                               sel_opt.connid = bbdd.connid ;

  ENDMETHOD.

ENDCLASS.
