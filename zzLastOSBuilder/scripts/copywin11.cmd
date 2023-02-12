@echo off
@REM Copy downloaded windows 11 iso from MCT directory to ISO directory
cls
rem Win11 script
set scriptver=0.0.8
title %~nx0  v%scriptver%

@REM echo MCTool = %MCTool%
@REM echo ISO = %ISO%
@REM pause
echo.-------------------------------------------------------------------------------
echo.####Copying Windows 11 to %ISO% ###############
echo.-------------------------------------------------------------------------------

copy %MCTool%\"11 22H2 Professional x64 en-US.iso" %ISO%