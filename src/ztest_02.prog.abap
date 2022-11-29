*&---------------------------------------------------------------------*
*& Report ZTEST_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTEST_02.

DATA : GV_SNRO(3).
DATA : GV_WO(5).

CALL FUNCTION 'NUMBER_GET_NEXT'
  EXPORTING
    NR_RANGE_NR                   = '01'
    OBJECT                        = 'ZNR_05'
*   QUANTITY                      = '1'
*   SUBOBJECT                     = ' '
*   TOYEAR                        = '0000'
*   IGNORE_BUFFER                 = ' '
 IMPORTING
   NUMBER                        = GV_SNRO
*   QUANTITY                      =
*   RETURNCODE                    =
* EXCEPTIONS
*   INTERVAL_NOT_FOUND            = 1
*   NUMBER_RANGE_NOT_INTERN       = 2
*   OBJECT_NOT_FOUND              = 3
*   QUANTITY_IS_0                 = 4
*   QUANTITY_IS_NOT_1             = 5
*   INTERVAL_OVERFLOW             = 6
*   BUFFER_OVERFLOW               = 7
*   OTHERS                        = 8
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.

CONCATENATE 'WO' GV_SNRO INTO GV_WO.

MESSAGE 'HI!' TYPE 'S'.
