@echo off
:start

cls
echo.
color 07
CHOICE /C CHX /M "Select [C] CD or [H] Hard drive E[X]it "
IF %ERRORLEVEL% EQU 3 goto end
IF %ERRORLEVEL% EQU 2 goto sub_hard_drive
IF %ERRORLEVEL% EQU 1 goto sub_cd

:sub_hard_drive
echo sub_hard_drive
pause
goto start

:sub_cd
echo sub_cd
pause
goto start

:end
echo ending
exit /b