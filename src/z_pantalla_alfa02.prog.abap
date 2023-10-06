*&---------------------------------------------------------------------*
*& Report Z_PANTALLA_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_PANTALLA_ALFA02.

INCLUDE Z_PANTALLA_ALFA02_TOP.

INCLUDE Z_PANTALLA_ALFA02_sel.

INCLUDE z_pantalla_alfa02_f01.


INITIALIZATION.

  PERFORM inicializar_variables.


AT SELECTION-SCREEN ON P_APE1.

  IF P_APE1 CA '0123456789'.

  MESSAGE  E000(ZALFA02).

  ENDIF.

  AT SELECTION-SCREEN ON P_APE2.

  IF P_APE2 CA '0123456789'.

    MESSAGE E000(ZALFA02).

  ENDIF.

AT SELECTION-SCREEN ON P_NOMBRE.

  IF P_NOMBRE CA '0123456789'.

    MESSAGE E000(ZALFA02).

  ENDIF.

START-OF-SELECTION.

PERFORM obtener_datos.

IF P_CREATE EQ ABAP_TRUE OR P_MODIFY EQ ABAP_TRUE.

  PERFORM datos_empleado2 using gwa_empleado.

ENDIF.

CASE 'X'.  " abap_true.

  WHEN P_CREATE.

    INSERT zemp_ALFA02 FROM GWA_EMPLEADO.

      IF SY-SUBRC EQ 0.

        MESSAGE I002(ZALFA02).

      ELSE.

        MESSAGE I003(ZALFA02).

      ENDIF.

  WHEN P_READ.

    IF SY-SUBRC EQ 0.

    WRITE: / 'N° ID = ', GWA_EMPLEADO-ID,
           / 'Email = ', GWA_EMPLEADO-EMAIL,
           / 'Primer apellido = ', GWA_EMPLEADO-APE1,
           / 'Segundo apellido = ', GWA_EMPLEADO-APE2,
           / 'Nombre = ',GWA_EMPLEADO-NOMBRE,
           / 'Fecha nacimiento = ', GWA_EMPLEADO-FECHAN,
           / 'Fecha de alta = ', GWA_EMPLEADO-FECHANN.

  ELSE.

    MESSAGE I005(ZALFA02).

  ENDIF.

  WHEN P_Update.

    UPDATE ZEMP_ALFA02 SET NOMBRE = P_NOMBRE
            WHERE ID EQ P_DNI.

    IF SY-SUBRC EQ 0.

    MESSAGE I006(ZALFA02).

    ELSE.

      MESSAGE I007(ZALFA02).

    ENDIF.

   WHEN P_DELETE.

     IF SY-SUBRC EQ 0.

       DELETE zemp_Alfa02 FROM GWA_EMPLEADO.

       IF SY-SUBRC EQ 0.

         MESSAGE I008(ZALFA02).

       ELSE.

         MESSAGE I009(ZALFA02).

       ENDIF.

       ELSE.

         MESSAGE I009(ZALFA02).

     ENDIF.

   WHEN P_MODIFY.

    MODIFY ZEMP_ALFA02 FROM GWA_EMPLEADO.

    IF SY-SUBRC EQ 0.

        MESSAGE I010(ZALFA02).

    ENDIF.

ENDCASE.

INCLUDE z_pantalla_alfa02_datosf01.
