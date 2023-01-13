@echo off
title %~nx0
echo.
echo ~ Applying Defender Control ~
echo.

%~dp001_Defender_Control\DefenderControl.exe

IF [%1]==[] pause