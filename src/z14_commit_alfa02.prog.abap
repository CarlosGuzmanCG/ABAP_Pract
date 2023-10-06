*&---------------------------------------------------------------------*
*& Report Z14_COMMIT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z14_commit_alfa02.

CLASS min_par DEFINITION.

  PUBLIC SECTION.

  METHODS: set_min IMPORTING min TYPE i, get_bool EXPORTING bool TYPE abap_bool.

  CLASS-METHODS: on_transaction_finish FOR EVENT transaction_finished
                 OF cl_system_transaction_state IMPORTING kind.

  PRIVATE SECTION.

  CLASS-DATA: min TYPE i.

  DATA bool TYPE abap_bool.

ENDCLASS.

CLASS min_par IMPLEMENTATION.

  METHOD set_min.

    me->min = min.

    IF ( me->min mod 2 ) eq 0.

       me->bool = abap_true.

    ELSE.

      Me->bool = abap_false.

    ENDIF.

  ENDMETHOD.

  METHOD get_bool.

    bool = me->bool.

  ENDMETHOD.

  METHOD on_transaction_finish.

    IF kind EQ cl_system_transaction_state=>commit_work.

      WRITE 'Datos actualizados'.

    ELSEIF kind EQ cl_system_transaction_state=>rollback_work.

      WRITE 'Datos no actualizados'.

    ENDIF.

  ENDMETHOD.


ENDCLASS.

START-OF-SELECTION.

   DATA: time_hour TYPE t,
         min TYPE i,
         bool TYPE abap_bool,
         gc_cl TYPE REF TO min_par,
         gwz_zs TYPE zscarralfa02 .

   CREATE OBJECT gc_cl.

      time_hour = sy-uzeit.

      min = time_hour+2(2).

*      WRITE min.

      gc_cl->set_min( min =  min ).

      SET HANDLER min_par=>on_transaction_finish.

      UPDATE zscarralfa02 SET currcode = 'USD' WHERE carrid = 'BA'.

      SELECT * FROM zscarralfa02 INTO gwz_zs WHERE carrid = 'BA'.
      ENDSELECT.

      IF sy-dbcnt EQ 1.

      WRITE: / 'Datos: ',
             / gwz_zs-carrid,
             / gwz_zs-carrname,
             / gwz_zs-currcode,
             / gwz_zs-url.

   ENDIF.

      gc_cl->get_bool(
        IMPORTING
          bool = bool ).

      IF bool EQ abap_true.

      COMMIT WORK.

      ELSEIF bool EQ abap_false.

      ROLLBACK WORK.

      ENDIF.



*      set handler min_par=>on_transaction_finish

*  data gwz_zs type zscarralfa02.
*
*  update zscarralfa02 set currcode = 'USD' where carrid = 'BA'.
*
*  commit work.
*
*  select * from zscarralfa02 into gwz_zs where carrid = 'BA'.
*  endselect.
*
*   " write sy-dbcnt.
*
*   IF sy-dbcnt eq 1.
*
*      write: / 'Datos: ',
*             / gwz_zs-carrid,
*             / gwz_zs-carrname,
*             / gwz_zs-currcode,
*             / gwz_zs-url.
*
*   ENDIF.
