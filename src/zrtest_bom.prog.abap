*&---------------------------------------------------------------------*
*& Report ZRTEST_BOM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRTEST_BOM.

DATA : BEGIN OF GS_DATA,
         ITEMPARENT_CD TYPE I,
         ITEMCHILD_CD  TYPE I,
         BOM_SQ        TYPE I,
         JUST_QT       TYPE I,
         USE_YN        TYPE I,
         REMARK_DC(255),
       END OF GS_DATA.

DATA : GT_DATA LIKE TABLE OF GS_DATA.

DATA : LX_EXEC TYPE REF TO CX_ROOT.

DATA : LV_MSG TYPE STRING.

DATA : BEGIN OF GS_DATA2,
          ONo  TYPE I,
          OPos TYPE I,

          PlanndeStart(100),
          PlanndeEnd(100),
          Start(100),
          End(100),
       END OF GS_DATA2.

DATA GT_DATA2 LIKE TABLE OF GS_DATA2.

"MSSQL CONNECT
  EXEC SQL.

    CONNECT TO 'MSSQL2'
  ENDEXEC.
  IF SY-SUBRC <> 0.
     MESSAGE 'CONNECT FAIL' TYPE 'S' DISPLAY LIKE 'E'.
     EXIT.
  ENDIF.

"덤프방지
*TRY.
*EXEC SQL.
*  DELETE FROM sapout.BOM
*ENDEXEC.
*
*LOOP AT GT_DATA INTO GS_DATA.
*
**"DATA INSERT
**  EXEC SQL.
**   INSERT INTO sapout.BOM
**               (ITEMPARENT_CD, ITEMCHILD_CD, BOM_SQ,
**                JUST_QT, USE_YN, REMARK_DC)
**          VALUES (1000, 2, 1, 1, 1, '{ FFFF }')
**  ENDEXEC.
*
*EXEC SQL.
*   INSERT INTO sapout.BOM
*               (ITEMPARENT_CD, ITEMCHILD_CD, BOM_SQ,
*                JUST_QT, USE_YN, REMARK_DC)
*          VALUES (:GS_DATA-ITEMPARENT_CD,
*                  :GS_DATA-ITEMCHILD_CD,
*                  :GS_DATA-BOM_SQ,
*                  :GS_DATA-JUST_QT,
*                  :GS_DATA-USE_YN,
*                  :GS_DATA-REMARK_DC)
*  ENDEXEC.
*ENDLOOP.
*CATCH CX_SY_NATIVE_SQL_ERROR INTO LX_EXEC.
*    LV_MSG = LX_EXEC->GET_TEXT( ).
*    MESSAGE LV_MSG TYPE 'S' DISPLAY LIKE 'E'.
*ENDTRY.
*
* IF LV_MSG IS INITIAL.
*    EXEC SQL.
*      COMMIT
*    ENDEXEC.
* ELSE.
*    EXEC SQL.
*      ROLLBACK
*    ENDEXEC.
* ENDIF.

 "PART 1 SELECT
 EXEC SQL.
   OPEN dbcur FOR
     SELECT ONo, OPos, PlanedStart, PlanedEnd,
            Start, [End]
     FROM sapin.OrderPos
 ENDEXEC.

 "PART 2 -> FETCH ~ : SELECT 한 라인씩 입력
 DO.
   EXEC SQL.
     FETCH NEXT dbcur INTO :GS_DATA2
   ENDEXEC.
   IF SY-SUBRC <> 0.
      EXIT.
   ENDIF.

   APPEND GS_DATA2 TO GT_DATA2.
 ENDDO.

"PART 3 닫기
 EXEC SQL.
   CLOSE dbcur
 ENDEXEC.

 EXEC SQL.
   DISCONNECT 'MSSQL2'
 ENDEXEC.
  IF SY-SUBRC <> 0.
     MESSAGE 'CONNECT FAIL' TYPE 'S' DISPLAY LIKE 'E'.
     EXIT.
  ENDIF.
