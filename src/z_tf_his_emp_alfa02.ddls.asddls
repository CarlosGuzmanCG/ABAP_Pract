@EndUserText.label: 'TABLE FUNCTION EMP REC'
define table function Z_TF_HIS_EMP_ALFA02
with parameters
@Environment.systemField: #CLIENT
clnt : abap.clnt,

sel_options : abap.char( 1000 )

returns {
    MANDT : abap.clnt;
    ID_EMPLEADO : za23_id_empleado;
    NOMBRE : za23_nombre;
    APELLIDO_PATERNO : za23_apellido_pat ;
    APELLIDO_MATERNO : za23_apellido_mat;
    FECHA_REGISTRO : za23_fecha_registro;
    FECHA_BAJA : za23_fecha_baja;
    ID_ASIGNACION : za23_id_asignacion;
    FECHA_INICIO : za23_fecha_inicio;
    FECHA_FIN : za23_fecha_fin;
    ID_PUESTO : za23_id_puesto;
    NOMBRE_PUESTO : za23_nombre_puesto;
    ID_AREA : za23_id_area;
    NOMBRE_AREA : za23_nombre_area;
    ID_HORARIO : za23_id_horario;
    TURNO : za23_turno; 
    
}

implemented by method ZCS_SO_FT_EMP_REC_ALFA02=>get_flights;
