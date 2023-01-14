@ECHO OFF & SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%

:: This routine disables folder icons for all folders in the current folder.
::
:: It does this by removing the System attribute from each folder then deleting
:: any desktop.ini file found in that folder.
::
:: This routine is NOT recursive, ie it ONLY effects the first level of folders,
:: it does NOT go deeper.

FOR /F "tokens=*" %%G IN ('dir /-B /A:D') DO IF EXIST %%G (
	echo Processing %%G
	attrib "%~dp0%%G" -s
	attrib "%~dp0%%G\desktop.ini" -h -s >nul:
	del "%~dp0%%G\desktop.ini" >nul 2>&1
)
echo Done
ENDLOCAL&EXIT /B 0
