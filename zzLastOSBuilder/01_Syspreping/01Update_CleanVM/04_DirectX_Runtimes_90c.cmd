@echo off
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%
echo.
echo ~ Applying DirectX ~
echo.


cd /D %~dp004_DirectX_Runtimes_90c

%~dp004_DirectX_Runtimes_90c\dxsetup.exe /silent

IF [%1]==[] pause