*"* use this source file for your ABAP unit test classes
class ztest_Perimetro definition deferred.
class zcl_Areas_Fig_Geom_Alfa02 definition local friends ztest_Perimetro.

class ztest_Perimetro definition for testing
  duration short
  risk level harmless
.
*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>ztest_Perimetro
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>ZCL_AREAS_FIG_GEOM_ALFA02
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE>X
*?</GENERATE_FIXTURE>
*?<GENERATE_CLASS_FIXTURE>X
*?</GENERATE_CLASS_FIXTURE>
*?<GENERATE_INVOCATION>X
*?</GENERATE_INVOCATION>
*?<GENERATE_ASSERT_EQUAL>X
*?</GENERATE_ASSERT_EQUAL>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  private section.
    data:
      f_Cut type ref to zcl_Areas_Fig_Geom_Alfa02.  "class under test

    class-methods: class_Setup.
    class-methods: class_Teardown.
    methods: setup.
    methods: teardown.
    methods: perimetro_Rectangulo for testing.
endclass.       "ztest_Perimetro


class ztest_Perimetro implementation.

  method class_Setup.



  endmethod.


  method class_Teardown.



  endmethod.


  method setup.


    create object f_Cut.
  endmethod.


  method teardown.



  endmethod.


  method perimetro_Rectangulo.

    data base type i.
    data altura type i.
    data resultado type i.

    base = 10.

    altura = 6.

    f_Cut->perimetro_Rectangulo(
      EXPORTING
        BASE = base
        ALTURA = altura
     IMPORTING
       RESULTADO = resultado
    ).

    cl_Abap_Unit_Assert=>assert_Equals(
      act   = 32
      exp   = resultado          "<--- please adapt expected value
     msg   = 'Testing value resultado'
*     level =
    ).
  endmethod.




endclass.
