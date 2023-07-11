@REM menuWizard1.cmd

@echo off
rem Win11 script
set scriptver=0.0.26
title %~nx0  v%scriptver%

set debug=0


@REM  call the "setvars.cmd" file in the Scripts directory
call %CPS%\setvars.cmd
echo.

set "ISOROOT=%CP%\03_WinBuilder\Custom\x64\IsoRoot\"

 set "RepoDl=%Bin%\Lostosrepo\Downloads\"

set "DVDDir=%CP%\DVD"

IF  %debug% NEQ 0 (
@REM cls
echo. ########################################
echo my project name is %ProjectName%
echo MCTool = %MCTool%
echo ISO = %ISO%
echo DVDDir = %DVDDir%
echo DVD = %DVD%
echo CP = %CP%
echo. ########################################
pause
)

@REM pause

@REM D:\gitrepoprojects\LastOSBuilder\zzLastOSBuilder\Bin\LostOSrepo
@REM LostOSrepo_v4.exe
::-------------------------------------------------------------------------------------------
:: LastOS Toolkit - MenuTools
::-------------------------------------------------------------------------------------------
:MenuTools

cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder -Wizard1 Menu
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
echo.
echo.                             [A]   About
echo.
echo.                             [1]   Wizard1
echo.
echo.                             [2]   Wizard2
echo.
echo.                             [3]   Wizard1
echo.
echo.                             [4]   Wizard1
echo.
echo.                             [5]  Wizard1
echo.
echo.                             [6]   Wizard1
echo.
echo.                             [7]   Wizard1
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
if errorlevel 9 goto :MenuToolsHelp
if errorlevel 8 goto :CleanupSource
if errorlevel 7 goto :DeleteISOs
if errorlevel 6 goto :DeleteNTLite
if errorlevel 5 goto :CustomizeMenuHelp
if errorlevel 4 goto :MenuRemoveHelp
if errorlevel 3 goto :Wizard2
if errorlevel 2 goto :Wizard1
if errorlevel 1 goto :aboutHelp
::-------------------------------------------------------------------------------------------


:Wizard1
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Wizard1
echo.                           v%BuilderVersion%
echo.===============================================================================
 echo.
 echo After selecting ISO, wizard will guide you through creating an ISO ready for deployment.
@REM  download win10 for use in winpe
@REM extract win10 iso
@REM open winbuilder
@REM create bootable ISO called win10pe
@REM  download win11 for use in combining with win10 winpe
@REM extract win11 iso
@REM integrate  win10pe with extracted win11
@REM apply integration
@REM create win11iso
@REM test win11iso
echo.

:Wizard2
