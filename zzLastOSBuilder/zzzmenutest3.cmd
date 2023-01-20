rem https://www.computerhope.com/issues/ch001674.htm
rem https://ss64.com/nt/choice.html
rem https://ss64.com/nt/call.html
:MENU_START
@echo off
cls
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%

rem This first for routine will give the current path without a trailing \
%~d0
cd "%~dp0"
cd %~dps0
for %%f in ("%CD%") do set CP=%%~sf

rem User Set Variables:
set /p BuilderVersion=<%CP%\Settings\BuilderVersion.txt

rem color 02 green char on black background
color 02 
set INPUT=false
set "MENU_OPTION="
set "OPTION1_INPUT=" 
set "OPTION2_INPUT="
echo +===============================================+
echo . LastOS Builder - USER MENU                    .
echo . v%BuilderVersion%                             .
echo +===============================================+
echo .                                               .
echo .  1) About                                     .
echo .  2) Rename_First_ISO                          .
echo .  3) DISPLAY MESSAGE                           .
echo .  x) EXIT                                      .
echo .                                               .
echo +===============================================+
set /p MENU_OPTION="OPTION: "

IF %MENU_OPTION%==1 GOTO OPTION1
IF %MENU_OPTION%==2 GOTO OPTION2
IF %MENU_OPTION%==3 GOTO OPTION3
IF %MENU_OPTION%==x GOTO OPTION99
IF %INPUT%==false GOTO DEFAULT

:OPTION1
@REM set INPUT=true
@REM set /p OPTION1_INPUT="HOST: "
@REM ping %OPTION1_INPUT%
cls
call 00.0___About_.cmd
rem timeout 2 > NUL
GOTO MENU_START

:OPTION2
@REM set INPUT=true
@REM set /p OPTION2_INPUT="MESSAGE: "
@REM echo MESSAGE: %OPTION2_INPUT%
@REM timeout 2 > NUL
cls
call 00.0__Rename_First_ISO_To_Windows_Original_ISO.cmd
GOTO MENU_START

:OPTION3
set INPUT=true
set /p OPTION2_INPUT="MESSAGE: "
echo MESSAGE: %OPTION2_INPUT%
timeout 2 > NUL
GOTO MENU_START

:OPTION99
set INPUT=true
echo Bye
timeout 2 > NUL
exit /b

:DEFAULT
echo Option not available
timeout 2 > NUL
GOTO MENU_START

