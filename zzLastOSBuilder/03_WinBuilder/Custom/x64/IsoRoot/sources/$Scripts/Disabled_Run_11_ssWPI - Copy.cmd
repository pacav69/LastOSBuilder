@echo off

rem ** Make ssWPI occur **
rem REG ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /V ssWPI /D "%~d0\sources\$ssWPI\ssWPI.exe -LoadDefaultPreset" /f
REG ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /V ssWPI /D "%~d0\sources\$ssWPI\ssWPI.exe -Install" /f