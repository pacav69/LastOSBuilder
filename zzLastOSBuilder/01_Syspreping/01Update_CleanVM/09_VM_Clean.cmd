@echo off
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%
echo.
echo ~ Applying Cleaning ~
echo.

rem Clean Events
echo.
echo ~ Clean Events ~
FOR /F "tokens=1,2*" %%V IN ('bcdedit') DO SET adminTest=%%V
IF (%adminTest%)==(Access) goto noAdmin
for /F "tokens=*" %%G in ('wevtutil.exe el') DO (call :do_clear "%%G")
echo.
goto theClean
:do_clear
echo clearing %1
wevtutil.exe cl %1
goto :eof
:noAdmin

:theClean

echo.
echo **********************************************
echo ************ Cleaning for Sysprep ************
echo **********************************************

echo.
echo ~ Clean .NET Assemblies ~
taskkill /IM mscorsvw.exe /f
echo.
FOR /D %%f IN (C:\Windows\assembly\Nati*.*) do rd /q /s "%%f"
FOR /D %%f IN (C:\Windows\assembly\Nati*.*) do del /q /s /f "%%f"

echo.
echo ~ Clean SoftwareDistribution ~
net stop wuauserv
net stop bits
del /q /f "C:\Windows\SoftwareDistribution\*"
FOR /D %%f IN (C:\Windows\SoftwareDistribution\*) do rd /q /s "%%f"
FOR /D %%f IN (C:\Windows\SoftwareDistribution\*) do del /q /s /f "%%f"
echo.

echo.
echo ~ Clean Windows Defender Scans ~
Takeown /f "C:\ProgramData\Microsoft\Windows Defender\Scans\*"
Icacls "C:\ProgramData\Microsoft\Windows Defender\Scans\*" /GRANT administrators:F
Takeown /f "C:\ProgramData\Microsoft\Windows Defender\Definition Updates\Default\*"
Icacls "C:\ProgramData\Microsoft\Windows Defender\Definition Updates\Default\*" /GRANT administrators:F
del /q /f "C:\ProgramData\Microsoft\Windows Defender\Scans\mpcache*"
del /q /f "C:\ProgramData\Microsoft\Windows Defender\Definition Updates\Default\*.*"
del /q /f "C:\ProgramData\Microsoft\Windows Defender\Scans\*.*"
echo.

echo.
echo ~ Clean winSxS ~
dism /online /cleanup-image /startcomponentcleanup /resetbase
echo.

echo.
echo ~ Clean Manifest Cache ~
net stop trustedinstaller
Takeown /f C:\Windows\WinSxS\ManifestCache\*
Icacls C:\Windows\WinSxS\ManifestCache\* /GRANT administrators:F
del /q /f "C:\Windows\WinSxS\ManifestCache\*.bin"
echo.

echo ~ Clean temp folder ~
del /q /f "C:\Windows\Temp\*"
FOR /D %%f IN (C:\Windows\temp\*) do rd /q /s "%%f"
echo.

rem Random cleanups
del /q /f "C:\Users\Default\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Switch between windows.lnk"
rd /q "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Maintenance"
echo.
echo ~ Done Cleaning ~
echo.
IF [%1]==[] pause