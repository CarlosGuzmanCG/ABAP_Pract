*&---------------------------------------------------------------------*
*& Report ZDXYZ18
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDXYZ18.

DATA: TY_EMAIL TYPE CHAR25.

SELECTION-SCREEN begin of BLOCK b1.

  PARAMETERS: rb_name RADIOBUTTON GROUP rb1 USER-COMMAND test DEFAULT 'X',
              p_fname type char10 modif id abc ,
              p_sname type char10 MODIF ID abc,
              rb_add  RADIOBUTTON GROUP rb1,
              p_city  type char10 MODIF ID pqr,
              p_state type char10 modif id pqr,
              rb_phone RADIOBUTTON GROUP rb1,
              p_home   type char10 MODIF ID xyz,
              p_office type char10 MODIF ID xyz.

  SELECT-OPTIONS: S_EMAIL FOR TY_EMAIL MODIF ID XYZ.

SELECTION-SCREEN end of block b1.

at SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.

    IF SCREEN-NAME = 'P_FNAME'.

      SCREEN-REQUIRED = 2.

      MODIFY SCREEN.

    ENDIF.

  ENDLOOP.

  LOOP AT SCREEN.

    IF rb_name eq 'X' and screen-group1 = 'ABC'.

      screen-active = 1.
      MODIFY SCREEN.
      CONTINUE.

    ELSEIF RB_ADD EQ 'X' AND SCREEN-GROUP1 = 'PQR'.

      screen-active = 1.
      MODIFY SCREEN.
      CONTINUE.

    ELSEIF RB_PHONE EQ 'X' AND SCREEN-GROUP1 = 'XYZ'.

      screen-active = 1.
      MODIFY SCREEN.
      CONTINUE.

    ELSEIF RB_NAME EQ ' ' AND SCREEN-GROUP1 = 'ABC'.

      screen-active = 0.
      MODIFY SCREEN.
      CONTINUE.

    ELSEIF RB_ADD EQ ' ' AND SCREEN-GROUP1 = 'PQR'.

      screen-active = 0.
      MODIFY SCREEN.
      CONTINUE.

    ELSEIF RB_PHONE EQ ' ' AND SCREEN-GROUP1 = 'XYZ'.

      screen-active = 0.
      MODIFY SCREEN.
      CONTINUE.

    ENDIF.

 ENDLOOP.

 START-OF-SELECTION.

 IF p_fname IS INITIAL.

  MESSAGE 'FILL OUT ALL REQUIRED ENTRY FIELDS' TYPE 'S' DISPLAY LIKE 'E'.

 ELSE.

  WRITE: p_fname.

 ENDIF.
