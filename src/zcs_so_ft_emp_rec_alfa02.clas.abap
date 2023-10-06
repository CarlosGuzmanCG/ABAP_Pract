CLASS zcs_so_ft_emp_rec_alfa02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

    PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_flights FOR TABLE FUNCTION Z_TF_HIS_EMP_ALFA02.


ENDCLASS.



CLASS zcs_so_ft_emp_rec_alfa02 IMPLEMENTATION.

  METHOD get_flights by DATABASE FUNCTION
                     FOR HDB LANGUAGE SQLSCRIPT
                     OPTIONS READ-ONLY
                     USING  ZA23_EMPLEADOS
                      ZA23_ASIGNACION
                       ZA23_PUESTOS
                        ZA23_AREAS
                         ZA23_HORARIOS
                        .

                        lt_fil = APPLY_FILTER (
                         ZA23_EMPLEADOS , :sel_options );


        return select  db_emp.mandt,
                        db_emp.ID_EMPLEADO,
                        db_emp.NOMBRE,
                        db_emp.APELLIDO_PATERNO,
                        db_emp.APELLIDO_MATERNO,
                        db_emp.FECHA_REGISTRO,
                        db_emp.FECHA_BAJA,
                        db_asig.ID_ASIGNACION,
                        db_asig.FECHA_INICIO,
                        db_asig.FECHA_FIN,
                        db_job.ID_PUESTO,
                        db_job.NOMBRE_PUESTO,
                        db_area.ID_AREA,
                        db_area.NOMBRE_AREA,
                        db_sched.ID_HORARIO,
                        db_sched.TURNO
                        from "ZA23_EMPLEADOS" as db_emp
                        inner join "ZA23_ASIGNACION" AS db_asig
                        on db_emp.id_empleado = db_asig.id_empleado
                        inner join "ZA23_PUESTOS" as db_job
                        on db_asig.id_puesto = db_job.id_puesto
                        inner join "ZA23_AREAS" as db_area
                        on db_job.id_area = db_area.id_area
                        inner join "ZA23_HORARIOS" as db_sched
                        on db_asig.id_horario = db_sched.id_horario;

  ENDMETHOD.

ENDCLASS.
