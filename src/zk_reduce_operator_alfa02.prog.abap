*&---------------------------------------------------------------------*
*& Report ZK_REDUCE_OPERATOR_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZK_REDUCE_OPERATOR_ALFA02.

  DATA: LV_KUNNR TYPE kna1-kunnr.

  SELECTION-SCREEN begin of block b1 with frame title text-001.
    select-OPTIONS: s_kunnr for lv_kunnr.
  selection-SCREEN end of BLOCK b1.

  START-OF-SELECTION.
    PERFORM get_data.

  end-of-SELECTION.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT kunnr, name1, cast( 0 as dec ) as amount from kna1 into table @data(gt_kna1)
    where kunnr in @s_kunnr.

    IF gt_kna1[] is not INITIAL.

      SELECT * from bsid into table @data(gt_bsid) for all ENTRIES IN @gt_kna1
        where kunnr = @gt_kna1-kunnr and blart = 'BR'.

        LOOP AT gt_kna1 ASSIGNING FIELD-SYMBOL(<fs1>).

          <fs1>-amount = reduce i( init i type dmbtr for wa in gt_bsid where ( kunnr = <fs1>-kunnr ) next i = i + wa-dmbtr ).

        ENDLOOP.

        cl_demo_output=>display( gt_kna1 ).

    ENDIF.

ENDFORM.
