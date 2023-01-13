@echo off
md X:\$Options
copy /Y %~d0\sources\$Options\Remove_Defender.exe X:\$Options
copy /Y %~d0\sources\$Options\ToDo.cmd X:\$Options
