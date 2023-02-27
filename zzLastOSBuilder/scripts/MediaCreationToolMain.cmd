
@REM echo MCTool = %MCTool%
set "MCTool=%CP%\MCT"

@REM  ################# Powershell
@REM START /wait  "wd11" cmd /c %MCTool%\MediaCreationToolwin11.cmd
START /wait  "mswd" cmd /c %MCTool%\MediaCreationTool.bat
@REM MediaCreationTool.bat

TIMEOUT /T 10
@REM pause
@REM Check if Powershell is running
:LOOP
tasklist /fi "imagename eq Power*" |find ":" > nul 2>&1
echo ERRORLEVEL = %ERRORLEVEL%
@REM pause
IF ERRORLEVEL 1 (
  ECHO Powershell is still running
  TIMEOUT /T 5
@REM   loop if Powershell still running
  GOTO LOOP
)
@REM ELSE (

    GOTO CONTINUE

:CONTINUE

echo end of Powershell for now

@REM  ################# Powershell


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
