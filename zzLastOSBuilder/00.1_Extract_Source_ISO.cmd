@echo off
set "scriptver=0.0.3"
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
rem pause
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
@REM pause


rem Extract Source ISO to Set 00_Source ISO Build Paths
md "%CP%\%WindowsOriginalPath%"
echo "%ToolsPath%\7-Zip_x64\7z.exe" -mtc -aoa x -y "%CP%\00_Source\%MountISO%" -o"%CP%\%WindowsOriginalPath%"
%ToolsPath%\7-Zip_x64\7z.exe -mtc -aoa x -y "%CP%\00_Source\%MountISO%" -o"%CP%\%WindowsOriginalPath%"

md "%CP%\%SysPrepISOPath%"
echo "%ToolsPath%\7-Zip_x64\7z.exe" -mtc -aoa x -y "%CP%\00_Source\%MountISO%" -o"%CP%\%SysPrepISOPath%" -xr!*.wim
%ToolsPath%\7-Zip_x64\7z.exe -mtc -aoa x -y "%CP%\00_Source\%MountISO%" -o"%CP%\%SysPrepISOPath%" -xr!*.wim

Rem Copy SysprepISO to NTLiteISO
md "%CP%\%NTLiteISOPath%"
xcopy /E /C /H /R /Y "%CP%\%SysPrepISOPath%\*" "%CP%\%NTLiteISOPath%\*"
:DONE
