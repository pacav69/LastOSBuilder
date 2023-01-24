@echo off
rem Win11 script
set "scriptver=0.0.2"
title %~nx0  v%scriptver%

rem This first for routine will give the current path without a trailing \
%~d0
cd "%~dp0"
cd %~dps0
for %%f in ("%CD%") do set CP=%%~sf

echo User Set Variables:
echo %CD%
pause
rem User Set Variables:
set /p BuilderVersion=<%CP%\Settings\BuilderVersion.txt
set /p BuilderRepo=<%CP%\Settings\BuilderRepo.txt

set /p ProjectName=<%CP%\Settings\ProjectName.txt
set /p Arch=<%CP%\Settings\Arch.txt
set /p WinVersion=<%CP%\Settings\WinVersion.txt
set /p VMName=<%CP%\Settings\VMName.txt
set /p VMPath=<%CP%\Settings\VMPath.txt
set /p MountISO=<%CP%\Settings\MountISO.txt
set /p VHDSize=<%CP%\Settings\VHDSize.txt
set /p VirtMem=<%CP%\Settings\VirtMem.txt
set /p VHDFile=<%CP%\Settings\VHDFile.txt
set /p VirtDrive=<%CP%\Settings\VirtDrive.txt
set /p WIMName=<%CP%\Settings\WIMName.txt
set /p ESDName=<%CP%\Settings\ESDName.txt
set /p WindowsOriginalPath=<%CP%\Settings\WindowsOriginalPath.txt
set /p SysPrepISOPath=<%CP%\Settings\SysPrepISOPath.txt
set /p NTLiteISOPath=<%CP%\Settings\NTLiteISOPath.txt

rem ******* n VirtualBox file check
rem System Set Variables:
for %%f in ("C:\Program Files\Oracle\VirtualBox") do set VBP=%%~sf
set VBM=%VBP%\VBoxManage.exe
set VMP=%CP%\%VMPath%
set ToolsPath=%CP%\Tools

REM ********************************************
rem added in VirtualBox file check to ensure that 
rem VirtualBox exists before proceeding

setlocal enableextensions

rem if not defined VBM goto :eof
if not exist "%VBM%" goto :notexistvbm
rem *******   
rem check version of VirtualBox

