@echo off
REM ** simply adds the reg files in the $RegTweaks folder to the registry
FOR %%f IN (%~d0\sources\$RegTweaks\*.reg) DO regedit.exe /s "%%f"