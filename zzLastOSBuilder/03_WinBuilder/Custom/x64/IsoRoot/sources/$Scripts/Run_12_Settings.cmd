@echo off

rem ** Make Settings occur **
REG ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /V Settings /D "%~d0\sources\$Settings\Settings.exe" /f