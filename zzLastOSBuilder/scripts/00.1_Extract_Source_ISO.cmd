@echo off
@REM 00.1_Extract_Source_ISO.cmd using MountISO value
set "scriptver=0.0.23"
title %~nx0  v%scriptver%

set Debug=0


rem call the "setvars.cmd" file in the Scripts directory
call %CPS%\setvars.cmd
echo.
echo Extract source
set "WHD=%CP%WHD"
set "ToolsPath=%CP%\02_NTLite\Tools"

IF /I %debug% == 1 (
echo.
echo my project name is %ProjectName%
echo ToolsPath = %ToolsPath%
pause
)

@REM  check that ISO file exists before proceeding
set "testfile=*.iso"
@REM set "testfile=*.txt"

@REM finds file
IF EXIST "%ISO%\%testfile%" (
  ECHO file %testfile% exists & goto runcode
) ELSE (
  ECHO file %testfile% does not exist & goto Quit
)

:runcode
@REM echo runcode
@REM pause
IF /I %debug% == 1 (
echo cp = %CP%
echo iso = %ISO%
echo ToolsPath = %ToolsPath%
echo WindowsOriginalPath = %WindowsOriginalPath%
pause
)

:winorgpath
@REM ###################################################
@REM windowsOriginalPath
@REM ###################################################
md "%CP%\%WindowsOriginalPath%"

echo "%ToolsPath%\7-Zip\x64\7z.exe" -mtc -aoa x -y "%ISO%\%MountISO%" -o"%CP%\%WindowsOriginalPath%"
%ToolsPath%\7-Zip\x64\7z.exe -mtc -aoa x -y "%ISO%\%MountISO%" -o"%CP%\%WindowsOriginalPath%"

@REM pause

@REM ###################################################
@REM SysPrepISOPath
@REM ###################################################
md "%CP%\%SysPrepISOPath%"
@REM cd /D "%ISO%"

echo "%ToolsPath%\7-Zip\x64\7z.exe" -mtc -aoa x -y "%ISO%\%MountISO%" -o"%CP%\%SysPrepISOPath%" -xr!*.wim
%ToolsPath%\7-Zip\x64\7z.exe -mtc -aoa x -y "%ISO%\%MountISO%" -o"%CP%\%SysPrepISOPath%" -xr!*.wim


@REM ###################################################
@REM Copy SysprepISO to NTLiteISO
@REM ###################################################
md "%CP%\%NTLiteISOPath%"
@REM cd /D "%ISO%"

xcopy /E /C /H /R /Y "%CP%\%SysPrepISOPath%\*" "%CP%\%NTLiteISOPath%\*"

@REM ###################################################
@REM Quit
@REM ###################################################
:Quit
echo Bye
timeout 2 > NUL
@REM exit /b
@REM ###################################################