@echo off
rem https://ss64.com/nt/choice.html
CHOICE /C CH /M "Select [C] CD or [H] Hard drive"
IF %ERRORLEVEL% EQU 2 goto sub_hard_drive
IF %ERRORLEVEL% EQU 1 goto sub_cd


:sub_hard_drive

echo "I am here because you typed H"
pause
exit

:sub_cd

echo "I am here because you typed C"
pause
exit
