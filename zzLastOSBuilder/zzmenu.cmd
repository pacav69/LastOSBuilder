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
@REM color 02 
color 1F

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
:ApplyMenu
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\ApplyMenu.cmd
rem timeout 2 > NUL
GOTO MENU_START
@REM =================================



@REM =================================
:TargetMenu
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\TargetMenu.cmd
rem timeout 2 > NUL
GOTO MENU_START
@REM =================================

@REM =================================
:ToolsMenu
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\ToolsMenu.cmd
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


@REM =================================
:Quit
set INPUT=true
echo Bye
timeout 2 > NUL
exit /b
@REM =================================

ENDLOCAL