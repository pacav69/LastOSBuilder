@echo off
setlocal enableextensions
cd /d "%~dp0"

netsh advfirewall firewall add rule name="Blocked with Batchfile %~dp0PartAssist.exe" dir=out program="%~dp0PartAssist.exe" action=block

)