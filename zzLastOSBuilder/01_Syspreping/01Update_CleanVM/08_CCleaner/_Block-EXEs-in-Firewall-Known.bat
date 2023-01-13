@echo off
setlocal enableextensions
cd /d "%~dp0"

netsh advfirewall firewall add rule name="Blocked with Batchfile %~dp0CCleaner64.exe" dir=out program="%~dp0CCleaner64.exe" action=block

)