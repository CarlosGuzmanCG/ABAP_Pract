*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZFACT_ALFA02....................................*
DATA:  BEGIN OF STATUS_ZFACT_ALFA02                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZFACT_ALFA02                  .
CONTROLS: TCTRL_ZFACT_ALFA02
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZFACT_ALFA02                  .
TABLES: ZFACT_ALFA02                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
