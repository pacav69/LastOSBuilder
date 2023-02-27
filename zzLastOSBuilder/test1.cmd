@echo off


rem This first for routine will give the current path without a trailing \
%~d0
cd "%~dp0"
cd %~dps0
for %%f in ("%CD%") do set CP=%%~sf
rem CPS= CP Scripts
set CPS=%CP%\scripts
echo cp = %CP%

@REM call %CPS%\testwin11down.cmd

call %CPS%\testw11final.cmd

echo now finished downloading
call :checkiso
pause

@REM START /wait  "wd11" cmd /c %MCTool%\MediaCreationToolwin11.cmd

goto :quit

:checkiso
@REM debug
@REM  check if win 11 exists
@REM  check that ISO file exists before proceeding
set "testfile=*.iso"
@REM set "testfile=*.txt"
echo MCTool = %MCTool%
echo testfile = %testfile%
@REM pause
REM find file
@REM IF /I %debug% == 1 (
IF EXIST "%MCTool%\%testfile%" (
  ECHO file %testfile% exists & goto runcode
) ELSE (
  ECHO file %testfile% does not exist &  TIMEOUT /T 5 & goto :DONE
)
@REM echo nope
@REM pause
@REM )

@REM pause
:DONE

@REM create error level 1
color 00
echo ERRORLEVEL = %ERRORLEVEL%
 TIMEOUT /T 10

:runcode

:quit
