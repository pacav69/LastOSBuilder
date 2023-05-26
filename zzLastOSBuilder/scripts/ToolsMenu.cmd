@REM ToolsMenu.cmd

@REM ToolsMenu.cmd
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
echo.                             [2]   Select ISO from ISO directory
echo.
echo.                             [3]   Remove
echo.
echo.                             [4]   Customize
echo.
echo.                             [5]   Apply
echo.
echo.                             [6]   Target
echo.
echo.                             [7]   Cleanup Source
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
if errorlevel 8 goto :CleanupSource
if errorlevel 7 goto :TargetMenuHelp
if errorlevel 6 goto :ApplyMenuHelp
if errorlevel 5 goto :CustomizeMenuHelp
if errorlevel 4 goto :RemoveMenuHelp
if errorlevel 3 goto :SelectISO
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
@REM call  %CPS%\Lostos.cmd

echo.Downloading Apz from LastOS
echo.

@REM  #################
START /wait  "LostOSrepo" cmd /c %Bin%\LostOSrepo\LostOSrepo_v4.5.exe

echo.
echo.Finished Downloading
echo.
pause

echo.
echo.Copy apz
echo.
call :apzcopy
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


:apzcopy

IF  %debug% NEQ 0 (
@REM cls
echo. ########################################
echo my project name is %ProjectName%
echo MCTool = %MCTool%
echo ISO = %ISO%
echo DVDDir = %DVDDir%
echo DVD = %DVD%
echo CP = %CP%
echo CPS = %CPS%
echo ISOROOT = %ISOROOT%
echo RepoDl = %RepoDl%
echo. ########################################
pause
)


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
@REM copy files to:
@REM \03_WinBuilder\Custom\x64\IsoRoot\ssAppsInstalls
@REM \03_WinBuilder\Custom\x64\IsoRoot\ppAppsInstalls
@REM \03_WinBuilder\Custom\x64\IsoRoot\ppGamesInstalls

@REM copy specific files to their respective directories
@REM xcopy *ssApp.apz .\ssapz
@REM xcopy *ppApp.apz .\ppapz
@REM xcopy *ppGame.pgz .\ppGame

:somewhere
rem echo "I am here because you typed Y"

@REM test of file copying
call :CreateFolder "%ISOROOT%\myapz"
xcopy %RepoDl%\*ssApp.apz %ISOROOT%\myapz
@REM end test

@REM @REM copy ssAppsInstalls
@REM xcopy %RepoDl%\*ssApp.apz %ISOROOT%\ssAppsInstalls

@REM @REM copy ppAppsInstalls
@REM xcopy %RepoDl%\*ppApp.apz %ISOROOT%\ppAppsInstalls

@REM @REM copy ppGamesInstalls
@REM xcopy %RepoDl%\*ppGame.pgz %ISOROOT%\ppGamesInstalls


@REM pause
@REM goto :Quit
goto :eof

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
  @REM goto :Quit
  goto :eof
::-------------------------------------------------------------------------------------------

:SelectISO
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - SelectISO
echo.                           v%BuilderVersion%
echo.===============================================================================
 echo.
echo.
echo  CPS =  %CPS%
echo The ISO = %ISO%
@REM pause
@REM open the powershellscript 'openfileselectdialog.ps1' with Initial Directory
@REM  return with variable tmp contained in powweshell script that
@REM stores file selected pathname and filename.
@REM openfileselectdialog.ps1 [InitialDirectory ]

@REM  ref: https://stackoverflow.com/questions/4037939/powershell-says-execution-of-scripts-is-disabled-on-this-system
@REM set powershell restrictions for CurrentUser so file is able to run
START /wait powershell.exe Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
@REM start the powershell file with [InitialDirectory]
START /wait powershell.exe -file %CPS%\openfileselectdialog.ps1 %ISO%

@REM  tmp is created in openfileselectdialog.ps1
 set /p myfile=<tmp
 echo *****************************
 set /p MyISOfile=<tmp
echo  the ISO selected is %MyISOfile%

 pause
  @REM goto :Quit
  goto :eof
::-------------------------------------------------------------------------------------------



:RemoveMenuHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - RemoveMenuHelp
echo.                           v%BuilderVersion%
echo.===============================================================================
 echo.
echo.


 pause
  @REM goto :Quit
  goto :eof
::-------------------------------------------------------------------------------------------


:CustomizeMenuHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - CustomizeMenuHelp
echo.                           v%BuilderVersion%
echo.===============================================================================
 echo.
echo.


 pause
  @REM goto :Quit
  goto :eof
::-------------------------------------------------------------------------------------------


:ApplyMenuHelp
 cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - ApplyMenuHelp
echo.                           v%BuilderVersion%
echo.===============================================================================
 echo.
echo.


 pause
  @REM goto :Quit
  goto :eof
::-------------------------------------------------------------------------------------------


:TargetMenuHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - TargetMenuHelp
echo.                           v%BuilderVersion%
echo.===============================================================================
 echo.
echo.


 pause
  @REM goto :Quit
  goto :eof
::-------------------------------------------------------------------------------------------


:CleanupSource
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Cleanup
echo.                           v%BuilderVersion%
echo.===============================================================================
 echo.
echo.
@REM  call  %CPS%\Lostos.cmd
call  %CPS%\cleanoutsources.cmd
 call  %CPS%\CleanUp.cmd

 echo
  echo.===============================================================================
echo.
echo. Finished Cleanup
echo.
  echo.===============================================================================
@REM pause

 pause
  @REM goto :Quit
  goto :eof
::-------------------------------------------------------------------------------------------


:ToolsMenuHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - ToolsMenuHelp
echo.                           v%BuilderVersion%
echo.===============================================================================
 echo.
echo.


 pause
  @REM goto :Quit
  goto :eof
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
