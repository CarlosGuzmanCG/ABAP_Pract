*----------------------------------------------------------------------*
***INCLUDE Z_PANTALLA_ALFA02_F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form inicializar_variables
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM inicializar_variables .

C_TIK_R = 'Ticket restaurant'.
C_SEG_M = 'Seguro médico'.
C_FRM_P = 'Formación profesional'.

P_FECHAA = SY-DATUM.

ENDFORM.

FORM obtener_datos.

*(P_READ) OR (P_DELETE) OR (P_UPDATE)
IF P_READ EQ ABAP_TRUE OR P_DELETE EQ ABAP_TRUE OR P_UPDATE EQ ABAP_TRUE.
* abap_true -- true
SELECT SINGLE * FROM ZEMP_ALFA02
            INTO GWA_EMPLEADO
            WHERE ID EQ P_DNI.

ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form datos_empleado2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GWA_EMPLEADO
*&---------------------------------------------------------------------*
FORM datos_empleado2  USING p_empleado type ZEMP_ALFA02.

    GWA_EMPLEADO-ID = p_dni.
    GWA_EMPLEADO-EMAIL = p_mail.
    GWA_EMPLEADO-APE1 = p_ape1.
    GWA_EMPLEADO-APE2 = p_ape2.
    GWA_EMPLEADO-NOMBRE = p_ape2.
    GWA_EMPLEADO-FECHAN  = p_fechan.
    GWA_EMPLEADO-FECHANN = p_fechaa.

ENDFORM.
