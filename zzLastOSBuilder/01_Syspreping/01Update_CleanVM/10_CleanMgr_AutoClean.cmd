@echo off
title %~nx0
echo.
echo ~ Applying CleanMgr ~
echo.

regedit.exe /s %~dp0Tools\CleanMgrSage.reg

start /wait "" "%WinDir%\System32\CleanMgr.exe" /SAGERUN:8008