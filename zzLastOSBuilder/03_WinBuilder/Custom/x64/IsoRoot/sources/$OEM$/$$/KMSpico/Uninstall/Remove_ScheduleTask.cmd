@echo off
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%

pushd "%~dp0"
SCHTASKS /DELETE /F /TN "AutoPico Daily Restart"
popd
exit
