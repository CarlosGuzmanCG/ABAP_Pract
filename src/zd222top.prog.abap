*&---------------------------------------------------------------------*
*& Include ZD222TOP                                 - Module Pool      ZDXYZ7
*&---------------------------------------------------------------------*
PROGRAM ZDXYZ7.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
TYPES: BEGIN OF TY_kunnr,
  akunnr    type kna1-kunnr,
  acity     type kna1-ort01,
  acountry  type kna1-land1,
  aphoneno  type kna1-telf1,
  aname     type kna1-name1,
  gender    type ad_sex,
  title(4)  type c,
end of ty_kunnr.

data: wa_kunnr type ty_kunnr,
      cb1      type c,
      cb2      type c,
      cb3      type c,
      rb1      type c,
      rb2      type c.

MODULE user_command_0100 INPUT.

  CASE SY-UCOMM.

    WHEN 'INSERT'.

    data(lw_title) = COND #(
    when cb1 eq abap_true then 'MR.'
    when rb1 eq abap_true then 'MISS.'
    when rb2 eq abap_true then 'MRS.'
    ).

    data(lw_gender) = cond #(
    when rb1 eq abap_true then 'F'
    when rb2 eq abap_true then 'M'
    ).

     wa_kunnr-title  = lw_title.
     wa_kunnr-gender = lw_gender.


      MODIFY ZDTABLE_T_ALFA02 FROM wa_kunnr.

      IF sy-subrc eq 0.
        MESSAGE 'DATA IS INSERTED SUCCESSFULLY' TYPE 'I'.
        CLEAR wa_kunnr.
      ELSE.
        MESSAGE 'DATA IS NOT INSERTED SUCCESSFULLY' TYPE 'I'.
      ENDIF.



    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.
