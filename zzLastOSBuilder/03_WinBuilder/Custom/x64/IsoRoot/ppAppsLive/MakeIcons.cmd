@ECHO OFF & SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%

:: This routine enables folder icons for all folders in the current folder.
::
:: It does this by making each folder a System file, then creating a desktop.ini
:: file in each folder using the first .ico file found in that folder as the
:: icon source for that folder.
::
:: This routine is NOT recursive, ie it ONLY effects the first level of folders,
:: it does NOT go deeper.

FOR /F "tokens=*" %%G IN ('dir /-B /A:D') DO IF EXIST %%G (
	IF EXIST "%%G\*.ico" CALL :f_CreateFolderIcon "%%G"
)
echo Done
ENDLOCAL&EXIT /B 0

:f_CreateFolderIcon %_DirName%
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
(Set _Dir=%~1)
echo Processing %_Dir%
FOR /F "tokens=*" %%H IN ('dir "!_Dir!\*.ico" /B/O:N/A:-D') DO (
	attrib "%~dp0%%G" +s
	attrib "%~dp0%%G\desktop.ini" -h -s >nul:
	echo [.ShellClassInfo] >"%~dp0%%G\desktop.ini"
	echo ConfirmFileOp=0 >>"%~dp0%%G\desktop.ini"
	echo IconFile=.\%%H >>"%~dp0%%G\desktop.ini"
	echo IconIndex=0 >>"%~dp0%%G\desktop.ini"
	attrib "%~dp0%%G\desktop.ini" +h +s
	GOTO OnlyOne
)
:OnlyOne ::Only use the first .ico file found to set the folder icon
ENDLOCAL&EXIT /B 0
