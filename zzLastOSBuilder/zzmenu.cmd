@REM  References

@REM  https://www.computerhope.com/issues/ch001674.htm
@REM  https://ss64.com/nt/choice.html
@REM  https://ss64.com/nt/call.html

@REM Menu start
@REM #############################
:MENU_START
@echo off
cls
rem Win11 script
set scriptver=0.0.17
title %~nx0  v%scriptver%
@REM ######### DEBUG ###################
@REM set debug on to check files on >0 / off =0
set debug=0


@REM debug
@REM If %debug% NEQ 0 (
@REM pause
@REM )

rem This first for routine will give the current path without a trailing \
%~d0
cd "%~dp0"
cd %~dps0
for %%f in ("%CD%") do set CP=%%~sf
rem CPS= CP Scripts
set CPS=%CP%\scripts
echo cp = %CP%

@REM pause


@REM  setvars= Set variables for all scripts to run
@REM  call the "setvars.cmd" file in the Scripts directory
call %CPS%\setvars.cmd
echo.
@REM echo setvars = %setvars%
set "MCTool=%CP%\MCT"
set "ISO=%CP%\ISO"

call :mylocalvars

@REM debug

If %debug% NEQ 0 (

echo. HostArchitecture zzmenu    = %HostArchitecture%
echo. HostBuild = %HostBuild%
echo. Bin = %Bin%

pause
)


@REM References
@REM https://ss64.com/nt/if.html
@REM String syntax
@REM    IF [/I] [NOT] item1==item2 command
@REM    IF [/I] [NOT] "item1" == "item2" command
@REM    IF [/I] item1 compare-op item2 command
@REM    IF [/I] item1 compare-op item2 (command) ELSE (command)
@REM key
@REM    item        A text string or environment variable, for more complex
@REM                comparisons, a variable can be modified using
@REM                either Substring or Search syntax.
@REM    command     The command to perform.
@REM    filename    A file to test or a wildcard pattern.
@REM    NOT         Perform the command if the condition is false.
@REM    ==          Perform the command if the two strings are equal.

@REM    /I          Do a case Insensitive string comparison.
@REM compare-op  can be one of
@REM                 EQU : Equal
@REM                 NEQ : Not equal
@REM                 LSS : Less than <
@REM                 LEQ : Less than or Equal <=
@REM                 GTR : Greater than >
@REM                 GEQ : Greater than or equal >=
@REM                 This 3 digit syntax is necessary because the > and <
@REM                 symbols are recognised as redirection operators


IF /I %debug% GTR 0  (

echo. ########################################
echo my project name is %ProjectName%
echo MCTool = %MCTool%
echo ISO = %ISO%
echo, Arch = %Arch%
echo. ########################################
pause

)
ELSE
(goto startcode)


:startcode
cls
rem User Set Variables:
@REM echo.
@REM ECHO Builder Version is v%BuilderVersion%

rem color 02 green char on black background
@REM color 02
rem color 1F white char on light blue background
color 1F

::-------------------------------------------------------------------------------------------
:: LastOS Toolkit - Startup function
::-------------------------------------------------------------------------------------------
cls

echo.
echo.Performing Toolkit pre-cleanup operation, please wait...
@REM call :Cleanup >nul

@REM call %CPS%\CleanUp.cmd >nul
cls
echo.===============================================================================
echo.                           LastOS ToolKit - StartUp
echo.===============================================================================
echo.
echo.Reading Host OS Information...
echo.
echo.%HostOSName% %HostDisplayVersion% - v%HostVersion%.%HostBuild%.%HostServicePackBuild% %HostArchitecture% %HostLanguage%

:: Setting DOS character codepage
if "%HostLanguage%" equ "en-GB" chcp 437 >nul
if "%HostLanguage%" equ "en-US" chcp 437 >nul
if "%HostLanguage%" equ "zh-CN" chcp 936 >nul

@REM echo.
@REM echo.Setting Toolkit and WADK tools environment path variables...
@REM echo.
@REM echo.DISM.exe           =  %DISM%
@REM call :CreateFolder "%DismScratch%"
@REM set "DISM=%DISM% %DismFormat%"
@REM echo.Imagex.exe         =  %Imagex%
@REM echo.Oscdimg.exe        =  %Oscdimg%
@REM echo.Dvdburn.exe        =  %Dvdburn%
@REM echo.7zip.exe           =  %Zip%
@REM echo.Dism++CUI.exe      =  %W10EsdDecrypter%
@REM echo.EsdDecrypt.exe     =  %W81EsdDecrypter%
@REM echo.ToolKitHelper.exe  =  %ToolKitHelper%
@REM echo.ResourceHacker.exe =  %ResourceHacker%
@REM echo.WimlibImagex.exe   =  %WimlibImagex%
echo.
echo. HostArchitecture   = %HostArchitecture%
echo.===============================================================================
echo.
pause
::-------------------------------------------------------------------------------------------
:: LastOS Toolkit - Main Menu
::-------------------------------------------------------------------------------------------
:MainMenu
set errorlevel = 0

cls
echo.===============================================================================
echo.                           LastOS ToolKit Builder - Main Menu
echo.                           v%BuilderVersion%                             .
echo.===============================================================================
echo.
echo.                             [A]   About
echo.
echo.                             [1]   Source
echo.
echo.                             [2]   Integrate
echo.
echo.                             [3]   Remove
echo.
echo.                             [4]   Customize
echo.
echo.                             [5]   Apply
echo.
echo.                             [6]   Target
echo.
echo.                             [7]   Tools
echo.
echo.                             [H]   Help
echo.
echo.
echo.                             [X]   Quit
echo.
echo.===============================================================================
echo.
choice /C:A1234567HX /N /M "Enter Your Choice : "
if errorlevel 10 goto :Quit
if errorlevel 9 goto :HelpMenu
if errorlevel 8 goto :ToolsMenu
if errorlevel 7 goto :TargetMenu
if errorlevel 6 goto :ApplyMenu
if errorlevel 5 goto :CustomizeMenu
if errorlevel 4 goto :RemoveMenu
if errorlevel 3 goto :IntegrateMenu
if errorlevel 2 goto :SourceMenu
if errorlevel 1 goto :about
::-------------------------------------------------------------------------------------------


