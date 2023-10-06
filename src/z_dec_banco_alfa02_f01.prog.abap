*&---------------------------------------------------------------------*
*& Include          Z_DEC_BANCO_ALFA02_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form BANCOT_ALFA02_F01
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form DO_INIT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM do_init .

 C_TEST = TEXT-CO1.
 C_NOTIF = TEXT-CO2.
 TITLE1 = 'Datos cabecera'.
 TITLE2 = 'Tipo de ejecución'.
 TITLE3 = 'Documentos a declarar'.
 TITLEN1 = 'Persistir datos'.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_VALUES
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_values .

  IF p_perio < 1 OR p_perio > 12.

  MESSAGE e000(z_alfa02).

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form START-OF-SELECTION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM EXECUTE_TASK .

IF p_delete EQ abap_true OR p_update EQ abap_true.

  SELECT SINGLE * FROM zib_alfa02
    INTO gwa_banco
    WHERE sociedad = p_soc AND ejercicio = p_ejer AND per_cont = p_perio.

ENDIF.


IF p_create EQ abap_true OR p_modify EQ abap_true.

    PERFORM CM using GWA_INFORM_BANCO.

ENDIF.


CASE 'X'.

  WHEN p_create.

"    PERFORM create_record using GWA_INFORM_BANCO.

    INSERT zib_alfa02 FROM GWA_INFORM_BANCO.

    IF sy-subrc EQ 0.

      MESSAGE i001(z_alfa02).

    ELSE.

      MESSAGE i002(z_alfa02).

    ENDIF.

   WHEN p_read.

     PERFORM READ_RECORD using gwa_inform_banco.

   IF sy-subrc EQ 0.

    WRITE:  /  'MANDT: '        , gwa_inform_banco-mandt ,
            /  'SOCIEDAD: '     , gwa_inform_banco-sociedad,
            /  'EJERCICIO: '    , gwa_inform_banco-ejercicio,
            /  'PER_CONT: '     , gwa_inform_banco-per_cont,
            /  'TIPO_EJEC: '    , gwa_inform_banco-tipo_ejec,
            /  'USUARIO_RES: '  , gwa_inform_banco-usuario_res,
            /  'FECHA_EJE: '    , gwa_inform_banco-fecha_eje.

    ELSE.

      MESSAGE i003(z_alfa02).

    ENDIF.

   WHEN p_update.

   PERFORM UPDATE_RECORD.

   WHEN p_delete.

     PERFORM DELETE_RECORD.

  WHEN p_modify.

    MODIFY zib_alfa02 FROM GWA_INFORM_BANCO.

    IF sy-subrc EQ 0.

      MESSAGE i009(z_alfa02).

    ENDIF.

ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELETE_RECORD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM delete_record .

IF sy-subrc EQ 0.

       DELETE zib_alfa02 FROM gwa_banco.

       IF sy-subrc EQ 0.

        MESSAGE i006(z_alfa02).

       ELSE.

         MESSAGE i007(z_alfa02).

       ENDIF.

     ELSE.
       MESSAGE i007(z_alfa02).

     ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form UPDATE_RECORD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM update_record .

DATA v_ban TYPE c LENGTH 1.

   gwa_banco-tipo_ejec = COND #( WHEN p_acre EQ 'X' THEN 'A' ELSE 'D').

   v_ban = gwa_banco-tipo_ejec.

   UPDATE zib_alfa02 SET tipo_ejec = v_ban WHERE sociedad = p_soc AND ejercicio = p_ejer AND per_cont = p_perio.

   IF sy-subrc EQ 0.

     MESSAGE i004(z_alfa02).

   ELSE.

     MESSAGE i005(z_alfa02).

   ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form CM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM cm USING p_inform_banco type ZIB_ALFA02.

    p_inform_banco-usuario_res = sy-uname.

    p_inform_banco-fecha_eje   = sy-datum.

    p_inform_banco-sociedad = p_soc.

    p_inform_banco-ejercicio = p_ejer.

    p_inform_banco-per_cont = p_perio.

    p_inform_banco-tipo_ejec = COND #( WHEN p_acre EQ 'X' THEN 'A' ELSE 'D').

ENDFORM.
*&---------------------------------------------------------------------*
*& Form READ_RECORD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GWA_INFORM_BANCO
*&---------------------------------------------------------------------*
FORM read_record  USING p_gwa_inform_banco type ZIB_ALFA02.

  SELECT SINGLE * FROM zib_alfa02
    INTO  p_gwa_inform_banco
    WHERE sociedad = p_soc AND ejercicio = p_ejer AND per_cont = p_perio.

ENDFORM.
