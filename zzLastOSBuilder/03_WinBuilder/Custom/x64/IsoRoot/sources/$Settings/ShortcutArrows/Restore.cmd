@echo off

   DEL /Y "%~dp0Blank.ico" "%systemroot%\Blank.ico" >nul
  )
)
IF EXIST "%~dp0RestoreArrow.reg" (
    regedit /s "%~dp0RestoreArrow.reg" >nul
)


taskkill /F /IM explorer.exe
cd /d %userprofile%\AppData\Local
attrib –h IconCache.db
del IconCache.db
start explorer
