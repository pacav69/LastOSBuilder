@echo off
title %~nx0
echo.
echo ~ Applying DirectX ~
echo.


cd /D %~dp004_DirectX_Runtimes_90c

%~dp004_DirectX_Runtimes_90c\dxsetup.exe /silent

IF [%1]==[] pause