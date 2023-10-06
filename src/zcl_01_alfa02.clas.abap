CLASS zcl_01_alfa02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    class-methods get_materials for TABLE FUNCTION ZB_13_ALFA02.
ENDCLASS.



CLASS zcl_01_alfa02 IMPLEMENTATION.

    METHOD get_materials by DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY USING mard.

    RETURN SELECT mandt AS Client,
     matnr AS Material,
     pstat AS MaintenanceStatus,
     lfgja AS FiscalYear
     FROM mard
     WHERE mandt = :clnt
     AND werks = :Plant
     AND lgort = :StorageLocation
     ORDER BY lfgja DESC;


    ENDMETHOD.

ENDCLASS.
