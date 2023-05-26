@REM testopen.cmd

@REM $size | Out-File -Encoding "ASCII" tmp
@REM Access via CMD:

@REM set /p size=<tmp
@echo off

call D:\gitrepoprojects\LastOSBuilder\zzLastOSBuilder\scripts\openfileselectdialog.ps1 -NamedParam1 test
@REM D:\gitrepoprojects\LastOSBuilder\zzLastOSBuilder\ISO\

@REM this creates a tmp variable that stores the selected filename from
@REM powershell script to be read in by cmd file
 set /p myfile=<tmp
echo  the ISO selected is %myfile%
