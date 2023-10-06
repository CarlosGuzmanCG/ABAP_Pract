*&---------------------------------------------------------------------*
*& Include          ZBI_VIRT_USUARIO_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form init_2000
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_2000 .

  check ok_code is not INITIAL.

  CASE ok_code.

    WHEN 'LIB_P'.
      PERFORM LIBROS_DE_PAPEL.
    WHEN ''.

    WHEN ''.

    WHEN ''.

    WHEN OTHERS.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form LIBROS_DE_PAPEL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM libros_de_papel .

  PERFORM INSTANCE_CUST_CONT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INSTANCE_CUST_CONT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM instance_cust_cont .

  create OBJECT go_custom_container
    EXPORTING
*      parent                      =                  " Parent container
      container_name              =   'ALV_CONT'               " Name of the Screen CustCtrl Name to Link Container To
*      style                       =                  " Windows Style Attributes Applied to this Container
*      lifetime                    = lifetime_default " Lifetime
*      repid                       =                  " Screen to Which this Container is Linked
*      dynnr                       =                  " Report To Which this Container is Linked
*      no_autodef_progid_dynnr     =                  " Don't Autodefined Progid and Dynnr?
    EXCEPTIONS
      cntl_error                  = 1                " CNTL_ERROR
      cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
      create_error                = 3                " CREATE_ERROR
      lifetime_error              = 4                " LIFETIME_ERROR
      lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
      others                      = 6
    .
  IF SY-SUBRC <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
