@REM MenuIntegrate.cmd

@echo off
rem Win11 script
set scriptver=0.0.15
title %~nx0  v%scriptver%

set Debug=0

@REM If %debug% NEQ 0 (

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
set "builder=%CP%\03_WinBuilder\Win10XPE.exe""

@REM start "" "%builderpath%\Win10XPE.exe"

@REM pause


::-------------------------------------------------------------------------------------------
:: LastOS Toolkit - MenuIntegrate.cmd
::-------------------------------------------------------------------------------------------
:MenuHelp

cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Integrate Menu
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
echo.
echo.                             [A]   About
echo.
echo.                             [1]   Open Pre Installion builder
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
if errorlevel 9 goto :MenuHelpHelp
if errorlevel 8 goto :ToolsMenuHelp
if errorlevel 7 goto :MenuTargetHelp
if errorlevel 6 goto :ApplyMenuHelp
if errorlevel 5 goto :CustomizeMenuHelp
if errorlevel 4 goto :MenuRemoveHelp
if errorlevel 3 goto :MenuIntegrate.cmdHelp
if errorlevel 2 goto :peBuilder
if errorlevel 1 goto :aboutHelp
::-------------------------------------------------------------------------------------------

 :peBuilder
 echo.===============================================================================
echo.          LastOS ToolKit -  Open Pre Installion builder
echo.===============================================================================
echo.
@REM call  %CPS%\pebuilder.cmd
start /wait "" "%builder%

goto :eof


:MenuIntegrate.cmdHelp
 echo.===============================================================================
echo.          LastOS ToolKit -  MenuIntegrate.cmdHelp
echo.===============================================================================
echo.
@REM enter code here

goto :eof

:MenuRemoveHelp
 echo.===============================================================================
echo.          LastOS ToolKit -  MenuRemoveHelp
echo.===============================================================================
echo.
@REM enter code here

goto :eof

:CustomizeMenuHelp
echo.===============================================================================
echo.          LastOS ToolKit -  CustomizeMenuHelp
echo.===============================================================================
echo.
@REM enter code here

goto :eof

 :ApplyMenuHelp
 echo.===============================================================================
echo.          LastOS ToolKit -  ApplyMenuHelp
echo.===============================================================================
echo.
@REM enter code here

goto :eof

 :MenuTargetHelp
 echo.===============================================================================
echo.          LastOS ToolKit -  MenuTargetHelp
echo.===============================================================================
echo.
@REM enter code here

goto :eof

:ToolsMenuHelp
echo.===============================================================================
echo.          LastOS ToolKit -  ToolsMenuHelp
echo.===============================================================================
echo.
@REM enter code here

goto :eof

:MenuHelpHelp
echo.===============================================================================
echo.          LastOS ToolKit -  MenuHelpHelp
echo.===============================================================================
echo.
@REM enter code here

goto :eof




@REM =================================
:Quit
echo Bye
timeout 2 > NUL
@REM exit /b
@REM =================================
