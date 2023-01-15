@echo off
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%
echo.
echo ~ Applying CCleaner ~
echo.


start /wait "" "%~dp008_CCleaner\CCleaner64.exe" /AUTO