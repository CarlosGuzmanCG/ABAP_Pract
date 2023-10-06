*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVA_MARD1_ALFA02................................*
TABLES: ZVA_MARD1_ALFA02, *ZVA_MARD1_ALFA02. "view work areas
CONTROLS: TCTRL_ZVA_MARD1_ALFA02
TYPE TABLEVIEW USING SCREEN '0003'.
DATA: BEGIN OF STATUS_ZVA_MARD1_ALFA02. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVA_MARD1_ALFA02.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVA_MARD1_ALFA02_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVA_MARD1_ALFA02.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVA_MARD1_ALFA02_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVA_MARD1_ALFA02_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVA_MARD1_ALFA02.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVA_MARD1_ALFA02_TOTAL.

*.........table declarations:.................................*
TABLES: MARD                           .
