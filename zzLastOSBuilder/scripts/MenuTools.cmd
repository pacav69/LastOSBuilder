@REM MenuTools.cmd

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
echo.                           LastOS ToolKit Builder - Tools Menu
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
echo.
echo.                             [A]   About
echo.
echo.                             [1]   Download Apz from LastOS
echo.
echo.                             [2] Use Wizards
echo.
echo.                             [3]   Remove
echo.
echo.                             [4]   Customize
echo.
echo.                             [5]  Delete Source NTLite
echo.
echo.                             [6]   Delete Extracted ISO's
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
if errorlevel 9 goto :MenuToolsHelp
if errorlevel 8 goto :CleanupSource
if errorlevel 7 goto :DeleteISOs
if errorlevel 6 goto :DeleteNTLite
if errorlevel 5 goto :CustomizeMenuHelp
if errorlevel 4 goto :MenuRemoveHelp
if errorlevel 3 goto :Wizard1
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

:Wizard1

call %CPS%\menuWizard1.cmd


 pause
  @REM goto :Quit
  goto :eof
::-------------------------------------------------------------------------------------------



:MenuRemoveHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - MenuRemoveHelp
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


:DeleteNTLite
 cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - DeleteNTLite
echo.                           v%BuilderVersion%
echo.===============================================================================
 echo.
echo.

@REM 00.01_Delete_Source_NTLite_Copy_Sysprep_ISO
rem Delete Process NTLite ISO, will and any NTLite Processes you have done
rem make sure NTLite is closed
echo rd /s "%CP%\%NTLiteISOPath%"
rd /s /q "%CP%\%NTLiteISOPath%"

Rem Copy SysprepISO to NTLiteISO
md "%CP%\%NTLiteISOPath%"
xcopy /E /C /H /R /Y "%CP%\%SysPrepISOPath%\*" "%CP%\%NTLiteISOPath%\*"


 pause
  @REM goto :Quit
  goto :eof
::-------------------------------------------------------------------------------------------


:DeleteISOs
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - DeleteISOs
echo.                           v%BuilderVersion%
echo.===============================================================================
 echo.
echo.

@REM 00.01_Delete_Source_ISO_Clean_Up_Builder

rem Delete Extracted ISO's and any Builder Processes you have done
echo rd /s "%CP%\%WindowsOriginalPath%"
rd /s /q "%CP%\%WindowsOriginalPath%"

echo rd /s "%CP%\%SysPrepISOPath%"
rd /s /q "%CP%\%SysPrepISOPath%"

echo rd /s "%CP%\%NTLiteISOPath%"
rd /s /q "%CP%\%NTLiteISOPath%"



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
@REM call  %CPS%\cleanoutsources.cmd
@REM  call  %CPS%\CleanUp.cmd


::-------------------------------------------------------------------------------------------
:: Cleanup LastOS Toolkit's temporary files and folders
::-------------------------------------------------------------------------------------------
:CleanUp


echo.Starting Cleaning Up...
echo.
echo.Cleaning Up Image Registry Mount Points...
call :UnMountImageRegistry

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

echo.
echo.Cleaning Up Image Mount Points...
Dism.exe /English /Quiet /Unmount-Wim /MountDir:"%BootMount%\1" /Discard >nul
Dism.exe /English /Quiet /Unmount-Wim /MountDir:"%BootMount%\2" /Discard >nul
Dism.exe /English /Unmount-Wim /MountDir:"%WinReMount%" /Discard >nul

for /l %%i in (1, 1, 100) do (
	if exist "%InstallMount%\%%i\Windows" Dism.exe /English /Unmount-Wim /MountDir:"%InstallMount%\%%i" /Discard >nul
)

:: Cleaning Up Images Mount Points Folders
call :RemoveFolder "%BootMount%"
call :CreateFolder "%BootMount%\1"
call :CreateFolder "%BootMount%\2"
call :RemoveFolder "%InstallMount%"
call :CreateFolder "%InstallMount%"
call :RemoveFolder "%WinReMount%"
call :CreateFolder "%WinReMount%"
echo.

:: Cleaning Up Logs Folders
echo.Cleaning Up Logs files...
call :RemoveFolder "%Logs%"
call :CreateFolder "%Logs%"
echo.

:: Cleaning Up Temporary files Folders
echo.Cleaning Up Temporary files...
call :RemoveFolder "%Temp%"
call :CreateFolder "%Temp%"

@REM echo DVDFiles = %DVDFiles%

:: Cleaning Up DVDFiles files Folders
echo.Cleaning Up DVDFiles...
call :RemoveFolder "%DVDFiles%"
call :CreateFolder "%DVDFiles%"

@REM set "tmp="
@REM call :RemoveFile "%DVD%\MediaMeta.xml"
:: Cleaning Up tmp files Folders
echo.Cleaning Up tmp files...
set "tmpFile=%CP%\tmp.txt"
@REM echo tmpFile = %tmpFile%
@REM set "tmp=%~dp0tmp"
call :RemoveFile "%tmpFile%"

echo.
echo.Finished Cleaning Up...
echo.
pause
goto :eof

 echo
  echo.===============================================================================
echo.
echo. Finished Cleanup
echo.
  echo.===============================================================================
pause

 pause
  @REM goto :Quit
  goto :eof
::-------------------------------------------------------------------------------------------


:MenuToolsHelp
cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - MenuToolsHelp
echo.                           v%BuilderVersion%
echo.===============================================================================
 echo.
echo.


 pause
  @REM goto :Quit
  goto :eof
::-------------------------------------------------------------------------------------------


::-------------------------------------------------------------------------------------------
:: Function to unmount Image Registry
:: Input Parameters [ None ]
::-------------------------------------------------------------------------------------------
:UnMountImageRegistry

:: Un-Mounting Image Registry
for /f "tokens=* delims=" %%a in ('reg query "HKLM" ^| findstr "{"') do (
	reg unload "%%a" >nul 2>&1
)

reg unload HKLM\TK_COMPONENTS >nul 2>&1
reg unload HKLM\TK_DRIVERS >nul 2>&1
reg unload HKLM\TK_DEFAULT >nul 2>&1
reg unload HKLM\TK_NTUSER >nul 2>&1
reg unload HKLM\TK_SCHEMA >nul 2>&1
reg unload HKLM\TK_SOFTWARE >nul 2>&1
reg unload HKLM\TK_SYSTEM >nul 2>&1

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
