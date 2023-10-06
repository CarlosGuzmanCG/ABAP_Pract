*&---------------------------------------------------------------------*
*& Report ZPOO_EJERC_EXCEP_10_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpoo_ejerc_excep_10_alfa02.

CLASS lcx_no_date DEFINITION INHERITING FROM cx_static_check..

ENDCLASS.

CLASS lcx_format_unknown DEFINITION INHERITING FROM cx_static_check..

ENDCLASS.


CLASS lcl_date_analyze DEFINITION.

  PUBLIC SECTION.

  METHODS: analyze_date IMPORTING previous TYPE REF TO cx_root
                                      RAISING lcx_no_date,

           analyze_format IMPORTING previous TYPE REF TO cx_root
                                        RAISING lcx_format_unknown.

ENDCLASS.

CLASS lcl_date_analyze IMPLEMENTATION.

  METHOD analyze_date.

    RAISE EXCEPTION TYPE lcx_no_date
      EXPORTING
*        textid   =
        previous = previous
    .

 ENDMETHOD.

 METHOD analyze_format.

   RAISE EXCEPTION TYPE lcx_format_unknown
     EXPORTING
*       textid   =
       previous = previous
   .

 ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA: go_analyze TYPE REF TO lcl_date_analyze,
        gcx_lcl_date_analyze TYPE REF TO lcx_no_date,
        gcx_format_unknown TYPE REF TO  lcx_format_unknown.

  CREATE OBJECT go_analyze.

  TRY.

    TRY.

     go_analyze->analyze_date( previous = gcx_lcl_date_analyze ).

    CATCH lcx_no_date INTO gcx_lcl_date_analyze.

      WRITE 'TRY 1.'.
      write /  gcx_lcl_date_analyze->get_text( ).

    ENDTRY.

      go_analyze->analyze_format( previous = gcx_format_unknown ).

    CATCH lcx_format_unknown into gcx_format_unknown.

      write / 'ERROR 2'.

      write / gcx_format_unknown->get_text( ).

  ENDTRY.
