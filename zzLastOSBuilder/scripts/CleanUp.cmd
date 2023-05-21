@REM CleanUp.cmd

@REM  References

@REM  https://www.computerhope.com/issues/ch001674.htm
@REM  https://ss64.com/nt/choice.html
@REM  https://ss64.com/nt/call.html

@REM Menu start
@REM #############################
:MENU_START
@echo off
cls
rem Win11 script
set scriptver=0.0.17
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
echo cp = %CP%

@REM pause


@REM  setvars= Set variables for all scripts to run
@REM  call the "setvars.cmd" file in the Scripts directory
call %CPS%\setvars.cmd
echo.
@REM echo setvars = %setvars%
set "MCTool=%CP%\MCT"
set "ISO=%CP%\ISO"

call :mylocalvars

@REM debug

If %debug% NEQ 0 (

echo. HostArchitecture zzmenu    = %HostArchitecture%
echo. HostBuild = %HostBuild%
echo. Bin = %Bin%

pause
)



::-------------------------------------------------------------------------------------------
:: Cleanup LastOS Toolkit's temporary files and folders
::-------------------------------------------------------------------------------------------
:CleanUp

echo.Starting Cleaning Up...
echo.
echo.Cleaning Up Image Registry Mount Points...
call :UnMountImageRegistry

echo.
echo.Cleaning Up Image Mount Points...
Dism.exe /English /Quiet /Unmount-Wim /MountDir:"%BootMount%\1" /Discard >nul
Dism.exe /English /Quiet /Unmount-Wim /MountDir:"%BootMount%\2" /Discard >nul
Dism.exe /English /Unmount-Wim /MountDir:"%WinReMount%" /Discard >nul

for /l %%i in (1, 1, 100) do (
	if exist "%InstallMount%\%%i\Windows" Dism.exe /English /Unmount-Wim /MountDir:"%InstallMount%\%%i" /Discard >nul
)

:: Cleaning Up Images Mount Points Folders
call :RemoveFolder "%BootMount%"
call :CreateFolder "%BootMount%\1"
call :CreateFolder "%BootMount%\2"
call :RemoveFolder "%InstallMount%"
call :CreateFolder "%InstallMount%"
call :RemoveFolder "%WinReMount%"
call :CreateFolder "%WinReMount%"
echo.

:: Cleaning Up Logs Folders
echo.Cleaning Up Logs files...
call :RemoveFolder "%Logs%"
call :CreateFolder "%Logs%"
echo.

:: Cleaning Up Temporary files Folders
echo.Cleaning Up Temporary files...
call :RemoveFolder "%Temp%"
call :CreateFolder "%Temp%"

echo.
echo.Finished Cleaning Up...
echo.

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


