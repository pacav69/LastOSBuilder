@echo off
set scriptver=0.0.17
title %~nx0  v%scriptver%


rem This first for routine will give the current path without a trailing \
@REM %~d0
@REM cd "%~dp0"
@REM cd %~dps0
@REM for %%f in ("%CD%") do set CP=%%~sf

@REM CPS = root\scripts\
rem User Set Variables:
set /p ProjectName=<%CPS%\Settings\ProjectName.txt
set /p Arch=<%CPS%\Settings\Arch.txt
set /p WinVersion=<%CPS%\Settings\WinVersion.txt
set /p VMName=<%CPS%\Settings\VMName.txt
set /p VMPath=<%CPS%\Settings\VMPath.txt
set /p MountISO=<%CPS%\Settings\MountISO.txt
set /p VHDSize=<%CPS%\Settings\VHDSize.txt
set /p VirtMem=<%CPS%\Settings\VirtMem.txt
set /p VHDFile=<%CPS%\Settings\VHDFile.txt
set /p VirtDrive=<%CPS%\Settings\VirtDrive.txt
set /p WIMName=<%CPS%\Settings\WIMName.txt
set /p ESDName=<%CPS%\Settings\ESDName.txt
set /p WindowsOriginalPath=<%CPS%\Settings\WindowsOriginalPath.txt
set /p SysPrepISOPath=<%CPS%\Settings\SysPrepISOPath.txt
set /p NTLiteISOPath=<%CPS%\Settings\NTLiteISOPath.txt
set /p BuilderVersion=<%CPS%\Settings\BuilderVersion.txt

@REM echo BuilderVersion = %BuilderVersion%
@REM pause 

reg add "HKCU\Console\%%SystemRoot%%_system32_cmd.exe" /v "ScreenBufferSize" /t REG_DWORD /d "0x23290050" /f >nul
reg add "HKCU\Console\%%SystemRoot%%_system32_cmd.exe" /v "WindowSize" /t REG_DWORD /d "0x190050" /f >nul

setlocal EnableExtensions EnableDelayedExpansion

:: Setting Toolkit environment path variables
set "Bin=%CP%Bin"
set "Custom=%CP%Custom"
set "Drivers=%CP%Drivers"
@REM set "DVD=%CP%DVD"
set "DVD=%CP%\00_source"
set "ISO=%CP%ISO"
set "Logs=%CP%Logs"
set "MCTool=%CP%\MCT"
set "Mount=%CP%Mount"
set "Packs=%CP%Packs"
set "ROOT=%CP%"
set "Temp=%CP%Temp"
set "Updates=%CP%Updates"
set "WHD=%CP%WHD"
set "ToolsPath=%CP%\02_NTLite\Tools"

:: Setting Host OS version, architecture and language variables
set HostArchitecture=
set HostBuild=
set HostReleaseVersion=
set HostDisplayVersion=
set HostEdition=
set HostInstallationType=
set HostLanguage=
set HostOSName=
set HostServicePackBuild=
set HostVersion=

if exist "%WinDir%\SysWOW64" (set "HostArchitecture=x64") else (set "HostArchitecture=x86")

@REM set HostArchitecture=x64

for /f "tokens=3 delims= " %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild" ^| find "REG_SZ"') do (set HostBuild=%%i)
for /f "tokens=3 delims= " %%j in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /f "ReleaseId" ^| find "REG_SZ"') do (set /A HostReleaseVersion=%%j & if "%%j" lss "2004" set /A HostDisplayVersion=%%j)
if "%HostDisplayVersion%" equ "" for /f "tokens=3 delims= " %%k in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "DisplayVersion" ^| find "REG_SZ"') do (set "HostDisplayVersion=^(%HostReleaseVersion% %%k^)")
for /f "tokens=3 delims= " %%l in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID" ^| find "REG_SZ"') do (set HostEdition=%%l)
for /f "tokens=3 delims= " %%m in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "InstallationType" ^| find "REG_SZ"') do (set HostInstallationType=%%m)
for /f "tokens=6 delims= " %%o in ('DISM /Online /English /Get-Intl ^| findstr /i /C:"Default system UI language"') do (set HostLanguage=%%o)
for /f "tokens=7 delims=[]. " %%r in ('ver 2^>nul') do (set /A HostServicePackBuild=%%r)
for /f "tokens=4-5 delims=[]. " %%s in ('ver 2^>nul') do (set "HostVersion=%%s.%%t" & set "HostOSName=Windows %%s %HostEdition% %HostInstallationType%" & if "%HostBuild%" equ "7601" set "HostOSName=!HostOSName:6=7! SP1" & if "%HostBuild%" equ "9600" set "HostOSName=!HostOSName:6=8!.1" & if "%HostBuild%" geq "21996" set "HostOSName=!HostOSName:10=11!")

