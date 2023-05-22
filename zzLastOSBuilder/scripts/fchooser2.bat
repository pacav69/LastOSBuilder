@REM fchooser2.bat
@echo off
setlocal

rem Select a file or folder browsing a directory tree
rem Antonio Perez Ayala

rem Usage examples of SelectFileOrFolder subroutine:

call :SelectFileOrFolder file=
echo/
echo Selected file from *.* = "%file%"
pause

call :SelectFileOrFolder file=*.bat
echo/
echo Selected Batch file = "%file%"
pause

call :SelectFileOrFolder folder=/F
echo/
echo Selected folder = "%folder%"
pause

goto :EOF


:SelectFileOrFolder resultVar [ "list of wildcards" | /F ]

setlocal EnableDelayedExpansion

rem Process parameters
set "files=*.*"
if "%~2" neq "" (
   if /I "%~2" equ "/F" (set "files=") else set "files=%~2"
)

rem Set the number of lines per page, max 34
set "pageSize=30"
set "char=0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

rem Load current directory contents
set "name[1]=<DIR>  .."
:ProcessThisDir
set "numNames=1"
for /D %%a in (*) do (
   set /A numNames+=1
   set "name[!numNames!]=<DIR>  %%a"
)
for %%a in (%files%) do (
   set /A numNames+=1
   set "name[!numNames!]=       %%a"
)
set /A numPages=(numNames-1)/pageSize+1

rem Show directory contents, one page at a time
set start=1
:ShowPage
set /A page=(start-1)/pageSize+1, end=start+pageSize-1
if %end% gtr %numNames% set end=%numNames%
cls
echo Page %page%/%numPages% of %CD%
echo/
if %start% equ 1 (set base=0) else set "base=1"
set /A lastOpt=pageSize+base, j=base
for /L %%i in (%start%,1,%end%) do (
   for %%j in (!j!) do echo     !char:~%%j,1! -  !name[%%i]!
   set /A j+=1
)
echo/

rem Assemble the get option message
if %start% equ 1 (set "mssg=: ") else (set "mssg= (0=Previous page")
if %end% lss %numNames% (
   if "%mssg%" equ ": " (set "mssg= (") else set "mssg=%mssg%, "
   set "mssg=!mssg!Z=Next page"
)
if "%mssg%" neq ": " set "mssg=%mssg%): "

:GetOption
choice /C "%char%" /N /M "Select desired item%mssg%"
if %errorlevel% equ 1 (
   rem "0": Previous page or Parent directory
   if %start% gtr 1 (
      set /A start-=pageSize
      goto ShowPage
   ) else (
      cd ..
      goto ProcessThisDir
   )
)
if %errorlevel% equ 36 (
   rem "Z": Next page, if any
   if %end% lss %numNames% (
      set /A start+=pageSize
      goto ShowPage
   ) else (
      goto GetOption
   )
)
if %errorlevel% gtr %lastOpt% goto GetOption
set /A option=start+%errorlevel%-1-base
if %option% gtr %numNames% goto GetOption
if defined files (
   if "!name[%option%]:~0,5!" neq "<DIR>" goto endSelect
) else (
   choice /C OS /M "Open or Select '!name[%option%]:~7!' folder"
   if errorlevel 2 goto endSelect
)
cd "!name[%option%]:~7!"
goto ProcessThisDir

:endSelect
rem Return selected file/folder
for %%a in ("!name[%option%]:~7!") do set "result=%%~Fa"
endlocal & set "%~1=%result%
exit /B