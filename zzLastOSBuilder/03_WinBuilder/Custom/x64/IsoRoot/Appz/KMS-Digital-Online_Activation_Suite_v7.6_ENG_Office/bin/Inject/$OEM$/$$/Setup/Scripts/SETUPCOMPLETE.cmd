@echo off
title OEM
set _Args=%*
if "%~1" NEQ "" (
  set _Args=%_Args:"=%
)
fltmc 1>nul 2>nul || (
  cd /d "%~dp0"
  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~dp0"" && ""%~dpnx0"" ""%_Args%""", "", "runas", 0 > "%temp%\GetAdmin.vbs"
  "%temp%\GetAdmin.vbs"
  del /f /q "%temp%\GetAdmin.vbs" 1>nul 2>nul
  exit
)
cd %~dp0
cd /d "%~dp0"
IF /I "%PROCESSOR_ARCHITECTURE%" EQU "AMD64" (set xOS=x64) else (set xOS=x86)
if not exist "%windir%\KMS\KMSInject.cmd" (
xcopy /cryi %xOS%\* %windir%\KMS\%xOS% >nul 2>&1
copy /y run.cmd %windir%\KMS\KMSInject.cmd >nul 2>&1
schtasks /create /tn "KMS_Activation" /xml "%~dp0x86\KMS.xml" /f >nul 2>&1
)
del /f /q %windir%\KMS\%xOS%\*.xml >nul 2>&1
start /min %windir%\KMS\KMSInject.cmd -act && RMDIR /S /Q "%WINDIR%\Setup\Scripts\x64\" && RMDIR /S /Q "%WINDIR%\Setup\Scripts\x86\" && RMDIR /S /Q "%WINDIR%\Setup\Scripts\"