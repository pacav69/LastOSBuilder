@echo off
rem Win11 script
set "scriptver=0.0.13"
title %~nx0  v%scriptver%

@REM  setvars= Set variables for all scripts to run
@REM  call the "setvars.cmd" file in the Scripts directory
call %CPS%\setvars.cmd
echo.
@REM echo setvars = %setvars%
set "MCTool=%CP%\MCT"
set "ISO=%CP%\ISO"


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
@REM set WinBuilderPath=%CP%\03_WinBuilder

@REM echo *** Project %ProjectName% ***
@REM echo All Folders Are Short Folder Names:
@REM echo.
@REM echo   Script version: v%scriptver%
@REM echo     Current (CP): %CP%
@REM echo VirtualBox (VBP): %VBP%
@REM echo    Virtual Drive: %VirtDrive%
@REM echo.
@REM rem pause

rem Delete Extracted ISO's and any Builder Processes you have done
echo rd /s "%CP%\%WindowsOriginalPath%"
rd /s /q "%CP%\%WindowsOriginalPath%"

echo rd /s "%CP%\%SysPrepISOPath%"
rd /s /q "%CP%\%SysPrepISOPath%"

echo rd /s "%CP%\%NTLiteISOPath%"
rd /s /q "%CP%\%NTLiteISOPath%"

rd /s /q "%CP%\Temp"

rem Cleanup SysPrep
@REM del /q "%CP%\01_Syspreping\01Update_CleanVM.iso"


@REM rem Cleanup Winbuilder
@REM rd /q /s "%WinBuilderPath%\ISO"
@REM rd /q /s "%WinBuilderPath%\Target"
@REM rd /q /s "%WinBuilderPath%\ProgCache"
@REM rd /q /s "%WinBuilderPath%\Temp"

@REM del /q "%WinBuilderPath%\Win10XPE_x64.iso"
@REM del /q "%WinBuilderPath%\%ProjectName%.iso"

@REM del /q "%CP%\03_WinBuilder\Custom\x64\IsoRoot\sources\%WIMName%"
@REM del /q "%CP%\03_WinBuilder\Custom\x64\IsoRoot\sources\%ESDName%"

pause