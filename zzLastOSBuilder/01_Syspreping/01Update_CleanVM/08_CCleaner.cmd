@echo off
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%
echo.
echo ~ Applying CCleaner ~
echo.

start "" "%~dp008_CCleaner\CCleaner64.exe"