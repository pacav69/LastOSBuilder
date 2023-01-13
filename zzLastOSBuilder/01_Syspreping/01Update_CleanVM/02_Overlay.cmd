@echo off
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%
echo.
echo ~ Applying Overlays ~
echo.

rem make sure I can write to the folder I need to

Takeown /f "C:\Windows\Web" /A /R /D Y
Icacls "C:\Windows\Web" /GRANT administrators:F /T /C

Takeown /f "C:\Windows\Resources" /A /R /D Y
Icacls "C:\Windows\Resources" /GRANT administrators:F /T /C

Takeown /f "C:\ProgramData\Microsoft\Windows\SystemData" /A /R /D Y
Icacls "C:\ProgramData\Microsoft\Windows\SystemData" /GRANT administrators:F /T /C

rem Copy the files
xcopy %~dp002_Overlay C:\ /E /C /H /R /Y

IF [%1]==[] pause