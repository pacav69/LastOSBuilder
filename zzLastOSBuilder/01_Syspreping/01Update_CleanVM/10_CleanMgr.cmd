@echo off
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%

start "" "%WinDir%\System32\CleanMgr.exe"