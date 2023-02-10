@echo off
set scriptver=0.0.9
title %~nx0  v%scriptver%


rem This first for routine will give the current path without a trailing \
@REM %~d0
@REM cd "%~dp0"
@REM cd %~dps0
@REM for %%f in ("%CD%") do set CP=%%~sf

@REM CPS = root\scripts\
rem User Set Variables:
set /p ProjectName=<%CPS%\Settings\ProjectName.txt
set /p Arch=<%CPS%\Settings\Arch.txt
set /p WinVersion=<%CPS%\Settings\WinVersion.txt
set /p VMName=<%CPS%\Settings\VMName.txt
set /p VMPath=<%CPS%\Settings\VMPath.txt
set /p MountISO=<%CPS%\Settings\MountISO.txt
set /p VHDSize=<%CPS%\Settings\VHDSize.txt
set /p VirtMem=<%CPS%\Settings\VirtMem.txt
set /p VHDFile=<%CPS%\Settings\VHDFile.txt
set /p VirtDrive=<%CPS%\Settings\VirtDrive.txt
set /p WIMName=<%CPS%\Settings\WIMName.txt
set /p ESDName=<%CPS%\Settings\ESDName.txt
set /p WindowsOriginalPath=<%CPS%\Settings\WindowsOriginalPath.txt
set /p SysPrepISOPath=<%CPS%\Settings\SysPrepISOPath.txt
set /p NTLiteISOPath=<%CPS%\Settings\NTLiteISOPath.txt
set /p BuilderVersion=<%CPS%\Settings\BuilderVersion.txt

@REM echo BuilderVersion = %BuilderVersion%
@REM pause 

reg add "HKCU\Console\%%SystemRoot%%_system32_cmd.exe" /v "ScreenBufferSize" /t REG_DWORD /d "0x23290050" /f >nul
reg add "HKCU\Console\%%SystemRoot%%_system32_cmd.exe" /v "WindowSize" /t REG_DWORD /d "0x190050" /f >nul

setlocal EnableExtensions EnableDelayedExpansion

:: Setting Toolkit environment path variables
set "Bin=%CP%Bin"
set "Custom=%CP%Custom"
set "Drivers=%CP%Drivers"
set "DVD=%CP%DVD"
set "ISO=%CP%ISO"
set "Logs=%CP%Logs"
set "MCTool=%CP%\MCT"
set "Mount=%CP%Mount"
set "Packs=%CP%Packs"
set "ROOT=%CP%"
set "Temp=%CP%Temp"
set "Updates=%CP%Updates"
set "WHD=%CP%WHD"


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
echo MCTool = %MCTool%
echo.
@REM pause
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