set "vers="
FOR /F "tokens=2 delims==" %%a in ('
        wmic datafile where name^="%VBM:\=\\%" get Version /value 
    ') do set "vers=%%a"
    
set "light="
set "minver=7.0.0.0"
rem echo(%VBM%=%vers%
rem current version installed = 7.0.2.4219
  
rem echo(Version=%vers% 
rem ******* 
rem Version 7 of vbox is required for TPM 2.0 used by Win11 install
rem if Version is less then 7 (minver) then display error message
IF %vers% LSS %minver%  (echo Windows 11 secure guest support is available starting from version 7.0 release) ELSE (echo Good to go VirtualBox v%vers% is installed)
echo.
rem pause


goto :filecheckerstart

:notexistvbm
echo.
echo( ***** File not found: Virtual box is not installed use Virtual box version 7.0 or later)
echo.
 pause
 exit /b
 
endlocal
rem pause

:filecheckerstart 

rem **** file checker starts here
rem System Set Variables:
rem CNP = Check Name Path
for %%f in ("c:\Program Files\Git") do set CNP=%%~sf
rem CFN = Check File Name
rem change CFN to name of file to check 
set CFN=%CNP%\git-cmd.exe
set VMP=%CP%\%VMPath%
set ToolsPath=%CP%\Tools
rem Check Name Simplified
set CNS=Git

rem *******
rem added in %CNS% file check to ensure that 
rem %CNS% exists before proceeding

setlocal enableextensions

rem if not defined CFN goto :eof
if not exist "%CFN%" goto :NotExistCFN
rem *******   
rem check version of CFN = Check File Name

set "vers="
rem set version of file found to variable vers
FOR /F "tokens=2 delims==" %%a in ('
        wmic datafile where name^="%CFN:\=\\%" get Version /value 
    ') do set "vers=%%a"
  
rem minver = Major.minor.min.rev  
set "minver=2.0.0.0"
rem echo(%CFN%=%vers%
  
rem echo(Version=%vers% 
rem ******* 
rem if Version is less then %minver% then display error message
IF %vers% LSS %minver%  (echo File minimum version %CNS% not found)  ELSE (echo Good to go %CNS% v%vers% is installed)
echo.
rem pause

goto :projectstart

:NotExistCFN
echo( ***** File not found: %CNS% is not installed ***
echo( ***** please install %CNS% before continuing  ***
pause
 exit /b
 
endlocal
pause
    
rem :projectstart 

rem **** file checker ends here
    
:projectstart 
echo.
echo *** Project %ProjectName% ***
echo All Folders Are Short Folder Names:
echo.
echo    MountISO name: %MountISO%
echo   BuilderVersion: v%BuilderVersion%
echo   Script version: v%scriptver%
echo     Current (CP): %CP%
echo VirtualBox (VBP): %VBP%
echo    Virtual Drive: %VirtDrive%
echo.

@REM things to do
rem check for updates
rem echo check to see if git application is installed
echo check for builder updates? (get git status from repo)
goto :choice1

:returnchoice1
echo eg to download run:	git pull %BuilderRepo%
echo use BuilderVersion.txt to compare installed and repo version
echo if different download update
echo you are upto update or update files.
echo update cmd files and Settings\BuilderVersion.txt
echo display chaangesinformation 
pause

rem Extract Source ISO to Set 00_Source ISO Build Paths
rem md "%CP%\%WindowsOriginalPath%"
rem echo "%ToolsPath%\7-Zip_x64\7z.exe" -mtc -aoa x -y "%CP%\00_Source\%MountISO%" -o"%CP%\%WindowsOriginalPath%"
rem %ToolsPath%\7-Zip_x64\7z.exe -mtc -aoa x -y "%CP%\00_Source\%MountISO%" -o"%CP%\%WindowsOriginalPath%"

rem md "%CP%\%SysPrepISOPath%"
rem echo "%ToolsPath%\7-Zip_x64\7z.exe" -mtc -aoa x -y "%CP%\00_Source\%MountISO%" -o"%CP%\%SysPrepISOPath%" -xr!*.wim
rem %ToolsPath%\7-Zip_x64\7z.exe -mtc -aoa x -y "%CP%\00_Source\%MountISO%" -o"%CP%\%SysPrepISOPath%" -xr!*.wim

rem Rem Copy SysprepISO to NTLiteISO
rem md "%CP%\%NTLiteISOPath%"
rem xcopy /E /C /H /R /Y "%CP%\%SysPrepISOPath%\*" "%CP%\%NTLiteISOPath%\*"

::-------------------------------------------------------------------------------------------
:choice1
rem this checks 
@REM :choice
@REM set /P c=Do you want to check for updates [Y/N]?
@REM if /I "%c%" EQU "Y" goto :somewhere
@REM if /I "%c%" EQU "N" goto :somewhere_else
@REM goto :choice

@echo off
rem https://ss64.com/nt/choice.html
CHOICE /C YX /M "Select [Y] Check for updates  or [X] eXit"
IF %ERRORLEVEL% EQU 2 goto selectionexit
IF %ERRORLEVEL% EQU 1 goto selection1 


:selection1

echo "I am here because you typed Y"
git status >builderstatus.txt
type builderstatus.txt
pause
goto :returnchoice1
pause
exit

:selectionexit

echo "I am here because you typed X"
pause
exit
# ====================

:somewhere

rem echo "I am here because you typed Y"
echo checking for updates
rem pause
goto :run
rem exit

:somewhere_else

rem echo "I am here because you typed N"
echo exiting program
@REM pause
exit /B

:run
echo here at run
git status >builderstatus.txt
type builderstatus.txt
pause
goto :returnchoice1

@REM pause
@REM  check that ISO file exists before proceeding
@REM set "testfile=*.iso"
@REM @REM set "testfile=*.txt"

@REM REM finds file    
@REM IF EXIST "00_Source\%testfile%" (
@REM   ECHO file %testfile% exists & goto runcode
@REM ) ELSE (
@REM   ECHO file %testfile% does not exist & goto DONE
@REM ) 
@REM echo nope
@REM pause

@REM pause
:runcode
::-------------------------------------------------------------------------------------------
