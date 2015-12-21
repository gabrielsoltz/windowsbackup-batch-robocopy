@echo off
setlocal enabledelayedexpansion enableextensions

REM FECHA
FOR /F "skip=1" %%x IN ('wmic os get localdatetime') do IF NOT DEFINED MyDate set MyDate=%%x
set DATE=%MyDate:~0,4%%MyDate:~6,2%%MyDate:~4,2%
SET STARTTIME=%TIME%

REM LOGGING (SETEAR EL PATH AL ACRCHIVO DE LOG)
SET LOG=C:\Users\Administrator\Desktop\BACKUP\!DATE!-BKP.LOG
echo ------------------------------------------------------- > !LOG!
echo INICIO DEL PROCESO DE BACKUP ----------------------- >> !LOG!
echo FECHA: !STARTTIME! >> !LOG!
echo ------------------------------------------------------- >> !LOG!


REM DATOS A BACKUPEAR
REM DESTINATION = DESTINO
SET DESTINATION="Z:\BKP\!DATE!"
REM SOURCEPATH = PATH DE ORIGEN
SET SOURCEPATH=\\<IP-SERVERORIGEN>
REM SOURCE[N] = PATH DE ORIGEN, DESPUES DEL SOURCEPATH. SI CAMBIAN LA CANTIDAD DE N, MODIFICAR EL FOR.
SET SOURCE[0]=E
SET SOURCE[1]=F
SET SOURCE[2]=G

for /l %%n in (0,1,2) do (
    echo ------ INICIO BACKUP: !SOURCEPATH!\!SOURCE[%%n]! TO !DESTINATION!\!SOURCE[%%n]! >> !LOG!
    robocopy !SOURCEPATH!\!SOURCE[%%n]! !DESTINATION!\!SOURCE[%%n]! /COPYALL /XA:SH /E /R:2 /W:30 /XD "$RECYCLE.BIN" "System Volume Information" "RECYCLER" >> !LOG!

    REM CONTROL DE ERRORES
    if %ERRORLEVEL% EQU 16 echo ***FATAL ERROR*** >> !LOG!
    if %ERRORLEVEL% EQU 15 echo OKCOPY + FAIL + MISMATCHES + XTRA >> !LOG!
    if %ERRORLEVEL% EQU 14 echo FAIL + MISMATCHES + XTRA >> !LOG!
    if %ERRORLEVEL% EQU 13 echo OKCOPY + FAIL + MISMATCHES >> !LOG!
    if %ERRORLEVEL% EQU 12 echo FAIL + MISMATCHES >> !LOG!
    if %ERRORLEVEL% EQU 11 echo OKCOPY + FAIL + XTRA >> !LOG!
    if %ERRORLEVEL% EQU 10 echo FAIL + XTRA >> !LOG!
    if %ERRORLEVEL% EQU 9 echo OKCOPY + FAIL >> !LOG!
    if %ERRORLEVEL% EQU 8 echo FAIL >> !LOG!
    if %ERRORLEVEL% EQU 7 echo OKCOPY + MISMATCHES + XTRA >> !LOG!
    if %ERRORLEVEL% EQU 6 echo MISMATCHES + XTRA >> !LOG!
    if %ERRORLEVEL% EQU 5 echo OKCOPY + MISMATCHES >> !LOG!
    if %ERRORLEVEL% EQU 4 echo MISMATCHES >> !LOG!
    if %ERRORLEVEL% EQU 3 echo OKCOPY + XTRA >> !LOG!
    if %ERRORLEVEL% EQU 2 echo XTRA >> !LOG!
    if %ERRORLEVEL% EQU 1 echo OKCOPY >> !LOG!
    if %ERRORLEVEL% EQU 0 echo No Change >> !LOG!
)

REM FECHA
FOR /F "skip=1" %%x IN ('wmic os get localdatetime') do IF NOT DEFINED MyDate set MyDate=%%x
set ENDDATE=%MyDate:~0,4%%MyDate:~6,2%%MyDate:~4,2%
SET ENDTIME=%TIME%

REM LOGGING
echo ------------------------------------------------------- > !LOG!
echo FIN DEL PROCESO DE BACKUP ----------------------- >> !LOG!
echo FECHA: !ENDDATE! !ENDTIME! >> !LOG!
echo ------------------------------------------------------- >> !LOG!
