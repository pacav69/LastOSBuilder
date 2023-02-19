@echo off
set "scriptver=0.0.3"
title %~nx0  v%scriptver%

rem call the "setvars.cmd" file in the Scripts directory
call %CPS%\setvars.cmd
echo.
echo my project name is %ProjectName%
@REM pause


@REM rem This first for routine will give the current path without a trailing \
@REM %~d0
@REM cd "%~dp0"
@REM cd %~dps0
@REM for %%f in ("%CD%") do set CP=%%~sf

@REM rem User Set Variables:
@REM set /p ProjectName=<%CP%\Settings\ProjectName.txt
@REM set /p Arch=<%CP%\Settings\Arch.txt
@REM set /p WinVersion=<%CP%\Settings\WinVersion.txt
@REM set /p VMName=<%CP%\Settings\VMName.txt
@REM set /p VMPath=<%CP%\Settings\VMPath.txt
@REM set /p MountISO=<%CP%\Settings\MountISO.txt
@REM set /p VHDSize=<%CP%\Settings\VHDSize.txt
@REM set /p VirtMem=<%CP%\Settings\VirtMem.txt
@REM set /p VHDFile=<%CP%\Settings\VHDFile.txt
@REM set /p VirtDrive=<%CP%\Settings\VirtDrive.txt
@REM set /p WIMName=<%CP%\Settings\WIMName.txt
@REM set /p ESDName=<%CP%\Settings\ESDName.txt
@REM set /p WindowsOriginalPath=<%CP%\Settings\WindowsOriginalPath.txt
@REM set /p SysPrepISOPath=<%CP%\Settings\SysPrepISOPath.txt
@REM set /p NTLiteISOPath=<%CP%\Settings\NTLiteISOPath.txt


@REM rem System Set Variables:
@REM for %%f in ("C:\Program Files\Oracle\VirtualBox") do set VBP=%%~sf
@REM set VBM=%VBP%\VBoxManage.exe
@REM set VMP=%CP%\%VMPath%
@REM set ToolsPath=%CP%\Tools

@REM echo *** Project %ProjectName% ***
@REM echo All Folders Are Short Folder Names:
@REM echo.
@REM rem added script version
@REM echo   Script version: v%scriptver%
@REM echo     Current (CP): %CP%
@REM echo VirtualBox (VBP): %VBP%
@REM echo    Virtual Drive: %VirtDrive%
@REM echo.

@REM :choice
echo.
choice /C:YN /N /M "Are you sure you want to continue with using %MountISO% filename ? ['Y'es/'N'o] : "
if errorlevel 2 goto :somewhere_else
if errorlevel 1 goto :somewhere

@REM rem this checks if user wants to use the %MountISO% filename
@REM :choice
@REM set /P c=Are you sure you want to continue using %MountISO% filename[Y/N]?
@REM if /I "%c%" EQU "Y" goto :somewhere
@REM if /I "%c%" EQU "N" goto :somewhere_else
@REM goto :choice


:somewhere

rem echo "I am here because you typed Y"
echo you are now using %MountISO% filename
@REM pause
goto :run
rem exit

:somewhere_else

rem echo "I am here because you typed N"
echo exiting program
@REM pause
exit /B

:run
echo here at run
echo CP = %CP%
echo ISO = %ISO%
@REM pause

@REM  check that ISO file exists before proceeding
set "testfile=*.iso"
@REM set "testfile=*.txt"

REM find file
IF EXIST "%ISO%\%testfile%" (
  ECHO file %testfile% exists & goto runcode
) ELSE (
  ECHO file %testfile% does not exist & goto DONE
)
@REM echo nope
@REM pause

@REM pause
:runcode
@REM echo runcode
echo ISO = %ISO%
@REM pause
@REM if exists %ISO%
rem Rename first found %ISO%\*.ISO to use as Windows Original source ISO
cd /D "%ISO%"
@REM pause
for /f "tokens=* delims=" %%x in ('dir "*.iso" /B /O:N') do ren "%ISO%\%%x" "%MountISO%" & goto END

@REM cho end of the road
@REM pause

:DONE
@REM set ERRORLEVEL=1
@REM echo DONE
@REM pause
:END
@REM pause
