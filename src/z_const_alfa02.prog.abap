*&---------------------------------------------------------------------*
*& Report Z_CONST_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_CONST_ALFA02.

 CONSTANTS: const_D Type D VALUE '20230119',
           const_T Type T VALUE '113443',
           const_I Type I VALUE 23,
           const_Dec16 Type DECFLOAT16 VALUE '12.32',
           const_Dec34 Type DECFLOAT34 VALUE '12.36',
           const_String Type STRING VALUE 'HOLA MUNDO',
           const_Xstring Type XSTRING VALUE 'FFF',
           const_C Type C LENGTH 2 VALUE 'US',
           const_P Type P LENGTH 7 DECIMALS 2 VALUE '234.543',
           const_N Type N LENGTH 4 VALUE '4321',
           const_X Type X LENGTH 2 VALUE 'DF1'.

WRITE: const_D DD/MM/YYYY,
      / const_T ENVIRONMENT TIME FORMAT,
      / const_I,
      / const_Dec16,
      / const_Dec34,
      / const_String,
      / const_Xstring,
      / const_C,
      / const_P,
      / const_N,
      / const_X.
