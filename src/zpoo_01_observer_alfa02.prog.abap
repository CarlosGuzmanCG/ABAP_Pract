*&---------------------------------------------------------------------*
*& Report ZPOO_01_OBSERVER_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPOO_01_OBSERVER_ALFA02.

class lcl_blog definition.

  public section.

  METHODS publicar_articulo IMPORTING articulo TYPE string.

  EVENTS nuevo_articulo EXPORTING value(nuevo_articulo) TYPE string.

  PRIVATE SECTION.

  DATA articulo TYPE string.

endclass.

class lcl_blog implementation.

  METHOD publicar_articulo.

      me->articulo = articulo.

      WRITE: / 'Nuevo artículo publicado.', articulo.

      RAISE EVENT nuevo_articulo EXPORTING nuevo_articulo = articulo.

 ENDMETHOD.

endclass.

class lcl_observador definition ABSTRACT.

  public section.

    METHODS on_nuevo_articulo ABSTRACT

    FOR EVENT nuevo_articulo OF lcl_blog IMPORTING nuevo_articulo.

endclass.

CLASS lcl_administrador DEFINITION INHERITING FROM lcl_observador.

    PUBLIC SECTION.

    METHODS on_nuevo_articulo REDEFINITION.

ENDCLASS.

CLASS lcl_administrador IMPLEMENTATION.

    METHOD on_nuevo_articulo.


      WRITE : / 'Revisar artículo->ADMIN. ', nuevo_articulo.

 ENDMETHOD.

ENDCLASS.


CLASS lcl_usuarios DEFINITION INHERITING FROM lcl_observador.

 PUBLIC SECTION.

 METHODS on_nuevo_articulo REDEFINITION.

 ENDCLASS.

 CLASS lcl_usuarios IMPLEMENTATION.

 METHOD on_nuevo_articulo.

 WRITE : / 'USUARIO -> AVISO -> ARTICULO NUEVO.....', nuevo_articulo.

 ENDMETHOD.

ENDCLASS.


START-OF-SELECTION.


 DATA: gr_blog TYPE REF TO lcl_blog,
       gr_admin TYPE REF TO lcl_administrador,
       gr_usuarios TYPE REF TO lcl_usuarios.


 CREATE OBJECT: gr_blog, gr_admin, gr_usuarios.

 SET HANDLER: gr_admin->on_nuevo_articulo FOR gr_blog,

 gr_usuarios->on_nuevo_articulo FOR gr_blog.

 gr_blog->publicar_articulo( articulo = 'Nuevo articulo 1111' ).
