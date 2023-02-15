@REM IntegrateMenu.cmd

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
:: LastOS Toolkit - IntegrateMenu 
::-------------------------------------------------------------------------------------------
:HelpMenu

cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Integrate Menu
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
echo.
echo.                             [A]   About
echo.
echo.                             [1]   Source
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
if errorlevel 2 goto :SourceMenuHelp
if errorlevel 1 goto :aboutHelp
::-------------------------------------------------------------------------------------------



@REM =================================
:Quit
echo Bye
timeout 2 > NUL
@REM exit /b
@REM =================================
