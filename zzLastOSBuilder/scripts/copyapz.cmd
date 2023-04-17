@REM copyapz.cmd

@echo off
rem Win11 script
set scriptver=0.0.26
title %~nx0  v%scriptver%

set debug=0


@REM  call the "setvars.cmd" file in the Scripts directory
@REM call %CPS%\setvars.cmd
echo.
ECHO CP FIRST
echo CP = %CP%
pause

@REM set "DVDDir=%CP%\DVD"

set "ISOROOT=%CP%\03_WinBuilder\Custom\x64\IsoRoot\"

@REM D:\gitrepoprojects\LastOSBuilder\zzLastOSBuilder\Bin\Lostosrepo

 set "RepoDl=%Bin%\Lostosrepo\Downloads\"

echo CP = %CP%
echo CPS = %CPS%
echo ISOROOT = %ISOROOT%
echo RepoDl = %RepoDl%
pause

@REM   /E Copies directories and subdirectories, including empty ones.
@REM   /I If destination does not exist and copying more than one file,
@REM    assumes that destination must be a directory.
@REM /H Copies hidden and system files also.
@REM /R  Overwrites read-only files.
@REM /Y Suppresses prompting to confirm you want to overwrite an
 @REM    existing destination file.
@REM  /J Copies using unbuffered I/O. Recommended for very large files.

 set "XCopy=xcopy.exe /E /I /H /R /Y /J"

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

:apzcopy
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Copy Apz
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
 echo.
echo.
echo.-------------------------------------------------------------------------------
echo.####about to Copy Apz ###############
echo.-------------------------------------------------------------------------------

echo.
choice /C:YN /N /M "Are you sure you want to continue with copying Apz? ['Y'es/'N'o] : "
if errorlevel 2 goto :somewhere_else
if errorlevel 1 goto :somewhere

@REM copy from zzLastOSBuilder\Bin\apzcopyrepo\Downloads
@REM copy files to \03_WinBuilder\Custom\x64\IsoRoot\ssAppsInstalls
@REM \03_WinBuilder\Custom\x64\IsoRoot\ppAppsInstalls
@REM \03_WinBuilder\Custom\x64\IsoRoot\ppGamesInstalls

@REM xcopy *ssApp.apz .\ssapz
@REM xcopy *ppApp.apz .\ppapz
@REM xcopy *ppGame.pgz .\ppGame

:somewhere
rem echo "I am here because you typed Y"

call :CreateFolder "%ISOROOT%\myapz"

xcopy %RepoDl%\*ssApp.apz %ISOROOT%\myapz

@REM @REM copy ssAppsInstalls
@REM xcopy %RepoDl%\*ssApp.apz %ISOROOT%\ssAppsInstalls

@REM @REM copy ppAppsInstalls
@REM xcopy %RepoDl%\*ppApp.apz %ISOROOT%\ppAppsInstalls

@REM @REM copy ppGamesInstalls
@REM xcopy %RepoDl%\*ppGame.pgz %ISOROOT%\ppGamesInstalls


@REM pause
goto :Quit

:somewhere_else
rem echo "I am here because you typed N"
echo
  echo.===============================================================================
echo.
echo. aborting Copy Apz from Download
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

@REM  exmple
@REM call :CreateFolder "%DVDDir%"
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

@REM pause

