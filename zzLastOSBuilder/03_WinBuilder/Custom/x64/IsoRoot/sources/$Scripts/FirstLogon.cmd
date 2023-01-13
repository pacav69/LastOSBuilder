@echo off

rem ** Run integrated Addons **
FOR %%f IN (%~dp0Run_*.cmd) DO "%%f"
