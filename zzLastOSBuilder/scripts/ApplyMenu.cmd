@REM ApplyMenu.cmd
@REM ApplyMenu.cmd

@REM HelpMenu.cmd
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
:: LastOS Toolkit - ApplyMenu 
::-------------------------------------------------------------------------------------------
:HelpMenu

cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Apply Menu
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
  goto :exitHelpMenu
::-------------------------------------------------------------------------------------------

:SourceMenuHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Help SourceMenu 
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
  echo describes the SourceMenu
  echo. 
  echo.
  echo.
  echo.
  echo.===============================================================================

  pause
  goto :exitHelpMenu
::-------------------------------------------------------------------------------------------


:IntegrateMenuHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Help IntegrateMenu 
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
  echo describes the IntegrateMenu
  echo. 
  echo.
  echo.
  echo.
  echo.===============================================================================

  pause
  goto :exitHelpMenu
::-------------------------------------------------------------------------------------------



:RemoveMenuHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Help RemoveMenu
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
  echo describes the RemoveMenuHelp
  echo. 
  echo.
  echo.
  echo.
  echo.===============================================================================

  pause
  goto :exitHelpMenu
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
  goto :exitHelpMenu
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
  goto :exitHelpMenu
::-------------------------------------------------------------------------------------------


:TargetMenuHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Help TargetMenu
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
  echo describes the TargetMenuHelp
  echo. 
  echo.
  echo.
  echo.
  echo.===============================================================================

  pause
  goto :exitHelpMenu
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
  goto :exitHelpMenu
::-------------------------------------------------------------------------------------------


 
:HelpMenuHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Help HelpMenuHelp
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
  echo describes the HelpMenuHelp
  echo. 
  echo.
  echo.
  echo.
  echo.===============================================================================

  pause
  goto :exitHelpMenu
::-------------------------------------------------------------------------------------------


@REM =================================
:exitHelpMenu
echo Returning to HelpMenu
timeout 2 > NUL
GOTO HelpMenu

@REM =================================

@REM =================================
:Quit
echo Bye
timeout 2 > NUL
@REM exit /b
@REM =================================

