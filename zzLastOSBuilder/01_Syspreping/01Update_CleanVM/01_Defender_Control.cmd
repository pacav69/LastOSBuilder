@echo off
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%
echo.
echo ~ Applying Defender Control ~
echo.

%~dp001_Defender_Control\DefenderControl.exe

IF [%1]==[] pause