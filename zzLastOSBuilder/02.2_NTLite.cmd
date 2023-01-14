@echo off
rem Win11 script
set "scriptver=1.0"
title %~nx0  v%scriptver%

call :isAdmin

if %errorlevel% == 0 (
goto :run
) else (
echo Requesting administrative privileges...
goto :UACPrompt
)

exit /b

:isAdmin
fsutil dirty query %systemdrive% >nul
exit /b

:run
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
echo   Script version: v%scriptver%
echo     Current (CP): %CP%
echo VirtualBox (VBP): %VBP%
echo    Virtual Drive: %VirtDrive%
echo.
rem pause

copy /y "%CP%\02_NTLite\settings_Template.xml" "%CP%\02_NTLite\settings.xml"

"%ToolsPath%\fnr.exe" --silent --cl --dir "%CP%\02_NTLite" --fileMask "settings.xml" --find "NTLiteISOPath" --replace "%CP%\%NTLiteISOPath%"


start "" "%CP%\02_NTLite\NTLite.exe"

rem echo Done!
rem pause
exit /b

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %~1", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B`
