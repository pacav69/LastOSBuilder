@echo off

IF EXIST "%~dp0Blank.ico" (
   IF NOT EXIST "%systemroot%\Blank.ico" (
   COPY /Y "%~dp0Blank.ico" "%systemroot%\Blank.ico" >nul
  )
)
IF EXIST "%~dp0RemoveArrow.reg" (
    regedit /s "%~dp0RemoveArrow.reg" >nul
)


taskkill /F /IM explorer.exe
cd /d %userprofile%\AppData\Local
attrib –h IconCache.db
del IconCache.db
start explorer
