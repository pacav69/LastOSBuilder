@echo off
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%
echo.
echo ~ Applying Gamer Runtimes ~
echo.


cd /D %~dp006_Gamer_Runtimes

Fonts.exe
Copy /Y *.dll %SystemRoot%\System32
oalinst.exe /s
xnafx40_redist.msi /qb
xnafx31_redist.msi /qb
xliveredist.msi /qb
gfwlclient.msi /qb

rd /S /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Games for Windows - LIVE"

IF [%1]==[] pause