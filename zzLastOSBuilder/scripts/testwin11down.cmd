@REM test win11down
rem source.cmd
@echo off
rem Win11 script
set scriptver=0.0.99
title %~nx0  v%scriptver%

set Debug=0

@REM IF /I %debug% == 1 (

@REM echo. ########################################
@REM echo my project name is %ProjectName%
@REM echo MCTool = %MCTool%
@REM echo ISO = %ISO%
@REM echo. ########################################
@REM pause

@REM )
@REM ELSE
@REM (goto startcode)


@REM :startcode

@REM  call the "setvars.cmd" file in the Scripts directory
call %CPS%\setvars.cmd
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
@REM echo MCTool = %MCTool%

@REM pause

::
set "MCTool=%CP%\MCT"
echo starthere
@REM pause

@REM
@REM commandA || commandB	Run commandA, if it fails then run commandB
@REM commandA && commandB || commandC

@REM If commandA succeeds run commandB, if commandA fails run commandC
@REM Note that if commandB fails, that will also trigger running commandC.

@REM Success and failure are based on the Exit Code of the command.
@REM this sets ERRORLEVEL to 1
@REM && COLOR 00

@REM START  "w11" /Wait  cmd /c  "%MCTool%\MediaCreationToolwin11.cmd" && echo  ERRORLEVEL =  %ERRORLEVEL% || COLOR 00

@REM START  /Wait "wd11"   cmd /c  "%CPS%\testcmd.cmd" && echo  ERRORLEVEL =  %ERRORLEVEL% || COLOR 00
@REM START  /Wait "wd11"   cmd /c  "%CPS%\testcmd.cmd" && pause

@REM @Echo off & SetLocal EnableDelayedExpansion
@REM set "PID="
@REM for /f "tokens=2" %%A in ('tasklist ^| findstr /i "cmd.exe" 2^>NUL') do @Set "PID=!PID!,%%A"
@REM if defined PID Echo cmd.exe has PID(s) %PID:~1%

@REM pause

REM
REM DEMO - how to launch several processes in parallel, and wait until all of them finish.
REM

@ECHO OFF
@REM start "!The Title!" Echo Close me manually!
START  /Wait "wd11"   cmd /c  "%CPS%\testcmd.cmd"
@REM @REM && pause
@REM :waittofinish
@REM echo At least one process is still running...
@REM timeout /T 2 /nobreak >nul
@REM tasklist.exe /fi "WINDOWTITLE eq wd11" | find ":"
@REM >nul
@REM if errorlevel 1 goto waittofinish
@REM echo Finished!
@REM PAUSE



@REM @echo off
@REM for /F "tokens=2" %%K in ('
@REM    tasklist /FI "ImageName eq cmd.exe" /FI "Status eq Running" /FO LIST ^| findstr /B "PID:"
@REM ') do (
@REM    echo %%K
@REM )

@REM pause

@REM @echo off
@REM tasklist /fi "imagename eq cmd.exe" |find ":" > nul
@REM if errorlevel 1 echo errorlevel = %errorlevel%
@REM pause


@REM @REM START "" "C:\Program Files\Windows NT\Accessories\wordpad.exe"

@REM :LOOP
@REM tasklist /fi "imagename eq cmd.exe" |find ":" > nul 2>&1
@REM IF ERRORLEVEL 1 (
@REM   GOTO CONTINUE
@REM ) ELSE (
@REM   ECHO cmd is still running
@REM   TIMEOUT /T 5
@REM   GOTO LOOP
@REM )

@REM  #################
START /wait  "wd11" cmd /c %MCTool%\MediaCreationToolwin11.cmd
TIMEOUT /T 10

@REM Check if media is frunning
:LOOP
tasklist /fi "imagename eq Media*" |find ":" > nul 2>&1
echo ERRORLEVEL = %ERRORLEVEL%
@REM pause
IF ERRORLEVEL 1 (
  ECHO MediaCreationTool is still running
  TIMEOUT /T 5
  GOTO LOOP
)
@REM ELSE (

    GOTO CONTINUE

:CONTINUE

echo end of road for now

@REM  #################


echo entering loop2
echo.
echo ##########################

@REM @echo off
@REM    tasklist /FI "ImageName eq cmd.exe" /FI "Status eq Running" /FO LIST ^| findstr /B "PID:"

 :checkag
 set  "%%K="
for /F "tokens=2" %%K in ('
   tasklist /FI "ImageName eq cmd.exe" /FI "Status eq Running" /FO LIST ^| findstr /B "PID:"
') do (
	set "mypid=%%K"
@REM    echo %%K
   echo ERRORLEVEL cmd = %ERRORLEVEL%
@REM    COLOR 00
)
@REM echo pid = %%K
echo mypid = %mypid%

@REM @Echo off & SetLocal EnableDelayedExpansion
@REM set "PID="
@REM for /f "tokens=2" %%A in ('tasklist ^| findstr /i "cmd.exe" 2^>NUL') do @Set "PID=!PID!,%%A"
@REM if defined PID Echo cmd.exe has PID(s) %PID:~1%


   TIMEOUT /T 5
)
goto :checkag

@REM if %mypid% GTR 0 (goto :checkag)

	@REM echo mypid is now  = %mypid%
@REM 	   TIMEOUT /T 5
@REM )

@REM if %mypid% > 0(
@REM 	echo mypidis now  = %mypid%
@REM )




