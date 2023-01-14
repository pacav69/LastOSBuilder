@echo off
rem Win11 script
set "scriptver=0.0.1"
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
cd /D %~dp0

call %~dp008_CCleaner_AutoClean.cmd /Auto
call %~dp009_Remove_Specified_Uninstallers.cmd
call %~dp009_VM_Clean.cmd /Auto
call %~dp010_CleanMgr_AutoClean.cmd /Auto
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