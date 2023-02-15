@echo off
set scriptver=0.0.15
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
set "ToolsPath=%CP%\02_NTLite\Tools"


@REM rem System Set Variables:
@REM for %%f in ("C:\Program Files\Oracle\VirtualBox") do set VBP=%%~sf
@REM set VBM=%VBP%\VBoxManage.exe
@REM set VMP=%CP%\%VMPath%
@REM @REM set ToolsPath=%CP%\Tools

@REM echo *** Project %ProjectName% ***
@REM echo All Folders Are Short Folder Names:
@REM echo.
@REM rem added script version
@REM echo   Script version: v%scriptver%
@REM echo     Current (CP): %CP%
@REM echo VirtualBox (VBP): %VBP%
@REM echo    Virtual Drive: %VirtDrive%
@REM echo MCTool = %MCTool%
@REM echo.
@REM @REM pause


@REM :run
@REM echo here at run
@REM @REM pause
@REM @REM  check that ISO file exists before proceeding
@REM set "testfile=*.iso"
@REM @REM set "testfile=*.txt"

@REM REM finds file    
@REM IF EXIST "00_Source\%testfile%" (
@REM   ECHO file %testfile% exists & goto runcode
@REM ) ELSE (
@REM   ECHO file %testfile% does not exist & goto DONE
@REM ) 
@REM @REM echo nope
@REM @REM pause

@REM @REM pause
@REM :runcode
@REM echo runcode


:DONE 
@REM echo DONE
@REM pause
:END

