@REM  win11down
rem w11down.cmd
@echo off
rem Win11 script
set scriptver=0.0.99
title %~nx0  v%scriptver%

set Debug=0


@REM  call the "setvars.cmd" file in the Scripts directory
@REM call %CPS%\setvars.cmd

IF /I %debug% == 1 (
echo.
echo my project name is %ProjectName%
pause
)
color 0A

IF /I %debug% == 1 (
echo cps = %CPS%
echo cp = %CP%
)

@REM echo MCTool = %MCTool%
set "MCTool=%CP%\MCT"

@REM  ################# MediaCreationTool
START /wait  "wd11" cmd /c %MCTool%\MediaCreationToolwin11.cmd

TIMEOUT /T 10

@REM Check if media is running
:LOOP
tasklist /fi "imagename eq Media*" |find ":" > nul 2>&1
echo ERRORLEVEL = %ERRORLEVEL%
@REM pause
IF ERRORLEVEL 1 (
  ECHO MediaCreationTool is still running
  TIMEOUT /T 5
@REM   loop if media still running
  GOTO LOOP
)
@REM ELSE (

    GOTO CONTINUE

:CONTINUE

echo end of MediaCreationTool for now

@REM  ################# MediaCreationTool


echo entering checkpidcmd
echo.
echo ##########################

@REM Check if cmd is running
 :checkpidcmd
@REM  set  "%%K="
 set "mypid="
for /F "tokens=2" %%K in ('
   tasklist /FI "ImageName eq cmd.exe" /FI "Status eq Running" /FO LIST ^| findstr /B "PID:"
') do (
	set "mypid=%%K"
   echo %%K
   TIMEOUT /T 5
   @REM loop if cmd is still running
   goto :checkpidcmd

   )

@REM echo ERRORLEVEL cmd = %ERRORLEVEL%

echo no check cmd running
TIMEOUT /T 5

IF /I %debug% == 1 (
TIMEOUT /T 5

pause
)

@REM @REM check if iso exists

@REM call :checkiso

@REM @REM pause


@REM goto :quit

@REM :checkiso
@REM @REM debug
@REM @REM  check if win 11 exists
@REM @REM  check that ISO file exists before proceeding
@REM set "testfile=*.iso"
@REM @REM set "testfile=*.txt"
@REM echo MCTool = %MCTool%
@REM echo testfile = %testfile%
@REM @REM pause
@REM REM find file
@REM @REM IF /I %debug% == 1 (
@REM IF EXIST "%MCTool%\%testfile%" (
@REM   ECHO file %testfile% exists & goto runcode
@REM ) ELSE (
@REM   ECHO file %testfile% does not exist &  TIMEOUT /T 5 & goto :DONE
@REM )
@REM @REM echo nope
@REM @REM pause
@REM @REM )

@REM @REM pause
@REM :DONE

@REM @REM create error level 1
@REM color 00
@REM echo ERRORLEVEL = %ERRORLEVEL%
@REM set "downWin11=no"
@REM  TIMEOUT /T 10

@REM :runcode

@REM :quit