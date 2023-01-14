@echo off
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%

md X:\$Options
copy /Y %~d0\sources\$Options\Remove_Defender.exe X:\$Options
copy /Y %~d0\sources\$Options\ToDo.cmd X:\$Options
