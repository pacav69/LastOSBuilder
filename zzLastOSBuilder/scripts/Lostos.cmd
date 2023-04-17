@REM Lostos.cmd
@echo off
cls
rem Win11 script
set scriptver=0.0.26
title %~nx0  v%scriptver%
@REM ######### DEBUG ###################
@REM set debug on to check files on >0 / off =0
set debug=0
@REM debug
@REM If %debug% NEQ 0 (
@REM pause
@REM )

rem This first for routine will give the current path without a trailing \
%~d0
cd "%~dp0"
cd %~dps0
for %%f in ("%CD%") do set CP=%%~sf
rem CPS= CP Scripts
set CPS=%CP%\scripts
echo CP = %CP%
echo.
echo CPS = %CPS%
pause


@REM  setvars= Set variables for all scripts to run
@REM  call the "setvars.cmd" file in the Scripts directory
call %CPS%\setvars.cmd
echo.
@REM echo setvars = %setvars%
set "MCTool=%CP%\MCT"
@REM set "ISO=%CP%\ISO"

@REM call :mylocalvars

@REM debug

If %debug% NEQ 0 (

echo. HostArchitecture zzmenu    = %HostArchitecture%
echo. HostBuild = %HostBuild%
echo. Bin = %Bin%

pause
)



::-------------------------------------------------------------------------------------------
:: Download Apz from LastOS
::-------------------------------------------------------------------------------------------
:downloadapz

echo.Downloading Apz from LastOS
echo.


@REM  #################
START /wait  "LostOSrepo" cmd /c %Bin%\LostOSrepo\LostOSrepo_v4.5.exe


echo.
echo.Finished Downloading
echo.
pause

@REM echo.
@REM echo.Copy apz
@REM echo.
@REM call %CP%\copyapz.cmd
@REM pause

goto :eof


::-------------------------------------------------------------------------------------------
:: Function to delete a folder(s)
:: Input Parameters [ %~1 : Foldername ]
::-------------------------------------------------------------------------------------------
:RemoveFolder

if exist "%~1" rd /q /s "%~1" >nul

goto :eof
::-------------------------------------------------------------------------------------------


::-------------------------------------------------------------------------------------------
:: Function to Create a Folder
:: Input Parameters [ %~1 : Foldername ]
::-------------------------------------------------------------------------------------------
:CreateFolder

if not exist "%~1" md "%~1" >nul

goto :eof

::-------------------------------------------------------------------------------------------