@REM =================================
:about
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\00.0___About_.cmd
rem timeout 2 > NUL
GOTO MENU_START
@REM =================================
:SourceMenu
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\SourceMenu.cmd
rem timeout 2 > NUL
GOTO MENU_START
@REM =================================
:IntegrateMenu
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\IntegrateMenu.cmd
rem timeout 2 > NUL

GOTO MENU_START
@REM =================================
REM =================================
:RemoveMenu
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\RemoveMenu.cmd
rem timeout 2 > NUL
GOTO MENU_START
@REM =================================


@REM =================================
:CustomizeMenu
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\CustomizeMenu.cmd
rem timeout 2 > NUL
GOTO MENU_START
@REM =================================


@REM =================================
:ApplyMenu
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\ApplyMenu.cmd
rem timeout 2 > NUL
GOTO MENU_START
@REM =================================



@REM =================================
:TargetMenu
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\TargetMenu.cmd
rem timeout 2 > NUL
GOTO MENU_START
@REM =================================

@REM =================================
:ToolsMenu
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\ToolsMenu.cmd
rem timeout 2 > NUL
GOTO MENU_START
@REM =================================

@REM =================================
:HelpMenu
cls
@REM echo errorlevel = %errorlevel%
@REM pause
call %CPS%\HelpMenu.cmd
rem timeout 2 > NUL
GOTO MENU_START
@REM =================================


@REM =================================
:Quit
set INPUT=true
echo Bye
timeout 2 > NUL
exit /b
@REM =================================

ENDLOCAL

:mylocalvars

set "DVD=%CP%\%WindowsOriginalPath%"




if exist "%WinDir%\SysWOW64" (set "HostArchitecture=x64") else (set "HostArchitecture=x86")

for /f "tokens=3 delims= " %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild" ^| find "REG_SZ"') do (set HostBuild=%%i)
for /f "tokens=3 delims= " %%j in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /f "ReleaseId" ^| find "REG_SZ"') do (set /A HostReleaseVersion=%%j & if "%%j" lss "2004" set /A HostDisplayVersion=%%j)
if "%HostDisplayVersion%" equ "" for /f "tokens=3 delims= " %%k in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "DisplayVersion" ^| find "REG_SZ"') do (set "HostDisplayVersion=^(%HostReleaseVersion% %%k^)")
for /f "tokens=3 delims= " %%l in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID" ^| find "REG_SZ"') do (set HostEdition=%%l)
for /f "tokens=3 delims= " %%m in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "InstallationType" ^| find "REG_SZ"') do (set HostInstallationType=%%m)
for /f "tokens=6 delims= " %%o in ('DISM /Online /English /Get-Intl ^| findstr /i /C:"Default system UI language"') do (set HostLanguage=%%o)
for /f "tokens=7 delims=[]. " %%r in ('ver 2^>nul') do (set /A HostServicePackBuild=%%r)
for /f "tokens=4-5 delims=[]. " %%s in ('ver 2^>nul') do (set "HostVersion=%%s.%%t" & set "HostOSName=Windows %%s %HostEdition% %HostInstallationType%" & if "%HostBuild%" equ "7601" set "HostOSName=!HostOSName:6=7! SP1" & if "%HostBuild%" equ "9600" set "HostOSName=!HostOSName:6=8!.1" & if "%HostBuild%" geq "21996" set "HostOSName=!HostOSName:10=11!")

:: Setting WADK tools environment path variables
set "Bin=%CP%\Bin"

:: Setting Toolkit's control flag variables
set "IsSourceSelected=No"
set "IsBootImageSelected=No"
set "IsRecoveryImageSelected=No"
set "IsDialogsEnabled=Yes"
set "IsLogsEnabled=Yes"
set "IsImageRegistryLoaded=No"
set "IsW7SP1CRUSelected=No"

set "PreActTokens=%Custom%\ActivationTokens"
set "CustomFiles=%Custom%\Files"
set "CustomFonts=%Custom%\Fonts"
set "CustomRecoveryImage=%Custom%\RecoveryImage"
set "CustomRegistry=%Custom%\Registry"
set "CustomTerminalServer=%Custom%\TerminalServer"
set "CustomUxTheme=%Custom%\UxTheme"


:: Setting Source OS variables
set SelectedSourceOS=
set OSID=
set "BootWim=%DVD%\sources\boot.wim"
set "InstallWim=%DVD%\sources\install.wim"
set "InstallEsd=%DVD%\sources\install.esd"
set "WinReWim=Windows\System32\Recovery\winre.wim"
set "BootMount=%Mount%\Boot"
set "InstallMount=%Mount%\Install"
set "WinReMount=%Mount%\WinRE"



goto :eof



::-------------------------------------------------------------------------------------------
:: Function to delete a folder(s)
:: Input Parameters [ %~1 : Foldername ]
::-------------------------------------------------------------------------------------------
:RemoveFolder

if exist "%~1" rd /q /s "%~1" >nul

goto :eof
::-------------------------------------------------------------------------------------------


::-------------------------------------------------------------------------------------------
:: Function to Create a Folder
:: Input Parameters [ %~1 : Foldername ]
::-------------------------------------------------------------------------------------------
:CreateFolder

if not exist "%~1" md "%~1" >nul

goto :eof

::-------------------------------------------------------------------------------------------

