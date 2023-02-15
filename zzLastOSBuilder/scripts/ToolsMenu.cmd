@REM ToolsMenu.cmd

@REM ToolsMenu.cmd
@echo off
rem Win11 script
set scriptver=0.0.15
title %~nx0  v%scriptver%

set Debug=1

@REM IF /I %debug% GTR 1 (

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
echo.
echo my project name is %ProjectName%
@REM pause


::-------------------------------------------------------------------------------------------
:: LastOS Toolkit - ToolsMenu 
::-------------------------------------------------------------------------------------------
:HelpMenu

cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Tools Menu
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
echo.
echo.                             [A]   About
echo.
echo.                             [1]   Source Cleanup
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
choice /C:A1234567HX /N /M "Enter Your Choice for help: "
if errorlevel 10 goto :Quit
if errorlevel 9 goto :HelpMenuHelp
if errorlevel 8 goto :ToolsMenuHelp
if errorlevel 7 goto :TargetMenuHelp
if errorlevel 6 goto :ApplyMenuHelp
if errorlevel 5 goto :CustomizeMenuHelp
if errorlevel 4 goto :RemoveMenuHelp
if errorlevel 3 goto :IntegrateMenuHelp
if errorlevel 2 goto :SourceMenuCleanup
if errorlevel 1 goto :aboutHelp
::-------------------------------------------------------------------------------------------

:SourceMenuCleanup
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Source Cleanup
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
echo.
echo.-------------------------------------------------------------------------------
echo.####about to cleanup Source sub-directories ###############
echo.-------------------------------------------------------------------------------

echo.
choice /C:YN /N /M "Are you sure you want to continue with cleanup of Source sub-directories ? ['Y'es/'N'o] : "
if errorlevel 2 goto :somewhere_else
if errorlevel 1 goto :somewhere

:somewhere
rem echo "I am here because you typed Y"
call  %CPS%\cleanoutsources.cmd
@REM pause
goto :run

:somewhere_else
rem echo "I am here because you typed N"
echo 
  echo.===============================================================================
echo.
echo. aborting cleanup of Source sub-directories 
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



@REM =================================
:Quit
echo Bye
timeout 2 > NUL
@REM exit /b
@REM =================================
