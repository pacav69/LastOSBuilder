@REM openpsfile.cmd
@echo off
@REM powershell.exe -file
@REM  ref: https://stackoverflow.com/questions/4037939/powershell-says-execution-of-scripts-is-disabled-on-this-system
@REM turn off powershell restrictions
@REM powershell Set-ExecutionPolicy -Scope CurrentUser Restricted
@REM turn on powershell restrictions for CurrentUser
@REM powershell Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
@REM set "ISO=D:\gitrepoprojects\LastOSBuilder\zzLastOSBuilder\ISO\"
@REM -NamedParam1 test
@REM turn on powershell restrictions for CurrentUser
powershell.exe Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
echo *****************************
echo The ISO = %ISO%
powershell.exe -file D:\gitrepoprojects\LastOSBuilder\zzLastOSBuilder\scripts\openfileselectdialog.ps1  %ISO%
@REM  set /p myfile=<tmp
@REM  echo *****************************
@REM echo  the ISO selected is myfile  %myfile%
@REM echo *****************************