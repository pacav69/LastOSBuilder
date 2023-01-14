@echo off
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%
echo.
echo ~ Applying CleanMgr ~
echo.

regedit.exe /s %~dp0Tools\CleanMgrSage.reg

start /wait "" "%WinDir%\System32\CleanMgr.exe" /SAGERUN:8008