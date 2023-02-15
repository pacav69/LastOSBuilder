
@REM cleanoutsources.cmd
@echo off
rem Win11 script
set "scriptver=0.0.15"
title %~nx0  v%scriptver%

@REM  setvars= Set variables for all scripts to run
@REM  call the "setvars.cmd" file in the Scripts directory
call %CPS%\setvars.cmd
echo.
@REM echo setvars = %setvars%
@REM set "MCTool=%CP%\MCT"
@REM set "ISO=%CP%\ISO"

rem Delete Extracted ISO's and any Builder Processes you have done
echo rd /s "%CP%\%WindowsOriginalPath%"
rd /s /q "%CP%\%WindowsOriginalPath%"

echo rd /s "%CP%\%SysPrepISOPath%"
rd /s /q "%CP%\%SysPrepISOPath%"

echo rd /s "%CP%\%NTLiteISOPath%"
rd /s /q "%CP%\%NTLiteISOPath%"

rd /s /q "%CP%\Temp"

@REM  Cleanup SysPrep
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

@REM pause