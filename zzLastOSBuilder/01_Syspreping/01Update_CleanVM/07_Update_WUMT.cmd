@echo off
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%
echo.
echo ~ Applying Updates ~
echo.

start "" "%~dp007_Update_WUMT\wumt_x64.exe"