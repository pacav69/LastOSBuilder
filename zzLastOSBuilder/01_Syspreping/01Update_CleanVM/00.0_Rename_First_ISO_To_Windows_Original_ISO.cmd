@echo 
rem Win11 script
set "scriptver=0.0.1"
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
echo     Current (CP): %CP%
echo VirtualBox (VBP): %VBP%
echo    Virtual Drive: %VirtDrive%
echo.
rem pause

rem Rename first found 00_Source\*.ISO to use as Windows Original source ISO
cd /D "%CP%\00_Source"
for /f "tokens=* delims=" %%x in ('dir "*.iso" /B /O:N') do ren "%CP%\00_Source\%%x" "%MountISO%" & goto DONE

:DONE