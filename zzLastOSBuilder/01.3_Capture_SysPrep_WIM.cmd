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

If EXIST %CP%\%SysPrepISOPath%\sources\%WIMName% GOTO Found

echo *** Make Attach and Detach Scripts ***
echo select vdisk file="%VMP%\%VHDFile%">Temp\attach-script.txt
echo attach vdisk>>Temp\attach-script.txt
(echo SELECT PART 1)>>Temp\attach-script.txt
echo assign letter=%VirtDrive%>>Temp\attach-script.txt

echo select vdisk file="%VMP%\%VHDFile%">Temp\detach-script.txt
echo detach vdisk>>Temp\detach-script.txt

diskpart /s Temp\attach-script.txt
echo.
echo * You can edit your Virtual Drive %VirtDrive%: with explorer before you continue this script.
echo.
echo Press a key to capture image from the VHD in drive %VirtDrive%:
echo.
pause>nul
echo *** Capturing the %CP%\%SysPrepISOPath%\sources\%WIMName% from drive %VirtDrive%: ***
echo.
%ToolsPath%\WAIK_x64\dism /Capture-Image /ImageFile:%CP%\%SysPrepISOPath%\sources\%WIMName% /CaptureDir:%VirtDrive%:\ /Name:"%ProjectName% %Arch% %WinVersion%" /compress:fast
echo.
echo *** Disconnecting the VHD from drive %VirtDrive%: ***
diskpart /s Temp\detach-script.txt
echo.
echo Completed Script!
echo.
pause
exit

:Found
echo.
echo !!!!! ERROR, NOT Captured !!!!!
echo ***** Found Existing %CP%\%SysPrepISOPath%\sources\%WIMName% *****
echo Please backup and/or remove them before running this script again
echo.
pause
exit


:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %~1", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B`

