*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZEMPLE_ALFA02...................................*
DATA:  BEGIN OF STATUS_ZEMPLE_ALFA02                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZEMPLE_ALFA02                 .
CONTROLS: TCTRL_ZEMPLE_ALFA02
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZEMPLE_ALFA02                 .
TABLES: ZEMPLE_ALFA02                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
