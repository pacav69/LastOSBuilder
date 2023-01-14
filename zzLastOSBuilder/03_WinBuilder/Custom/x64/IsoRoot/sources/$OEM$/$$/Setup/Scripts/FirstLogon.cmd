@ECHO OFF

SET /A XCOUNT=0
:loop
SET /A XCOUNT+=1
echo Attempt #: %XCOUNT%
IF "%XCOUNT%" == "21" (
  GOTO dudend
) ELSE (
  FOR %%i IN (Y X W V U T S R Q P O N M L K J I H G F E D C) DO IF EXIST "%%i:\sources\$Scripts\FirstLogon.cmd" (SET CDROM=%%i:& goto DONECD)
  echo.
  echo Unable to find X:\sources\$Scripts\FirstLogon.cmd
  echo * Plug in your USB disk or insert the DVD again *
  echo.
  timeout /t 3
  echo.
  GOTO loop
)

:DONECD
IF "%CDROM%"=="" (goto dudend)

rem ** Run FirstLogon.cmd from DVD/USB **
%CDROM%
cd\
cd %CDROM%\sources\$Scripts
%CDROM%\sources\$Scripts\FirstLogon.cmd
goto :realend

:dudend
echo Unable to find X:\sources\$Scripts\FirstLogon.cmd > "C:\Users\Public\Desktop\Automation_Failed.txt"
echo did you remove your USB or DVD before setup had completed? >> "C:\Users\Public\Desktop\Automation_Failed.txt"

:realend