@echo off
rem Line below is no longer required as ssWPI Requests admin rights
rem regedit /s %~dp0\$ssWPI\RunAsAdmin.reg

start %~dp0$ssWPI\ssWPI.exe
