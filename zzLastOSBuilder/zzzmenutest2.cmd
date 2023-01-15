:MENU_START
@echo off
cls
set INPUT=false
set "MENU_OPTION="
set "OPTION1_INPUT="
set "OPTION2_INPUT="
echo +===============================================+
echo . BATCH SCRIPT - USER MENU                      .
echo +===============================================+
echo .                                               .
echo .  1) PING                                      .
echo .  2) DISPLAY MESSAGE                           .
echo .  3) EXIT                                      .
echo .                                               .
echo +===============================================+
set /p MENU_OPTION="OPTION: "

IF %MENU_OPTION%==1 GOTO OPTION1
IF %MENU_OPTION%==2 GOTO OPTION2
IF %MENU_OPTION%==3 GOTO OPTION3
IF %INPUT%==false GOTO DEFAULT

:OPTION1
set INPUT=true
set /p OPTION1_INPUT="HOST: "
ping %OPTION1_INPUT%
timeout 2 > NUL
GOTO MENU_START

:OPTION2
set INPUT=true
set /p OPTION2_INPUT="MESSAGE: "
echo MESSAGE: %OPTION2_INPUT%
timeout 2 > NUL
GOTO MENU_START

:OPTION3
set INPUT=true
echo Bye
timeout 2 > NUL
exit /b

:DEFAULT
echo Option not available
timeout 2 > NUL
GOTO MENU_START

