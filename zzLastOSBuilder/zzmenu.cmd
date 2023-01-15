rem https://www.computerhope.com/issues/ch001674.htm
rem https://ss64.com/nt/choice.html
rem https://ss64.com/nt/call.html
:MENU_START
@echo off
cls
rem Win11 script
set "scriptver=0.0.4"
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
echo .  2) Rename First ISO                          .
echo .  3) Extract Source ISO                        .
echo .  4) Extract Source ISO                        .
echo .  5) Extract Source ISO                        .
echo .  6) Extract Source ISO                        .
echo .  7) Extract Source ISO                        .
echo .  8) Extract Source ISO                        .
echo .  9) Extract Source ISO                        .
echo .  U) Cleanup Utilities Menu                    .
echo .  x) EXIT                                      .
echo .                                               .
echo +===============================================+
set /p MENU_OPTION="OPTION: "

IF %MENU_OPTION%==1 GOTO OPTION1
IF %MENU_OPTION%==2 GOTO OPTION2
IF %MENU_OPTION%==3 GOTO OPTION3
IF %MENU_OPTION%==4 GOTO OPTION4
IF %MENU_OPTION%==5 GOTO OPTION5
IF %MENU_OPTION%==6 GOTO OPTION6
IF %MENU_OPTION%==7 GOTO OPTION7
IF %MENU_OPTION%==8 GOTO OPTION8
IF %MENU_OPTION%==9 GOTO OPTION9
IF %MENU_OPTION%==U GOTO OPTIONU
IF %MENU_OPTION%==x GOTO OPTION99
IF %INPUT%==false GOTO DEFAULT
@REM =================================
:OPTION1
@REM set INPUT=true
@REM set /p OPTION1_INPUT="HOST: "
@REM ping %OPTION1_INPUT%
cls
call 00.0___About_.cmd
rem timeout 2 > NUL
GOTO MENU_START
@REM =================================
:OPTION2
@REM set INPUT=true
@REM set /p OPTION2_INPUT="MESSAGE: "
@REM echo MESSAGE: %OPTION2_INPUT%
@REM timeout 2 > NUL
cls
call 00.0__Rename_First_ISO_To_Windows_Original_ISO.cmd
IF %ERRORLEVEL% EQU 1 goto nofile
GOTO MENU_START
:nofile
echo NO File exists
pause
GOTO MENU_START
@REM =================================
:OPTION3
@REM set INPUT=true
@REM set /p OPTION2_INPUT="MESSAGE: "
@REM echo MESSAGE: %OPTION2_INPUT%
@REM timeout 2 > NUL
cls
call 00.1_Extract_Source_ISO.cmd
pause
echo finished
timeout 2 > NUL
GOTO MENU_START
@REM =================================
:OPTION4
cls
call 00.1_Extract_Source_ISO.cmd
pause
echo finished
timeout 2 > NUL
GOTO MENU_START
@REM =================================
:OPTION5
cls
call 00.1_Extract_Source_ISO.cmd
pause
echo finished
timeout 2 > NUL
GOTO MENU_START
@REM =================================
:OPTION6
cls
call 00.1_Extract_Source_ISO.cmd
pause
echo finished
timeout 2 > NUL
GOTO MENU_START
@REM =================================
:OPTION7
cls
call 00.1_Extract_Source_ISO.cmd
pause
echo finished
timeout 2 > NUL
GOTO MENU_START
@REM =================================
:OPTION8
cls
call 00.1_Extract_Source_ISO.cmd
pause
echo finished
timeout 2 > NUL
GOTO MENU_START
@REM =================================
:OPTION9
cls
call 00.1_Extract_Source_ISO.cmd
pause
echo finished
timeout 2 > NUL
GOTO MENU_START
@REM =================================
:OPTIONU
cls
call :Utilities
pause
echo finished
timeout 2 > NUL
GOTO MENU_START

@REM =================================
:OPTION99
set INPUT=true
echo Bye
timeout 2 > NUL
exit /b
@REM =================================
:DEFAULT
echo Option not available
timeout 2 > NUL
GOTO MENU_START
@REM =================================

:Utilities
SETLOCAL
echo +===============================================+
echo . LastOS Builder - Utilities MENU                    .
echo . v%BuilderVersion%                             .
echo +===============================================+
echo .                                               .
echo .  1) About                                     .
echo .  2) Cleanout LastOSBuilder                        .
echo .  3) Extract Source ISO                        .
echo .  4) Extract Source ISO                        .
echo .  5) Extract Source ISO                        .
echo .  6) Extract Source ISO                        .
echo .  7) Extract Source ISO                        .
echo .  8) Extract Source ISO                        .
echo .  9) Extract Source ISO                        .
echo .  R) Return to Main Menu                    .
echo .  x) EXIT                                      .
echo .                                               .
echo +===============================================+
set /p MENU_OPTION="OPTION: "

IF %MENU_OPTION%==1 GOTO OPTION1
IF %MENU_OPTION%==2 GOTO OPTION2
IF %MENU_OPTION%==3 GOTO OPTION3
IF %MENU_OPTION%==4 GOTO OPTION4
IF %MENU_OPTION%==5 GOTO OPTION5
IF %MENU_OPTION%==6 GOTO OPTION6
IF %MENU_OPTION%==7 GOTO OPTION7
IF %MENU_OPTION%==8 GOTO OPTION8
IF %MENU_OPTION%==9 GOTO OPTION9
IF %MENU_OPTION%==R GOTO OPTIONR
IF %MENU_OPTION%==x GOTO OPTION99
IF %INPUT%==false GOTO DEFAULT
@REM =================================
@REM =================================
:OPTION1
@REM set INPUT=true
@REM set /p OPTION1_INPUT="HOST: "
@REM ping %OPTION1_INPUT%
cls
call 00.0___About_.cmd
rem timeout 2 > NUL
GOTO MENU_START
@REM =================================
:OPTION2
cls
call 00.01_Cleanout_LastOS_Builder.cmd
rem timeout 2 > NUL
GOTO MENU_START

@REM =================================
:OPTIONR
echo Returning to Main Menu 
timeout 2 > NUL
GOTO MENU_START

@REM =================================
:OPTION99
set INPUT=true
echo Bye
timeout 2 > NUL
exit /b
@REM =================================
:DEFAULT
echo Option not available
timeout 2 > NUL
GOTO MENU_START
@REM =================================

ENDLOCAL