:: Setting WADK tools environment path variables
if "%HostVersion%" equ "6.1" set "DISM=%Bin%\%HostArchitecture%\DISM81\Dism.exe"
if "%HostVersion%" neq "6.1" set "DISM=%Bin%\%HostArchitecture%\DISM10\Dism.exe"
set "DismScratch=%Temp%\DISM"
set "DismFormat=/English /ScratchDir:%DismScratch% /LogPath:%Logs%\Dism.txt /LogLevel:3 /NoRestart"
set "Imagex=%Bin%\%HostArchitecture%\imagex.exe"
set "Oscdimg=%Bin%\%HostArchitecture%\oscdimg.exe"
set "Dvdburn=%Bin%\dvdburn.exe"
set "WimConfigFile=%Bin%\wimscript.ini"

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

:: Setting Source Image information variables
set ImageCount=
set ImageIndexNo=
set ImageArchitecture=
set ImageName=
set ImageDescription=
set ImageFlag=
set ImageEdition=
set ImageInstallationType=
set ImageDefaultLanguage=
set ImageMajorVersion=
set ImageMinorVersion=
set ImageBuild=
set ImageVersion=
set ImageServicePackBuild=
set ImageServicePackLevel=
set PackageBuild=
set PackageVersion=
set PackageServicePackBuild=
set DefaultIndexNo=

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

:: Setting Toolkit's packs environment path variables
set "Apps=%Packs%\Apps"
set "AppLicense=%Bin%\AppLicense"
set "Braille=%Packs%\Braille"
set "DaRT=%Packs%\DaRT"
set "Dedup=%Packs%\Dedup"
set "DirectX9c=%Packs%\DirectX9c"
set "EdgeClassic=%Packs%\EdgeBrowser"
set "EdgeChromium=%Packs%\EdgeChromium"
set "EdgeWebView2=%Packs%\EdgeWebView2"
set "Games=%Packs%\Games"
set "Firefox=%Packs%\Firefox"
set "IE11=%Packs%\IE11"
set "LanguagePacks=%Packs%\LanguagePacks"
set "MediaFeaturePack=%Packs%\MediaFeaturePack"
set "MMRC=%Packs%\MultimediaRestrictedCodecs"
set "NET6=%Packs%\NET6"
set "NET7=%Packs%\NET7"
set "NETCore31=%Packs%\NETCore31"
set "NetFx35=%Packs%\NetFX35"
set "NetFx462=%Packs%\NetFX462"
set "NetFx48=%Packs%\NetFX48"
set "NetFx481=%Packs%\NetFX481"
set "OfficeUWP=%Packs%\OfficeUWP"
set "OpenSSH=%Packs%\OpenSSH"
set "PortableDevices=%Packs%\PortableDevices"
set "PowerShell7=%Packs%\PowerShell7"
set "RDP81=%Packs%\RDP81"
set "RSAT=%Packs%\RSAT"
set "Sidebar=%Packs%\Sidebar"
set "Skins=%Packs%\Skins"
set "SystemRestore=%Packs%\SystemRestore"
set "ThinPC=%Packs%\ThinPC"
set "UAP=%Packs%\UAP"
set "VCRuntime=%Packs%\VCRuntime"
set "Win32Calc=%Packs%\Win32Calc"
set "WinToGo=%Packs%\WinToGo"
set "WMF=%Packs%\WMF"
set "WMR=%Packs%\WMR"
set "WSL=%Packs%\WSL"

:: Setting Toolkit's dependent tools environment path variables
set "Lists=%Bin%\Lists"
set "Patches=%Bin%\Patches"
set "ResourceHacker=%Bin%\ResourceHacker.exe"
set "ToolKitHelper=%Bin%\ToolKitHelper.exe"
set "W10EsdDecrypter=%Bin%\Dism++CUI.exe /ESDFile"
set "W81EsdDecrypter=%Bin%\esddecrypt.exe"
set "WimlibImagex=%Bin%\%HostArchitecture%\wimlib-imagex.exe"
set "XCopy=xcopy.exe /E /I /H /R /Y /J"
set "XMLs=%Bin%\XMLs"
set "W7ESU=%Bin%\Patches\W7ESU"
set "W10CUFix=%Bin%\Patches\W10CUFix"
set "WMCGActTokens=%Bin%\Patches\WMCGActTokens.tpk"
set "PSFExtractor=%Bin%\PSFExtractor.exe"
set "Zip=%Bin%\%HostArchitecture%\7z.exe"
@REM debug
@REM echo. HostArchitecture setvars  = %HostArchitecture%
@REM echo. HostBuild = %HostBuild%
@REM pause


@REM :run
@REM echo here at run
@REM @REM pause
@REM @REM  check that ISO file exists before proceeding
@REM set "testfile=*.iso"
@REM @REM set "testfile=*.txt"

@REM REM finds file    
@REM IF EXIST "00_Source\%testfile%" (
@REM   ECHO file %testfile% exists & goto runcode
@REM ) ELSE (
@REM   ECHO file %testfile% does not exist & goto DONE
@REM ) 
@REM @REM echo nope
@REM @REM pause

@REM @REM pause
@REM :runcode
@REM echo runcode


:DONE 
@REM echo DONE
@REM pause
:END

