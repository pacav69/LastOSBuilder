@ECHO off
rem https://www.computerhope.com/issues/ch001674.htm
rem https://ss64.com/nt/choice.html
cls
:start
ECHO.
ECHO 1. Print Hello
ECHO 2. Print Bye
ECHO 3. Print Test
set choice=
set /p choice=Type the number to print text.
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto hello
if '%choice%'=='2' goto bye
if '%choice%'=='3' goto test
ECHO "%choice%" is not valid, try again
ECHO.
goto start
:hello
ECHO HELLO
goto end
:bye
ECHO BYE
goto end
:test
ECHO TEST
goto end
:end
pause

