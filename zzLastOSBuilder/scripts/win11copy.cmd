@echo off
@REM win11copy.cmd
@REM Copy downloaded windows 11 iso from MCT directory to ISO directory
cls
rem Win11 script
set scriptver=0.0.8
title %~nx0  v%scriptver%

 set "XCopy=xcopy.exe /E /I /H /R /Y /J"

@REM echo MCTool = %MCTool%
@REM echo ISO = %ISO%
@REM pause
echo.-------------------------------------------------------------------------------
echo.####Copying Windows 11 to %ISO% ###############
echo.-------------------------------------------------------------------------------

xcopy %MCTool%\"11 22H2 Professional x64 en-US.iso" %ISO%