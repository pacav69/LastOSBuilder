@echo off
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%

Setlocal enableextensions EnableDelayedExpansion

rem Copy the call line below and modify the partial text you want removed from Uninstallers, Add/Remove Programs.

call :RemoveUninstaller Microsoft Visual
call :RemoveUninstaller OpenAL
call :RemoveUninstaller Microsoft XNA
call :RemoveUninstaller Microsoft Games for Windows
call :RemoveUninstaller NEF Codec

rem set removethese=Microsoft Visual
rem call :RemoveUninstaller !removethese!


goto:eof

:RemoveUninstaller
set input=%1 %2 %3 %4 %5 %6 %7 %8 %9

for /f "tokens=* delims= " %%a in ("%input%") do set input=%%a
for /l %%a in (1,1,100) do if "!input:~-1!"==" " set input=!input:~0,-1!

set check=%input%

echo Searching for: !check!

rem x64

for /f "usebackq delims=" %%a in (`reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" `) do (
 set key=%%a
 
 for /f "tokens=3*" %%c in ('reg query "!key!" ^/v "DisplayName" 2^> nul') do (
 set value=%%c %%d 
 
 ECHO.!value! | FIND /I "!check!">Nul && (
 Echo.Found "!value!"
 echo Deleting Key: !key!
 reg delete "!key!" /f 
 ) || ( set NotFound=1 )
 )
)


rem x86

for /f "usebackq delims=" %%a in (`reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"`)  do (
 set key=%%a
 
 for /f "tokens=3*" %%c in ('reg query "!key!" ^/v "DisplayName" 2^> nul') do (
 set value=%%c %%d
  
 ECHO.!value! | FIND /I "!check!">Nul && (
 Echo.Found "!value!"
 echo Deleting Key: !key!
 reg delete "!key!" /f 
 ) || ( set NotFound=1 )
 )
)
rem pause
exit /b
goto:eof

endlocal