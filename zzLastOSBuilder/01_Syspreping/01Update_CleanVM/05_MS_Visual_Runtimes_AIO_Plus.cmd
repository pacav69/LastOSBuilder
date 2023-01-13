@echo off
title %~nx0
echo.
echo ~ Applying MS Visual Runtimes AIO Plus ~
echo.


reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT

if %OS%==32BIT echo This is a 32bit operating system
if %OS%==64BIT echo This is a 64bit operating system

cd /D %~dp005_MS_Visual_Runtimes_AIO_Plus
extra.exe /VERYSILENT /NORESTART
fsharp.exe
vcredist_x86_2005.exe
vcredist_x86_2008.exe
vcredist_x86_2010.exe
vcredist_x86_2012.exe
vcredist_x86_2013.exe
vcredist_x86_2019.exe
if %OS%==32BIT jsharp_x86.exe

if %OS%==64BIT (
vcredist_x64_2005.exe
vcredist_x64_2008.exe
vcredist_x64_2010.exe
vcredist_x64_2012.exe
vcredist_x64_2013.exe
vcredist_x64_2019.exe
jsharp_x64.exe
vstor_x64.exe
vstor_x86.exe
)

IF [%1]==[] pause