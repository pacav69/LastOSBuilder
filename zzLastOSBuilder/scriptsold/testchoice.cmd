@ECHO OFF
title %~nx0

rem This first for routine will give the current path without a trailing \
%~d0
cd "%~dp0"
cd %~dps0
for %%f in ("%CD%") do set CP=%%~sf

set /p MountISO=<%CP%\Settings\MountISO.txt

:choice
set /P c=Are you sure you want to continue with %MountISO% filename[Y/N]?
if /I "%c%" EQU "Y" goto :somewhere
if /I "%c%" EQU "N" goto :somewhere_else
goto :choice


:somewhere

echo "I am here because you typed Y"
echo you are now using %MountISO% filename
pause
exit

:somewhere_else

echo "I am here because you typed N"
pause
exit