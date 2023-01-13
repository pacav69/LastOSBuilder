@echo off
cls

SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION

CALL :RESOLVE "%~dp0.." PARENT_ROOT

set usbdrive=
set _mypath=%PARENT_ROOT%
set _fselpath=%~p0
set drlist=
set copyfromusb=0
copy /Y NUL "%~dp0\.writable" > NUL 2>&1 && set WRITEOK=1
IF DEFINED WRITEOK ( 
	rem ---- we have write access, USB? ----
	del /Q /F "%~dp0\.writable"
	set copyfromusb=1
 ) else (
	rem ---- we don't, DVD then? ----
)

if "%copyfromusb%" == "0" (
	if NOT EXIST "%_mypath%\sources\$USBDVD" (
		echo.
		echo *** USB Setup Files cannot be found, Aborting Script ***
		echo.
		pause
		goto _ender
	)
)

:_format_menu
cls
echo.
echo ************************************************************
echo.
echo  Format USB drive with NTFS (FAT32 is slow for Windows installation)
echo.
echo.    H) HP USB Disk Storage Format Tool V2.0.6 - NTFS Format - use X_CONTENT
echo.
echo      Do not use HP Tool for USB HDD's having more than one partition
echo      WARNING - formats the entire disk - additional partitions will be lost
echo.
echo.
echo     N) No Format - Use USB drive with NTFS Format by Windows
echo        Or update existing bootable USB drive with NTFS bootsector
echo.

set _ok=
set /p _ok= Enter your choice: 
if /I "%_ok%" == "h" goto _gethp
if /I "%_ok%" == "n" goto _main
ECHO.
ECHO ***** NOT in menu - wrong selection - try again *****
ECHO.
pause
goto :_format_menu

:_gethp
IF EXIST %_mypath%\sources\$USBDVD\HPUSBFW.EXE ( 
   %_mypath%\sources\$USBDVD\HPUSBFW.EXE   
)
goto :_main

:_main
cls
echo.
echo ************************************************************
echo.
echo  Select USB drive target for your bootable OS
echo.
set _ok=
set drlist=
SET usbdrive=

set /p _ok= Enter target USB drive letter: 
IF "!_ok!"=="" (
  echo.
  echo  ***** Drive is not valid *****
  echo.
  pause
  goto _main
)

if /I "%_ok%" == "C" (
  echo.
  echo  ***** C-Drive is not allowed - selection not valid *****
  echo.
  pause
  goto _main
)

if not exist %_ok%: (
  echo.
  echo  ***** Drive is not found or formatted - selection not valid *****
  echo.
  pause
  goto _main
)
set usbdrive=%_ok%:

:_yousure
cls
echo.
echo.
echo ************************************************************
echo.
echo  Overwrite Drive %usbdrive% Bootsector
echo.
echo.    Y) This will make the USB device bootable as NTFS
echo.
echo        If you apply this to a non USB drive it may corrupt your partitons
echo        WARNING - Make sure that drive %usbdrive% is the one you want to update
echo.
echo.
echo     N) Skip NTFS bootsector creation
echo.
echo        If you have not formatted the USB device since applying this previously
echo        you don't need to apply this.
echo.

set _ok=
set /p _ok= Enter your choice: 
if /I "%_ok%" == "y" goto _continue
if /I "%_ok%" == "n" goto _yousure2
ECHO.
ECHO ***** Not in menu - wrong selection - try again *****
ECHO.
pause
goto :_yousure

:_continue
echo.
IF EXIST %_mypath%\sources\$USBDVD\BootSect.exe ( 
   %_mypath%\sources\$USBDVD\BootSect.exe /nt60 %usbdrive% /force 
)
echo.

:_yousure2
cls
echo.
echo.
echo ************************************************************
echo.
echo  Copy Setup files from %_mypath%\ to %usbdrive%\
echo.
echo.    Y) This will copy Setup files to your USB device
echo.
echo        This may take over 30 minutes from a DVD
echo.
echo.
echo     N) Skip copying Setup files
echo.
echo        Finished preparing your USB Drive
echo.

set _ok=
set /p _ok= Enter your choice: 
if /I "%_ok%" == "y" goto _copy
if /I "%_ok%" == "n" goto _dontcopy
ECHO.
ECHO ***** NOT in menu - wrong selection - try Again *****
ECHO.
pause
goto :_yousure2

:_copy
echo.
if "%copyfromusb%" == "0" (
echo.
 	echo *** Found DVD files, copying from DVD to USB ***
 	echo.
 	echo Copying %_mypath%\ to %usbdrive%\
	echo.
	echo Please Wait . . .
	xcopy "%_mypath%\*.*" "%usbdrive%\" /Q /E /H /R /C /Y
) 

if "%copyfromusb%" == "1" (
	echo.
	echo *** Found USB files, copying from USB/HDD to USB ***
	echo.
	echo Copying %_mypath%\ to %usbdrive%\
	echo.
	echo Please Wait . . .
	xcopy "%_mypath%\*.*" "%usbdrive%\" /Q /E /H /R /C /Y
)

:_dontcopy

:_skip
cls
echo.
echo *** Drive %usbdrive% USB creation complete ***
echo.
echo Reboot and set BIOS to boot from USB or use Boot Menu
echo.
pause
goto :_ender

:RESOLVE
SET %2=%~f1
goto :_ender

:_ender         