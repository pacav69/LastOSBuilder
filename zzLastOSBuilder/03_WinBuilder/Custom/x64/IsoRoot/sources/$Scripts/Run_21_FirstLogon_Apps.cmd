@echo off

rem ** Apply First Logon apps; these are silent installer .exe's, not necessarily SetupS type installers **
FOR %%f IN (%~d0\sources\$FirstLogonApps\*.exe) DO "%%f"
