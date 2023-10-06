*&---------------------------------------------------------------------*
*& Report Z_PANTALLAS_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_PANTALLAS_ALFA02.

tables: trdir,
        TSTC.


SELECTION-SCREEN BEGIN OF BLOCK block1.

PARAMETERS: P_APE1   TYPE C LENGTH 20 OBLIGATORY, " Primer apellido
            P_APE2   TYPE C LENGTH 20, " Segundo Apellido
            P_NOMBRE TYPE C LENGTH 30. " Nombre


SELECTION-SCREEN SKIP.

* Fecha de nacimiento
PARAMETERS P_FECHA TYPE sydatum.

* No de documento identificativo
PARAMETERS P_DNI TYPE C LENGTH 15.

* Domicilio
PARAMETERS P_DOMICI TYPE C LENGTH 50.

* Correo electrónico
PARAMETERS P_EMAIL TYPE C LENGTH 30.

*&---------------------------------------------------------------------*
*& DATOS RELATIVOS A LA SOLICITUD DE ALTA
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  TIPO DE CONTRATO Y BENEFICIOS
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& TIPO DE CONTRATO
*&---------------------------------------------------------------------*

SELECTION-SCREEN SKIP.

PARAMETERS: P_CNTR_I RADIOBUTTON GROUP CNTR, " Indefinifo
            P_CNTR_T RADIOBUTTON GROUP CNTR DEFAULT 'X', " Temporal
            P_CNTR_P RADIOBUTTON GROUP CNTR. " Prácticas

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF LINE.

* Beneficios
PARAMETERS P_TIK_R TYPE C AS CHECKBOX DEFAULT 'X'. " Tiket restaurant
SELECTION-SCREEN COMMENT (22) c_tik_r.

PARAMETERS P_SEG_M TYPE C AS CHECKBOX. " seguro médico
SELECTION-SCREEN COMMENT (22) c_seg_m.

PARAMETERS P_FRM_P TYPE C AS CHECKBOX. " Formación profesional
SELECTION-SCREEN COMMENT (22) c_frm_p.

SELECTION-SCREEN END OF LINE.
*&---------------------------------------------------------------------*
*& Datos relativos a la actividad laboral
*&---------------------------------------------------------------------*
SELECTION-SCREEN SKIP.

PARAMETERS: P_HORAS TYPE I, " salario semanal
            P_SAL_M TYPE I. " salario mensual

* Fecha de alta
PARAMETERS P_FECHAA TYPE SYDATUM.

selection-SCREEN skip.

* Permisos
SELECT-OPTIONS:  s_prog for trdir-name, " Programas
                 s_tcode for tstc-tcode. " Códigos de transacción

SELECTION-SCREEN END OF BLOCK block1.

INITIALIZATION.

  p_fechaa = sy-datum.

  c_tik_r =  text-c01."Tiket restaurant

  c_seg_m = text-c02."Seguro médico

  c_frm_p = text-c03."Formación profesional


AT SELECTION-SCREEN ON P_APE1.

  if p_ape1 CA '0123456789'.
    MESSAGE e000(ALFA02).
  ENDIF.

  AT SELECTION-SCREEN ON p_ape2.

    if p_ape2 CA '013456789'.
       MESSAGE e000(ALFA02).
    endif.

    AT SELECTION-SCREEN ON P_NOMBRE.

      if p_nombre CA '0123456789'.
        Message e000(ALFA02).
      ENDIF.

START-OF-SELECTION.


data gwa_empleado type zemp_ALFA02.

* gwa_empleado-id = ''.


gwa_empleado-id = p_dni.
gwa_empleado-email = p_email.
gwa_empleado-ape1 = p_ape1.
gwa_empleado-ape2 = p_ape2.
gwa_empleado-nombre = p_nombre.
gwa_empleado-FECHANN = P_FECHA.
gwa_empleado-FECHAN = p_fechaa.

INSERT zemp_ALFA02 FROM gwa_empleado.

if sy-subrc eq 0.
   MESSAGE i001(ZALFA02).

else.
   MESSAGE i002(ZALFA02).
endif.

"START-OF-SELECTION.

"write 'FIN'.

*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*



*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
