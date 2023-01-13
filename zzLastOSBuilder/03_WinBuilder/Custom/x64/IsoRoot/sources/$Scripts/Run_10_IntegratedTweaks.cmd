@echo off
REM ** simply adds the reg files in the $RegTweaks folder to the registry
FOR %%f IN (C:\Windows\Setup\$RegTweaks\*.reg) DO regedit.exe /s "%%f"