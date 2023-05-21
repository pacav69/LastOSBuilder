@REM pebuilder.cmd

@REM pebuilder.cmd
@echo off
rem Win11 script
set scriptver=0.0.27
title %~nx0  v%scriptver%

set Debug=0

@REM If %debug% NEQ 0 (

@REM echo. ########################################
@REM echo my project name is %ProjectName%
@REM echo MCTool = %MCTool%
@REM echo ISO = %ISO%
@REM echo. ########################################
@REM pause

@REM )
@REM ELSE
@REM (goto startcode)


@REM :startcode

@REM  call the "setvars.cmd" file in the Scripts directory
call %CPS%\setvars.cmd
echo.
echo my project name is %ProjectName%
@REM pause


::-------------------------------------------------------------------------------------------
:: LastOS Toolkit - pebuilder
::-------------------------------------------------------------------------------------------
:pebuilder

start "" "%WinBuilderPath%\Win10XPE.exe"





@REM =================================
:Quit
echo Bye
timeout 2 > NUL
@REM exit /b
@REM =================================
