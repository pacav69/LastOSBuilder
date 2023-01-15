@ECHO off
rem https://www.computerhope.com/issues/ch001674.htm
rem https://ss64.com/nt/choice.html
rem https://ss64.com/nt/call.html

:start
cls
ECHO.
ECHO **********
ECHO 1. About
ECHO 2. Rename First ISO
ECHO 3. Print Test
ECHO x.Exit
ECHO **********
set choice=
set /p choice=Option:
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto choice1
if '%choice%'=='2' goto choice2
if '%choice%'=='3' goto choice3
if '%choice%'=='x' goto choiceexit
ECHO "%choice%" is not valid, try again
ECHO.
goto start
:choice1
ECHO choice1
call 00.0___About_.cmd
goto start
goto end
:choice2
call 00.0__Rename_First_ISO_To_Windows_Original_ISO.cmd
ECHO choice2
goto start
goto end
:choice3
ECHO choice3
goto start
goto end
rem 
:choiceexit
ECHO choiceexit
goto end
:end
pause

