
@REM test cmd
@REM dir
@REM pause

@REM exit /b 1


@REM TIMEOUT /T 60

@REM SETLOCAL EnableExtensions
@REM set EXE=MYEXETOCHECK.exe
@REM :LOOPSTART
@REM FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq %EXE%"') DO IF %%x == %EXE% goto FOUND
@REM goto FIN
@REM :FOUND
@REM TIMEOUT /T 30
@REM goto LOOPSTART
@REM :FIN
