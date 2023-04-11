@REM copyapz.cmd

@echo off
rem Win11 script
set scriptver=0.0.26
title %~nx0  v%scriptver%

set debug=0


@REM  call the "setvars.cmd" file in the Scripts directory
call %CPS%\setvars.cmd
echo.

@REM set "DVDDir=%CP%\DVD"
set "ISOROOT=%CP%\03_WinBuilder\Custom\x64\IsoRoot\"
 set "RepoDl=%Bin%\LostOSrepo\Downloads\"
@REM "\03_WinBuilder\Custom\x64\IsoRoot\"

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


@REM copy from zzLastOSBuilder\Bin\Lostosrepo\Downloads
@REM copy files to \03_WinBuilder\Custom\x64\IsoRoot\ssAppsInstalls
@REM \03_WinBuilder\Custom\x64\IsoRoot\ppAppsInstalls
@REM \03_WinBuilder\Custom\x64\IsoRoot\ppGamesInstalls

@REM xcopy *ssApp.apz .\ssapz
@REM xcopy *ppApp.apz .\ppapz
@REM xcopy *ppGame.pgz .\ppGame

@REM copy ssAppsInstalls
xcopy %RepoDl%\*ssApp.apz %ISOROOT%\ssAppsInstalls

@REM copy ppAppsInstalls
xcopy %RepoDl%\*ppApp.apz %ISOROOT%\ppAppsInstalls

@REM copy ppGamesInstalls
xcopy %RepoDl%\*ppGame.pgz %ISOROOT%\ppGamesInstalls
