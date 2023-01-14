@echo off

rem ** Make Post Logon Apps occur **
REG ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /V PostApps /D "%~d0\sources\$PostLogonApps\PostLogon_Apps.exe" /f