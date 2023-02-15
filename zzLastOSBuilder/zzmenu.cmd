Rem References

rem https://www.computerhope.com/issues/ch001674.htm
rem https://ss64.com/nt/choice.html
rem https://ss64.com/nt/call.html
:MENU_START
@echo off
cls
rem Win11 script
set scriptver=0.0.12
title %~nx0  v%scriptver%
@REM ######### DEBUG ###################
@REM set debug on to check files on / off
set debug=0


@REM debug
If %debug% NEQ 0 (
pause 
)

rem This first for routine will give the current path without a trailing \
%~d0
cd "%~dp0"
cd %~dps0
for %%f in ("%CD%") do set CP=%%~sf
rem CPS= CP Scripts
set CPS=%CP%\scripts
echo cp = %CP%
@REM pause


@REM  setvars= Set variables for all scripts to run
@REM  call the "setvars.cmd" file in the Scripts directory
call %CPS%\setvars.cmd
echo.
@REM echo setvars = %setvars%
set "MCTool=%CP%\MCT"
set "ISO=%CP%\ISO"
@REM References 
@REM https://ss64.com/nt/if.html
@REM String syntax
@REM    IF [/I] [NOT] item1==item2 command
@REM    IF [/I] [NOT] "item1" == "item2" command
@REM    IF [/I] item1 compare-op item2 command
@REM    IF [/I] item1 compare-op item2 (command) ELSE (command)
@REM key
@REM    item        A text string or environment variable, for more complex
@REM                comparisons, a variable can be modified using
@REM                either Substring or Search syntax.
@REM    command     The command to perform.
@REM    filename    A file to test or a wildcard pattern.
@REM    NOT         Perform the command if the condition is false. 
@REM    ==          Perform the command if the two strings are equal. 

@REM    /I          Do a case Insensitive string comparison.
@REM compare-op  can be one of
@REM                 EQU : Equal
@REM                 NEQ : Not equal
@REM                 LSS : Less than <
@REM                 LEQ : Less than or Equal <=
@REM                 GTR : Greater than >
@REM                 GEQ : Greater than or equal >=
@REM                 This 3 digit syntax is necessary because the > and <
@REM                 symbols are recognised as redirection operators


IF /I %debug% GTR 0  (

echo. ########################################
echo my project name is %ProjectName%
echo MCTool = %MCTool%
echo ISO = %ISO%
echo. ########################################
pause

) 
ELSE 
(goto startcode)


:startcode
cls
rem User Set Variables:
@REM echo.
@REM ECHO Builder Version is v%BuilderVersion%

rem color 02 green char on black background
color 02 


::-------------------------------------------------------------------------------------------
:: LastOS Toolkit - Main Menu
::-------------------------------------------------------------------------------------------
:MainMenu
set errorlevel = 0

cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Main Menu
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
echo.
echo.                             [A]   About
echo.
echo.                             [1]   Source
echo.
echo.                             [2]   Integrate
echo.
echo.                             [3]   Remove
echo.
echo.                             [4]   Customize
echo.
echo.                             [5]   Apply
echo.
echo.                             [6]   Target
echo.
echo.                             [7]   Tools
echo.
echo.                             [H]   Help
echo.
echo.
echo.                             [X]   Quit
echo.
echo.===============================================================================
echo.
choice /C:A1234567HX /N /M "Enter Your Choice : "
if errorlevel 10 goto :Quit
if errorlevel 9 goto :HelpMenu
if errorlevel 8 goto :ToolsMenu
if errorlevel 7 goto :TargetMenu
if errorlevel 6 goto :ApplyMenu
if errorlevel 5 goto :CustomizeMenu
if errorlevel 4 goto :RemoveMenu
if errorlevel 3 goto :IntegrateMenu
if errorlevel 2 goto :SourceMenu
if errorlevel 1 goto :about
::-------------------------------------------------------------------------------------------



@REM set INPUT=false
@REM set "MENU_OPTION="
@REM set "OPTION1_INPUT=" 
@REM set "OPTION2_INPUT="
@REM echo +===============================================+
@REM echo . LastOS Builder - USER Main MENU               .
@REM echo . v%BuilderVersion%                             .
@REM echo +===============================================+
@REM echo .                                               .
@REM echo .  1) About                                     .
@REM echo .  2) Rename First ISO                          .
@REM echo .  3) Extract Source ISO                        .
@REM echo .  4) hello                                     .
@REM echo .  5) About                                     .
@REM echo .  6) Rename_First_ISO                          .
@REM echo .  7) Extract Source ISO                        .
@REM echo .  8) Extract Source ISO                        .
@REM echo .  9) Extract Source ISO                        .
@REM echo .  U) Cleanup Utilities Menu                    .
@REM echo .  x) EXIT                                      .
@REM echo .                                               .
@REM echo +===============================================+
@REM set /P MENU_OPTION="OPTION: "

@REM IF %MENU_OPTION%==1 GOTO OPTION1
@REM IF %MENU_OPTION%==2 GOTO OPTION2
@REM IF %MENU_OPTION%==3 GOTO OPTION3
@REM IF %MENU_OPTION%==4 GOTO OPTION4
@REM IF %MENU_OPTION%==5 GOTO OPTION5
@REM IF %MENU_OPTION%==6 GOTO OPTION6
@REM IF %MENU_OPTION%==7 GOTO OPTION7
@REM IF %MENU_OPTION%==8 GOTO OPTION8
@REM IF %MENU_OPTION%==9 GOTO OPTION9
@REM IF %MENU_OPTION%==U GOTO OPTIONU
@REM IF %MENU_OPTION%==x GOTO OPTION99
@REM IF %INPUT%==false GOTO DEFAULT
@REM =================================
:about
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\00.0___About_.cmd
rem timeout 2 > NUL
GOTO MENU_START
@REM =================================
:SourceMenu
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\SourceMenu.cmd
rem timeout 2 > NUL
GOTO MENU_START
@REM =================================
:IntegrateMenu
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\IntegrateMenu.cmd
rem timeout 2 > NUL

GOTO MENU_START
@REM =================================
REM =================================
:RemoveMenu
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\RemoveMenu.cmd
rem timeout 2 > NUL
GOTO MENU_START
@REM =================================


@REM =================================
:CustomizeMenu
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\CustomizeMenu.cmd
rem timeout 2 > NUL
GOTO MENU_START
@REM =================================




@REM =================================
:HelpMenu
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\HelpMenu.cmd
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

@REM rem This first for routine will give the current path without a trailing \
@REM %~d0
@REM cd "%~dp0"
@REM cd %~dps0
@REM for %%f in ("%CD%") do set CP=%%~sf
@REM rem CPS= CP Scripts
@REM set "CPS=%CP%\scripts"
@REM rem User Set Variables:
@REM @REM set /p ProjectName=<%CP%\Settings\ProjectName.txt
@REM echo %CP%
call %CPS%\hello.cmd
pause
echo finished
timeout 2 > NUL
GOTO MENU_START
@REM =================================
:OPTION5
cls
call  %CPS%\00.0___About_.cmd
pause
echo finished
timeout 2 > NUL
GOTO MENU_START
@REM =================================
:OPTION6
cls
call   %CPS%\00.0__Rename_First_ISO_To_Windows_Original_ISO
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
:Quit
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