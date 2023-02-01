@echo off
set scriptver=0.0.7
title %~nx0  v%scriptver%


rem This first for routine will give the current path without a trailing \
%~d0
cd "%~dp0"
cd %~dps0
for %%f in ("%CD%") do set CP=%%~sf

rem User Set Variables:
set /p ProjectName=<%CP%\Settings\ProjectName.txt
set /p Arch=<%CP%\Settings\Arch.txt
set /p WinVersion=<%CP%\Settings\WinVersion.txt
set /p VMName=<%CP%\Settings\VMName.txt
set /p VMPath=<%CP%\Settings\VMPath.txt
set /p MountISO=<%CP%\Settings\MountISO.txt
set /p VHDSize=<%CP%\Settings\VHDSize.txt
set /p VirtMem=<%CP%\Settings\VirtMem.txt
set /p VHDFile=<%CP%\Settings\VHDFile.txt
set /p VirtDrive=<%CP%\Settings\VirtDrive.txt
set /p WIMName=<%CP%\Settings\WIMName.txt
set /p ESDName=<%CP%\Settings\ESDName.txt
set /p WindowsOriginalPath=<%CP%\Settings\WindowsOriginalPath.txt
set /p SysPrepISOPath=<%CP%\Settings\SysPrepISOPath.txt
set /p NTLiteISOPath=<%CP%\Settings\NTLiteISOPath.txt
set /p BuilderVersion=<%CP%\Settings\BuilderVersion.txt
@REM set /p BuilderVersion= %CPS%\Settings\BuilderVersion.txt


rem System Set Variables:
for %%f in ("C:\Program Files\Oracle\VirtualBox") do set VBP=%%~sf
set VBM=%VBP%\VBoxManage.exe
set VMP=%CP%\%VMPath%
set ToolsPath=%CP%\Tools

echo *** Project %ProjectName% ***
echo All Folders Are Short Folder Names:
echo.
rem added script version
echo   Script version: v%scriptver%
echo     Current (CP): %CP%
echo VirtualBox (VBP): %VBP%
echo    Virtual Drive: %VirtDrive%
echo.

rem this checks if user wants to use the %MountISO% filename
@REM :choice
@REM set /P c=Are you sure you want to continue with using %MountISO% filename[Y/N]?
@REM if /I "%c%" EQU "Y" goto :somewhere
@REM if /I "%c%" EQU "N" goto :somewhere_else
@REM goto :choice


:somewhere

rem echo "I am here because you typed Y"
echo you are now using %MountISO% filename
rem pause
goto :run
rem exit

:somewhere_else

rem echo "I am here because you typed N"
echo exiting program
@REM pause
exit /B

:run
echo here at run
@REM pause
@REM  check that ISO file exists before proceeding
set "testfile=*.iso"
@REM set "testfile=*.txt"

REM finds file    
IF EXIST "00_Source\%testfile%" (
  ECHO file %testfile% exists & goto runcode
) ELSE (
  ECHO file %testfile% does not exist & goto DONE
) 
@REM echo nope
@REM pause

@REM pause
:runcode
@REM echo runcode


:DONE 
set ERRORLEVEL=1
@REM echo DONE
@REM pause
:END

