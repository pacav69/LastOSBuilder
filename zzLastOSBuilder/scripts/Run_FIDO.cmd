:::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights
:::::::::::::::::::::::::::::::::::::::::
@echo off
CLS
ECHO.
ECHO =============================
ECHO Running Admin shell
ECHO =============================
del Local.ini
echo %LocalAppData%>Local.ini

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (shift & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs"
exit /B

:gotPrivileges
::::::::::::::::::::::::::::
::START
::::::::::::::::::::::::::::
setlocal & pushd .

REM put here code as you like
cd /d %~dp0

set "myfile=fido"

powershell -command "& {Set-ExecutionPolicy -Scope LocalMachine Unrestricted -Force}"
rmdir /s /q .\%myfile%

start /wait "" powershell -command .\downloadlatestfido.ps1
"C:\Program Files\7-Zip\7z" x -y %myfile%*.lzma -o%myfile%
ren .\%myfile%\fido* %myfile%.ps1
start "" powershell -command .\%myfile%\%myfile%.ps1
@REM start "" powershell -command .\Fido.ps1

:: Return the security policy to defaults, restricted...
powershell -command "& {Set-ExecutionPolicy -Scope LocalMachine Restricted -Force}"
powershell -command "& {Set-ExecutionPolicy -Scope CurrentUser Undefined -Force}"
powershell -command "& {Set-ExecutionPolicy -Scope Process Undefined -Force}"