@REM 	if  %%K <> 0
@REM 	(
@REM 		echo not running cmd
@REM 		pause
@REM 	)else(
@REM 		echo still running
@REM 		TIMEOUT /T 5
@REM 		goto :checkag
@REM 	)
@REM )

@REM  :checkag2
@REM for /F "tokens=2" %%K in ('
@REM    tasklist /FI "ImageName eq cmd.exe" /FI "Status eq Running" /FO LIST ^| findstr /B "PID:"
@REM ') do (
@REM  echo %%K
@REM @REM  color 00
@REM )
@REM goto :checkag2
echo.
   echo ERRORLEVELoutofloop = %ERRORLEVEL%
	TIMEOUT /T 5

echo end of cmd check
pause

@REM :loop2
@REM tasklist /fi "imagename eq cmd.exe" |find ":" > nul 2>&1
@REM echo ERRORLEVELloop2 = %ERRORLEVEL%
@REM @REM pause
@REM IF ERRORLEVEL 1 (
@REM ECHO cmd is still running
@REM   TIMEOUT /T 5
@REM   GOTO loop2
@REM ) ELSE (
@REM 	GOTO CONTINUE2

@REM )
@REM :CONTINUE2
echo end of road
pause

@REM NOTEPAD

@REM @echo off
@REM tasklist /fi "imagename eq cmd.exe" |find ":" > nul
@REM if errorlevel 1 taskkill /f /im "cmd.exe"
@REM exit

@REM call "%CPS%\testcmd.cmd" && echo  ERRORLEVEL =  %ERRORLEVEL% || COLOR 00

@REM goto :sucess
@REM /Wait
@REM  cmd /c
@REM echo start dw11
@REM pause

@REM check errorlevel
echo  ERRORLEVEL =  %ERRORLEVEL%
echo errorcode = %errorcode%
pause

if %ERRORLEVEL% neq 0 (
	echo. ########################################
	echo aborted download
	echo. ########################################
	pause
goto :Quit
)

:sucess
echo Finished download
pause
goto :Quit
:Quit

echo quit
pause

@REM TASKLIST /FI "IMAGENAME eq cmd*"

@REM https://stackoverflow.com/questions/50555929/get-only-pid-from-tasklist-using-cmd-title
@REM @Echo off & SetLocal EnableDelayedExpansion
@REM set "PID="
@REM for /f "tokens=2" %%A in ('tasklist ^| findstr /i "cmd.exe" 2^>NUL') do @Set "PID=!PID!,%%A"
@REM if defined PID Echo cmd.exe has PID(s) %PID:~1%

@REM  another test
@REM :: Q:\Test\2018\05\27\SO_50555929_2.cmd
@REM @Echo off
@REM set "MyTitle=This is a quite long title to distinguish from other"
@REM start "%MyTitle%" cmd.exe /k cmdow.exe @ /F

@REM :: wait to get other cmd instance get started
@REM timeout /t 3 >NUL

@REM set "PID="
@REM for /F "tokens=3" %%A in ('cmdow.exe "%MyTitle%*"') do set "PID=%%A"
@REM if defined PID Echo %PID%


@REM @echo off
@REM for /F "delims=" %%R in ('
@REM     tasklist /FI "ImageName eq cmd.exe" /FI "Status eq Running" /FO CSV /NH
@REM ') do (
@REM     set "FLAG1=" & set "FLAG2="
@REM     for %%C in (%%R) do (
@REM         if defined FLAG1 (
@REM             if not defined FLAG2 (
@REM                 echo %%~C
@REM             )
@REM             set "FLAG2=#"
@REM         )
@REM         set "FLAG1=#"
@REM     )
@REM )



@REM @echo off
@REM for /F "tokens=2" %%K in ('
@REM    tasklist /FI "ImageName eq cmd.exe" /FI "Status eq Running" /FO LIST ^| findstr /B "PID:"
@REM ') do (
@REM    echo %%K
@REM )


@REM START "" "C:\Program Files\Windows NT\Accessories\wordpad.exe"

@REM :LOOP
@REM PSLIST wordpad >nul 2>&1
@REM IF ERRORLEVEL 1 (
@REM   GOTO CONTINUE
@REM ) ELSE (
@REM   ECHO Wordpad is still running
@REM   TIMEOUT /T 5
@REM   GOTO LOOP
@REM )

@REM :CONTINUE
@REM NOTEPAD


@REM REM
@REM REM DEMO - how to launch several processes in parallel, and wait until all of them finish.
@REM REM

@REM @ECHO OFF
@REM start "!The Title!" Echo Close me manually!
@REM start "!The Title!" Echo Close me manually!
@REM :waittofinish
@REM echo At least one process is still running...
@REM timeout /T 2 /nobreak >nul
@REM tasklist.exe /fi "WINDOWTITLE eq !The Title!" | find ":" >nul
@REM if errorlevel 1 goto waittofinish
@REM echo Finished!
@REM PAUSE



@REM @Echo off & SetLocal EnableDelayedExpansion
@REM set "PID="
@REM for /f "tokens=2" %%A in ('tasklist ^| findstr /i "cmd.exe" 2^>NUL') do @Set "PID=!PID!,%%A"
@REM if defined PID Echo cmd.exe has PID(s) %PID:~1%





@REM for /F "tokens=1,2" %%i in ('tasklist /FI "IMAGENAME eq cmd.exe" /fo table /nh') do set pid=%%j
@REM echo %pid%