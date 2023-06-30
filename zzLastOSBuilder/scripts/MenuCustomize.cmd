@REM MenuCustomize.cmd

@echo off
rem Win11 script
set scriptver=0.0.14
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
:: LastOS Toolkit - CustomizeMenu
::-------------------------------------------------------------------------------------------
:MenuHelp

cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Customize Menu
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
choice /C:A1234567HX /N /M "Enter Your Choice: "
if errorlevel 10 goto :Quit
if errorlevel 9 goto :MenuHelpHelp
if errorlevel 8 goto :ToolsMenuHelp
if errorlevel 7 goto :MenuTargetHelp
if errorlevel 6 goto :ApplyMenuHelp
if errorlevel 5 goto :CustomizeMenuHelp
if errorlevel 4 goto :MenuRemoveHelp
if errorlevel 3 goto :MenuIntegrate.cmdHelp
if errorlevel 2 goto :MenuSourceHelp
if errorlevel 1 goto :aboutHelp
::-------------------------------------------------------------------------------------------



 :aboutHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Help About
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
  echo About describes the LastOSBuilder
  echo. Checks for updates
  echo.
  echo.
  echo.
  echo.===============================================================================

  pause
  goto :exitMenuHelp
::-------------------------------------------------------------------------------------------

:MenuSourceHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Help MenuSource
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
  echo describes the MenuSource
  echo.
  echo.
  echo.
  echo.
  echo.===============================================================================

  pause
  goto :exitMenuHelp
::-------------------------------------------------------------------------------------------


:MenuIntegrate.cmdHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Help MenuIntegrate.cmd
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
  echo describes the MenuIntegrate.cmd
  echo.
  echo.
  echo.
  echo.
  echo.===============================================================================

  pause
  goto :exitMenuHelp
::-------------------------------------------------------------------------------------------



:MenuRemoveHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Help MenuRemove
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
  echo describes the MenuRemoveHelp
  echo.
  echo.
  echo.
  echo.
  echo.===============================================================================

  pause
  goto :exitMenuHelp
::-------------------------------------------------------------------------------------------


:CustomizeMenuHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Help CustomizeMenu
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
  echo describes the CustomizeMenuHelp
  echo.
  echo.
  echo.
  echo.
  echo.===============================================================================

  pause
  goto :exitMenuHelp
::-------------------------------------------------------------------------------------------


:ApplyMenuHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Help ApplyMenu
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
  echo describes the ApplyMenuHelp
  echo.
  echo.
  echo.
  echo.
  echo.===============================================================================

  pause
  goto :exitMenuHelp
::-------------------------------------------------------------------------------------------


:MenuTargetHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Help MenuTarget
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
  echo describes the MenuTargetHelp
  echo.
  echo.
  echo.
  echo.
  echo.===============================================================================

  pause
  goto :exitMenuHelp
::----------------------------------------------------------------------------------------


:ToolsMenuHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Help ToolsMenu
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
  echo describes the ToolsMenuHelp
  echo.
  echo.
  echo.
  echo.
  echo.===============================================================================

  pause
  goto :exitMenuHelp
::-------------------------------------------------------------------------------------------



:MenuHelpHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Help MenuHelpHelp
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
  echo describes the MenuHelpHelp
  echo.
  echo.
  echo.
  echo.
  echo.===============================================================================

  pause
  goto :exitMenuHelp
::-------------------------------------------------------------------------------------------


@REM =================================
:exitMenuHelp
echo Returning to MenuHelp
timeout 2 > NUL
GOTO MenuHelp

@REM =================================

@REM =================================
:Quit
echo Bye
timeout 2 > NUL
@REM exit /b
@REM =================================

