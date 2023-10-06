*&---------------------------------------------------------------------*
*& Report ZTEST_REG_NOMINA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTEST_REG_NOMINA.

  data: dias_trabajados type i.


*PARA OBTENER LOS DIAS DEL TRABAJADOS DEL EMPLEADO
*  select single count( id_asistencia ) from za23_asistencias
*     where id_empleado  eq '47' and tipo_asistencia eq 'PRESENTE' into @Data(data).
*
*
*select emp~id_empleado, emp~nombre, emp~apellido_paterno, emp~apellido_materno
*  from za23_empleados as emp inner join za23_asigemp as asig on
*
*  emp~id_empleado eq asig~id_empleado inner join za23_asistencias as asistencia on
*asistencia~id_empleado eq emp~id_empleado
*
*
*  where asig~status eq 'ACT' and asistencia~tipo_asistencia
*
*  eq 'PRESENTE'
*    into table @data(data).

SELECT emp~id_empleado, emp~nombre, emp~apellido_paterno, emp~apellido_materno
  FROM za23_empleados AS emp
  INNER JOIN za23_asigemp AS asig ON emp~id_empleado = asig~id_empleado

  INNER JOIN za23_asistencias as asistencia on
asistencia~id_empleado eq emp~id_empleado


  WHERE asig~status = 'ACT'
    AND emp~id_empleado IN (
      SELECT id_empleado
      FROM za23_asistencias
      WHERE tipo_asistencia = 'PRESENTE' and id_empleado = '47'
    )
  INTO TABLE @data(data).




    cl_demo_output=>display( data ).
