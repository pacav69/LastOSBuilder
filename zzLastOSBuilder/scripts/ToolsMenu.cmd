@REM ToolsMenu.cmd

@REM ToolsMenu.cmd
@echo off
rem Win11 script
set scriptver=0.0.15
title %~nx0  v%scriptver%

set debug=0


@REM  call the "setvars.cmd" file in the Scripts directory
call %CPS%\setvars.cmd
echo.

set "DVDDir=%CP%\DVD"

IF  %debug% NEQ 0 (
@REM cls
echo. ########################################
echo my project name is %ProjectName%
echo MCTool = %MCTool%
echo ISO = %ISO%
echo DVDDir = %DVDDir%
echo DVD = %DVD%
echo. ########################################
pause
)

@REM pause

@REM D:\gitrepoprojects\LastOSBuilder\zzLastOSBuilder\Bin\LostOSrepo
@REM LostOSrepo_v4.exe
::-------------------------------------------------------------------------------------------
:: LastOS Toolkit - ToolsMenu
::-------------------------------------------------------------------------------------------
:ToolsMenu

cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Tools Menu
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
echo.
echo.                             [A]   About
echo.
echo.                             [1]   Download Apz from LastOS
echo.
echo.                             [2]   Integrate
echo.
echo.                             [3]   Remove
echo.
echo.                             [4]   Customize
echo.
echo.                             [5]   Apply
echo.
echo.                             [6]   Target
echo.
echo.                             [7]   Tools
echo.
echo.                             [H]   Help
echo.
echo.
echo.                             [X]   Quit
echo.
echo.===============================================================================
echo.
choice /C:A1234567HX /N /M "Enter Your Choice: "
if errorlevel 10 goto :Quit
if errorlevel 9 goto :ToolsMenuHelp
if errorlevel 8 goto :ToolsMenuHelp
if errorlevel 7 goto :TargetMenuHelp
if errorlevel 6 goto :ApplyMenuHelp
if errorlevel 5 goto :CustomizeMenuHelp
if errorlevel 4 goto :RemoveMenuHelp
if errorlevel 3 goto :IntegrateMenuHelp
if errorlevel 2 goto :Lostos
if errorlevel 1 goto :aboutHelp
::-------------------------------------------------------------------------------------------

:Lostos
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Download Apz from LastOS
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
echo.
echo.-------------------------------------------------------------------------------
echo.####about to Download Apz from LastOS ###############
echo.-------------------------------------------------------------------------------

echo.
choice /C:YN /N /M "Are you sure you want to continue with Download Apz from LastOS ? ['Y'es/'N'o] : "
if errorlevel 2 goto :somewhere_else
if errorlevel 1 goto :somewhere

:somewhere
rem echo "I am here because you typed Y"
call  %CPS%\Lostos.cmd
@REM call :RemoveFolder "%DVDDir%"
@REM echo create DVDdir
@REM pause
@REM call :CreateFolder "%DVDDir%"
pause
goto :Quit

:somewhere_else
rem echo "I am here because you typed N"
echo
  echo.===============================================================================
echo.
echo. aborting Download Apz from LastOS
echo.
  echo.===============================================================================
pause
:run
  echo.
  echo.
  echo.
  echo.
  echo.===============================================================================

  pause
  goto :Quit
::-------------------------------------------------------------------------------------------



::-------------------------------------------------------------------------------------------
:: Function to delete a folder(s)
:: Input Parameters [ %~1 : Foldername ]
::-------------------------------------------------------------------------------------------
:RemoveFolder

if exist "%~1" rd /q /s "%~1" >nul

goto :eof

::-------------------------------------------------------------------------------------------
:: Function to Create a Folder
:: Input Parameters [ %~1 : Foldername ]
::-------------------------------------------------------------------------------------------
:CreateFolder

if not exist "%~1" md "%~1" >nul

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to delete a file(s)
:: Input Parameters [ %~1 : Filename ]
::-------------------------------------------------------------------------------------------
:RemoveFile

if exist "%~1" del /f /q "%~1" >nul

goto :eof
::-------------------------------------------------------------------------------------------


@REM =================================
:Quit
echo Bye
timeout 2 > NUL
@REM exit /b
@REM =================================
