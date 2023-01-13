@echo off
title %~nx0

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
cd /D %~dp0

call %~dp000_Tweaks.cmd /Auto
call %~dp001_Defender_Control.cmd /Auto
call %~dp002_Overlay.cmd /Auto
call %~dp003_Install_DotNet_35.cmd /Auto
call %~dp004_DirectX_Runtimes_90c.cmd /Auto
call %~dp005_MS_Visual_Runtimes_AIO_Plus.cmd /Auto
call %~dp006_Gamer_Runtimes.cmd /Auto
echo.
echo ~ Done ~
echo.
pause
exit /b

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %~1", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B`