class ZCX_ACCESO_ALFA02 definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

public section.

  interfaces IF_T100_DYN_MSG .
  interfaces IF_T100_MESSAGE .

  constants:
    begin of ZCX_ACCESO_ALFA02,
      msgid type symsgid value 'ZMSJ1_ALFA02',
      msgno type symsgno value '000',
      attr1 type scx_attrname value 'MSGV1',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of ZCX_ACCESO_ALFA02 .
  data MSGV1 type MSGV1 .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !MSGV1 type MSGV1 optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_ACCESO_ALFA02 IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->MSGV1 = MSGV1 .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = ZCX_ACCESO_ALFA02 .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
