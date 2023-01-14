@echo off
set ver=v7.6
title KMS (Inject) Activation Windows ^& Office %ver% by mephistooo2 - TNCTR.com
mode con cols=70 lines=2
color 4e
set Auto=0
IF "%~1"=="-act" set Auto=1
IF "%~1"=="-act" GOTO :Activate
::===============================================================================================================
echo ADMIN RIGHTS ACTIVATE...
set _Args=%*
if "%~1" NEQ "" (
  set _Args=%_Args:"=%
)
fltmc 1>nul 2>nul || (
  cd /d "%~dp0"
  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~dp0"" && ""%~dpnx0"" ""%_Args%""", "", "runas", 1 > "%temp%\GetAdmin.vbs"
  "%temp%\GetAdmin.vbs"
  del /f /q "%temp%\GetAdmin.vbs" 1>nul 2>nul
  exit
)
::===============================================================================================================
setlocal enabledelayedexpansion
setlocal EnableExtensions
pushd "%~dp0"
mode con cols=80 lines=49
color fc
cd /d "%~dp0"
if /i "%PROCESSOR_ARCHITECTURE%"=="x86" if not defined PROCESSOR_ARCHITEW6432 set xOS=x86
for /f "tokens=2 delims==" %%a IN ('"wmic Path Win32_OperatingSystem Get Caption /format:LIST"')do (set NameOS=%%a) >nul 2>&1
for /f "tokens=2 delims==" %%a IN ('"wmic Path Win32_OperatingSystem Get CSDVersion /format:LIST"')do (set SP=%%a) >nul 2>&1
for /f "tokens=2 delims==" %%a IN ('"wmic Path Win32_OperatingSystem Get Version /format:LIST"')do (set Version=%%a) >nul 2>&1
:MAINMENU
echo ================================================================================
set ver=v7.6
set yy=%date:~-4%
set mm=%date:~-7,2%
set dd=%date:~-10,2%
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a:%%b)
echo                                                              %dd%.%mm%.%yy% ^- %mytime%
echo.
echo   KMS (Inject) Activation Windows ^& Office %ver% - mephistooo2 - www.TNCTR.com 
echo.
echo   SUPPORT MICROSOFT PRUDUCTS:
echo   Windows 7 (VL) - Windows 8 / 8.1 / 10
echo   Windows Server 2008 / 2012 / 2012 R2 / 2016 / 2019
echo   Office 2010 / 2013 / 2016 / 2019 (VL)
echo.
echo        NAME OS : %NameOS% %SP% %xOS% %vera%
reg.exe query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v DigitalProductId >nul 2>&1
echo        VERSION : %Version%
echo   ARCHITECTURE : %PROCESSOR_ARCHITECTURE%
echo        PC NAME : %computername%
echo ================================================================================
echo.
Echo.        [1] ACTIVATION (Inject Method) START FOR WINDOWS 10 ^& OFFICE
Echo.
Echo.        [2] ACTIVATION TASK SCHEDULER FOR WINDOWS 10 ^& OFFICE
Echo.
Echo.        [3] DELETE ACTIVATION TASK SCHEDULER
Echo.
Echo.        [4] $OEM$ ACTIVATION FOLDER EXTRACT TO DESKTOP
Echo.
Echo.        [5] WINDOWS ^& OFFICE ACTIVATION STATUS CHECK
Echo.
Echo.        [6] KMS ^& DIGITAL ^& ONLINE ACTIVATION VISIT WEBSITE (TNCTR)
Echo.
Echo.        [7] EXIT 
Echo.
Echo.        [8] RETURN KMS SUITE MENU
echo.
echo ================================================================================
choice /C:12345678 /N /M "YOUR CHOICE : "
if errorlevel 8 goto :KMSSuite
if errorlevel 7 goto :Exit
if errorlevel 6 goto :TNCTR
if errorlevel 5 goto :Check
if errorlevel 4 goto :OEM
if errorlevel 3 goto :TaskDelete
if errorlevel 2 goto :Task
::===============================================================================================================
:Activate
set Debug=0
set "SysPath=%Windir%\System32"
if exist "%Windir%\Sysnative\reg.exe" (set "SysPath=%Windir%\Sysnative")
set "Path=%SysPath%;%Windir%;%SysPath%\Wbem;%SysPath%\WindowsPowerShell\v1.0\"
set "tempdir=%SystemRoot%\Temp"
set "logpath=%~dpn0"
set "workdir=%~dp0"
if "%workdir:~-1%"=="\" set "workdir=%workdir:~0,-1%"
setlocal EnableExtensions EnableDelayedExpansion

if %Debug% EQU 0 (
  set "_Nul_1=1>nul"
  set "_Nul_2=2>nul"
  set "_Nul_2e=2^>nul"
  set "_Nul_1_2=1>nul 2>nul"
  set "Pause=pause >nul"
  call :Activation
) else (
  set "_Nul_1="
  set "_Nul_2="
  set "_Nul_2e="
  set "_Nul_1_2="
  set "Pause="
  echo.
  echo Running in Debug Mode...
  echo The window will be closed when finished
  copy /y nul "!workdir!\#.rw" 1>nul 2>nul && (if exist "!workdir!\#.rw" del /f /q "!workdir!\#.rw") || (set "logpath=!tempdir!\%~n0")
  @echo on
  @prompt $G
  @call :Activation >"!logpath!.tmp" 2>&1 &cmd /u /c type "!logpath!.tmp">"!logpath!Debug.log"&del "!logpath!.tmp"
)
exit /b
::===============================================================================================================
:Activation
set KMS38=1
set KMS_Emulation=1
set KMS_IP=172.16.0.2
set KMS_Port=1688
set KMS_ActivationInterval=43200
set KMS_RenewalInterval=43200
set KMS_HWID=0x3A1C049600B60076
title KMS (Inject) Aktivasyon Windows ^& Office %ver% by mephistooo2 - TNCTR.com
set xOS=x64
if /i "%PROCESSOR_ARCHITECTURE%"=="x86" (if "%PROCESSOR_ARCHITEW6432%"=="" set xOS=x86)
set "IFEO=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"
set "OSPP=HKLM\SOFTWARE\Microsoft\OfficeSoftwareProtectionPlatform"
set "SPPk=SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform"
wmic path SoftwareLicensingProduct where (Description like '%%KMSCLIENT%%') get Name %_Nul_2% | findstr /i Windows %_Nul_1% && (set SppHook=1) || (set SppHook=0)
wmic path OfficeSoftwareProtectionService get Version %_Nul_1_2% && (set OsppHook=1) || (set OsppHook=0)

for /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G
if %winbuild% GEQ 9200 (
    set OSType=Win8
) else if %winbuild% GEQ 7600 (
    set OSType=Win7
) else (
    goto :UnsupportedVersion
)
if %winbuild% GEQ 9600 (
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v NoGenTicket /t REG_DWORD /d 1 /f %_Nul_1_2%
)
SET Win10Gov=0
if %winbuild% LSS 14393 goto :Start

SET "RegKey=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages"
SET "Pattern=Microsoft-Windows-*Edition~31bf3856ad364e35"
SET "EditionPKG=NUL"
FOR /F "TOKENS=8 DELIMS=\" %%A IN ('REG QUERY "%RegKey%" /f "%Pattern%" /k %_Nul_2e% ^| FIND /I "CurrentVersion"') DO (
  REG QUERY "%RegKey%\%%A" /v "CurrentState" %_Nul_2% | FIND /I "0x70" %_Nul_1% && (
    FOR /F "TOKENS=3 DELIMS=-~" %%B IN ('ECHO %%A') DO SET "EditionPKG=%%B"
  )
)
IF /I "%EditionPKG:~-7%"=="Edition" (
SET "EditionID=%EditionPKG:~0,-7%"
) ELSE (
FOR /F "TOKENS=3 DELIMS=: " %%A IN ('DISM /English /Online /Get-CurrentEdition %_Nul_2e% ^| FIND /I "Current Edition :"') DO SET "EditionID=%%A"
)
FOR /F "TOKENS=2 DELIMS==" %%A IN ('"WMIC PATH SoftwareLicensingProduct WHERE (Name LIKE 'Windows%%' AND PartialProductKey is not NULL) GET LicenseFamily /VALUE" 2^>nul') DO IF NOT ERRORLEVEL 1 SET "EditionWMI=%%A"
IF NOT DEFINED EditionWMI (
IF %winbuild% GEQ 17063 FOR /F "SKIP=2 TOKENS=3 DELIMS= " %%A IN ('REG QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionId') DO SET "EditionID=%%A"
GOTO :Start
)
FOR %%A IN (Cloud,CloudN) DO (IF /I "%EditionWMI%"=="%%A" GOTO :Start)
SET EditionID=%EditionWMI%
FOR %%A IN (EnterpriseG,EnterpriseGN) DO (IF /I "%EditionID%"=="%%A" SET Win10Gov=1)
::===============================================================================================================
:Start
mode con cols=74 lines=26
echo.
echo Activation process is performed, please wait...
call :StopService sppsvc
if %OsppHook% NEQ 0 call :StopService osppsvc

for %%# in (SppExtComObjHookAvrf.dll,SppExtComObjHook.dll,SppExtComObjPatcher.dll,SppExtComObjPatcher.exe,KMS.dll) do (
	if exist "%SystemRoot%\system32\%%#" del /f /q "%SystemRoot%\system32\%%#" %_Nul_1_2%
)
set AclReset=0
mklink "%SystemRoot%\system32\KMS.dll" "!workdir!\!xOS!\KMS.dll" %_Nul_1_2%
icacls "%SystemRoot%\system32\KMS.dll" /findsid *S-1-5-32-545 %_Nul_2% | find /i "KMS.dll" %_Nul_1% || (
set AclReset=1
icacls "%SystemRoot%\system32\KMS.dll" /grant *S-1-5-32-545:RX %_Nul_1_2%
)

if %OSType% EQU Win8 call :CreateIFEOEntry SppExtComObj.exe
if %OSType% EQU Win7 if %SppHook% NEQ 0 call :CreateIFEOEntry sppsvc.exe
if %OsppHook% NEQ 0 call :CreateIFEOEntry osppsvc.exe

reg query HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration /v ProductReleaseIds %_Nul_1_2% && set "_C2R=HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration"
if not defined _C2R reg query HKLM\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun\Configuration /v ProductReleaseIds %_Nul_1_2% && set "_C2R=HKLM\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun\Configuration"
for %%A in (14,15,16,19) do call :officeLoc %%A
call :SPP
call :OSPP
if exist "!tempdir!\*chk.txt" del /f /q "!tempdir!\*chk.txt"
if exist "!tempdir!\slmgr.vbs" del /f /q "!tempdir!\slmgr.vbs"

call :StopService sppsvc
if %OsppHook% NEQ 0 call :StopService osppsvc

if %AclReset%==1 (
icacls "%SystemRoot%\system32\KMS.dll" /reset %_Nul_1_2%
)
if exist "%SystemRoot%\system32\KMS.dll" del /f /q "%SystemRoot%\system32\KMS.dll" %_Nul_1_2%

if %OSType% EQU Win8 call :RemoveIFEOEntry SppExtComObj.exe
if %OSType% EQU Win7 if %SppHook% NEQ 0 call :RemoveIFEOEntry sppsvc.exe
if %OsppHook% NEQ 0 call :RemoveIFEOEntry osppsvc.exe

sc start sppsvc trigger=timer;sessionid=0 %_Nul_1_2%
echo.
echo.
If %Auto% EQU 1 (
TIMEOUT /T 2 
exit
)
echo.
echo Press any key to exit...
%Pause%
CLS
mode con cols=80 lines=49
goto:MAINMENU
if %Debug% EQU 0 pause >nul
exit
::===============================================================================================================
:StopService
sc query %1 | find /i "STOPPED" %_Nul_1% || net stop %1 /y %_Nul_1_2%
sc query %1 | find /i "STOPPED" %_Nul_1% || sc stop %1 %_Nul_1_2%
goto :eof
::===============================================================================================================
:CreateIFEOEntry
reg delete "%IFEO%\%1" /f /v Debugger %_Nul_1_2%
reg add "%IFEO%\%1" /f /v VerifierDlls /t REG_SZ /d "KMS.dll" %_Nul_1_2%
reg add "%IFEO%\%1" /f /v GlobalFlag /t REG_DWORD /d 256 %_Nul_1_2%
reg add "%IFEO%\%1" /f /v KMS_Emulation /t REG_DWORD /d %KMS_Emulation% %_Nul_1_2%
reg add "%IFEO%\%1" /f /v KMS_ActivationInterval /t REG_DWORD /d %KMS_ActivationInterval% %_Nul_1_2%
reg add "%IFEO%\%1" /f /v KMS_RenewalInterval /t REG_DWORD /d %KMS_RenewalInterval% %_Nul_1_2%
if /i %1 EQU SppExtComObj.exe if %winbuild% GEQ 9600 (
reg add "%IFEO%\%1" /f /v KMS_HWID /t REG_QWORD /d "%KMS_HWID%" %_Nul_1_2%
)
goto :eof
::===============================================================================================================
:RemoveIFEOEntry
if /i %1 NEQ osppsvc.exe (
reg delete "%IFEO%\%1" /f %_Nul_1_2%
goto :eof
)
if %OsppHook% EQU 0 if /i %1 EQU osppsvc.exe (
reg delete "%IFEO%\%1" /f >nul 2>&1
goto :EOF
)
for %%A in (VerifierDlls,GlobalFlag,Debugger,KMS_Emulation,KMS_ActivationInterval,KMS_RenewalInterval,Office2010,Office2013,Office2016,Office2019) do reg delete "%IFEO%\%1" /v %%A /f %_Nul_1_2%
reg delete "%OSPP%" /v KeyManagementServiceName /f %_Nul_1_2%
reg delete "%OSPP%" /v KeyManagementServicePort /f %_Nul_1_2%
goto :eof
::===============================================================================================================
:SPP
set spp=SoftwareLicensingProduct
set sps=SoftwareLicensingService
set W1nd0ws=1
wmic path %spp% where (Description like '%%KMSCLIENT%%') get Name %_Nul_2% | findstr /i Office %_Nul_1% && (set 0ff1ce15=1)
set "aword=No Supported KMS Client"
if %loc_off15% equ 0 if %loc_off16% equ 0 if %loc_off19% equ 0 (set "0ff1ce15="&set "aword=No Installed")
if not defined 0ff1ce15 if %winbuild% GEQ 9200 (echo. )
wmic path %spp% where (Description like '%%KMSCLIENT%%') get Name %_Nul_2% | findstr /i Windows %_Nul_1% && (set WinVL=1) || (echo.&echo No Supported KMS Client Windows Detected...)
if not defined 0ff1ce15 if not defined WinVL exit /b
reg delete "HKLM\%SPPk%\55c92734-d682-4d71-983e-d6ec3f16059f" /f %_Nul_1_2%
reg delete "HKLM\%SPPk%\0ff1ce15-a989-479d-af46-f275c6370663" /f %_Nul_1_2%
wmic path %spp% where (Description like '%%KMSCLIENT%%' and PartialProductKey is not NULL) get Name %_Nul_2% | findstr /i Windows %_Nul_1% && (set gvlk=1) || (set gvlk=0)
set gpr=0
if %winbuild% geq 10240 if %KMS38% equ 1 if %gvlk% equ 1 for /f "tokens=2 delims==" %%A in ('"wmic path %spp% where (Description like '%%KMSCLIENT%%' and Name like 'Windows%%' and PartialProductKey is not NULL) get GracePeriodRemaining /VALUE" %_Nul_2e%') do set "gpr=%%A"
if %gpr% neq 0 if %gpr% gtr 259200 (
set W1nd0ws=0
wmic path %spp% where "Description like '%%KMSCLIENT%%' and Name like 'Windows%%' and PartialProductKey is not NULL" get LicenseFamily %_Nul_2% | findstr /i EnterpriseG %_Nul_1% && (set W1nd0ws=1)
)
for /f "tokens=2 delims==" %%A in ('"wmic path %sps% get Version /VALUE"') do set ver=%%A
wmic path %sps% where version='%ver%' call SetKeyManagementServiceMachine MachineName="%KMS_IP%" %_Nul_1_2%
wmic path %sps% where version='%ver%' call SetKeyManagementServicePort %KMS_Port% %_Nul_1_2%
for /f "tokens=2 delims==" %%G in ('"wmic path %spp% where (Description like '%%KMSCLIENT%%' and Name like 'Windows%%') get ID /VALUE"') do (set app=%%G&call :sppchkwin)
if defined 0ff1ce15 for /f "tokens=2 delims==" %%G in ('"wmic path %spp% where (Description like '%%KMSCLIENT%%' and Name like 'Office%%') get ID /VALUE"') do (set app=%%G&call :sppchkoff)
call :cKMS
exit /b
::===============================================================================================================
:sppchkoff
wmic path %spp% where ID='%app%' get Name > "!tempdir!\sppchk.txt"
find /i "Office 15" "!tempdir!\sppchk.txt" %_Nul_1% && (if %loc_off15% equ 0 exit /b)
find /i "Office 16" "!tempdir!\sppchk.txt" %_Nul_1% && (if %loc_off16% equ 0 exit /b)
find /i "Office 19" "!tempdir!\sppchk.txt" %_Nul_1% && (if %loc_off19% equ 0 exit /b)
set office=1
wmic path %spp% where (PartialProductKey is not NULL) get ID %_Nul_2% | findstr /i "%app%" %_Nul_1% && (echo.&call :activate %app%&exit /b)
for /f "tokens=3 delims==, " %%G in ('"wmic path %spp% where ID='%app%' get Name /value"') do set OffVer=%%G
call :offchk%OffVer%
exit /b
::===============================================================================================================
:sppchkwin
set office=0
if %winbuild% GEQ 14393 if %gvlk% equ 0 wmic path %spp% where (Description like '%%KMSCLIENT%%' and PartialProductKey is not NULL) get Name %_Nul_2% | findstr /i Windows %_Nul_1% && (set gvlk=1)
wmic path %spp% where ID='%app%' get LicenseStatus %_Nul_2% | findstr "1" %_Nul_1% && (echo.&call :activate %app%&exit /b)
wmic path %spp% where (PartialProductKey is not NULL) get ID %_Nul_2% | findstr /i "%app%" %_Nul_1% && (echo.&call :activate %app%&exit /b)
if %gvlk% equ 1 exit /b
if defined WinPerm exit /b
if %winbuild% LSS 10240 (call :winchk&exit /b)
for %%A in (
b71515d9-89a2-4c60-88c8-656fbcca7f3a,af43f7f0-3b1e-4266-a123-1fdb53f4323b,075aca1f-05d7-42e5-a3ce-e349e7be7078
11a37f09-fb7f-4002-bd84-f3ae71d11e90,43f2ab05-7c87-4d56-b27c-44d0f9a3dabd,2cf5af84-abab-4ff0-83f8-f040fb2576eb
6ae51eeb-c268-4a21-9aae-df74c38b586d,ff808201-fec6-4fd4-ae16-abbddade5706,34260150-69ac-49a3-8a0d-4a403ab55763
4dfd543d-caa6-4f69-a95f-5ddfe2b89567,5fe40dd6-cf1f-4cf2-8729-92121ac2e997,903663f7-d2ab-49c9-8942-14aa9e0a9c72
2cc171ef-db48-4adc-af09-7c574b37f139,5b2add49-b8f4-42e0-a77c-adad4efeeeb1
) do (
if /i '%app%' equ '%%A' exit /b
)
if not defined EditionID (call :winchk&exit /b)
if /i '%app%' equ '0df4f814-3f57-4b8b-9a9d-fddadcd69fac' if /i %EditionID% neq CloudE exit /b
if /i '%app%' equ 'e0c42288-980c-4788-a014-c080d2e1926e' if /i %EditionID% neq Education exit /b
if /i '%app%' equ '73111121-5638-40f6-bc11-f1d7b0d64300' if /i %EditionID% neq Enterprise exit /b
if /i '%app%' equ '2de67392-b7a7-462a-b1ca-108dd189f588' if /i %EditionID% neq Professional exit /b
if /i '%app%' equ '3f1afc82-f8ac-4f6c-8005-1d233e606eee' if /i %EditionID% neq ProfessionalEducation exit /b
if /i '%app%' equ '82bbc092-bc50-4e16-8e18-b74fc486aec3' if /i %EditionID% neq ProfessionalWorkstation exit /b
if /i '%app%' equ '3c102355-d027-42c6-ad23-2e7ef8a02585' if /i %EditionID% neq EducationN exit /b
if /i '%app%' equ 'e272e3e2-732f-4c65-a8f0-484747d0d947' if /i %EditionID% neq EnterpriseN exit /b
if /i '%app%' equ 'a80b5abf-76ad-428b-b05d-a47d2dffeebf' if /i %EditionID% neq ProfessionalN exit /b
if /i '%app%' equ '5300b18c-2e33-4dc2-8291-47ffcec746dd' if /i %EditionID% neq ProfessionalEducationN exit /b
if /i '%app%' equ '4b1571d3-bafb-4b40-8087-a961be2caf65' if /i %EditionID% neq ProfessionalWorkstationN exit /b
if /i '%app%' equ '58e97c99-f377-4ef1-81d5-4ad5522b5fd8' if /i %EditionID% neq Core exit /b
if /i '%app%' equ 'cd918a57-a41b-4c82-8dce-1a538e221a83' if /i %EditionID% neq CoreSingleLanguage exit /b
if /i '%app%' equ 'ec868e65-fadf-4759-b23e-93fe37f2cc29' if /i %EditionID% neq ServerRdsh exit /b
if /i '%app%' equ 'e4db50ea-bda1-4566-b047-0ca50abc6f07' if /i %EditionID% neq ServerRdsh exit /b
if /i '%app%' equ 'e4db50ea-bda1-4566-b047-0ca50abc6f07' (
wmic path %spp% where 'Description like "%%KMSCLIENT%%"' get ID | findstr /i "ec868e65-fadf-4759-b23e-93fe37f2cc29" %_Nul_1_2% && (exit /b)
)
call :winchk
exit /b
::===============================================================================================================
:winchk
if not defined tok (if %winbuild% GEQ 9200 (set "tok=4") else (set "tok=7"))
if not defined wApp set wApp=55c92734-d682-4d71-983e-d6ec3f16059f
wmic path %spp% where (LicenseStatus='1' and Description like '%%KMSCLIENT%%') get Name %_Nul_2% | findstr /i "Windows" %_Nul_1_2% && (exit /b)
echo.
wmic path %spp% where (LicenseStatus='1' and GracePeriodRemaining='0' and PartialProductKey is not NULL) get Name %_Nul_2% | findstr /i "Windows" %_Nul_1_2% && (
set WinPerm=1
)
if not defined WinPerm (
wmic path %spp% where "ApplicationID='%wApp%' and LicenseStatus='1'" get Name %_Nul_2% | findstr /i "Windows" %_Nul_1_2% && (
for /f "tokens=%tok% delims=, " %%G in ('"wmic path %spp% where (ApplicationID='%wApp%' and LicenseStatus='1') get Description /VALUE"') do set "channel=%%G"
  for %%A in (VOLUME_MAK, RETAIL, OEM_DM, OEM_SLP, OEM_COA, OEM_COA_SLP, OEM_COA_NSLP, OEM_NONSLP, OEM) do if /i "%%A"=="!channel!" set WinPerm=1
  )
)
if not defined WinPerm (
copy /y %Windir%\System32\slmgr.vbs "!tempdir!\slmgr.vbs" %_Nul_1_2%
cscript //nologo "!tempdir!\slmgr.vbs" /xpr %_Nul_2% | findstr /i "permanently" %_Nul_1_2% && set WinPerm=1
)
if defined WinPerm (
for /f "tokens=2 delims==" %%x in ('"wmic path %spp% where (ApplicationID='%wApp%' and LicenseStatus='1') get Name /VALUE"') do echo.
echo.
echo "%NameOS% %SP%%xOS%" preactivated.
echo.
exit /b
)
call :insKey %app%
exit /b
::===============================================================================================================
:OSPP
set spp=OfficeSoftwareProtectionProduct
set sps=OfficeSoftwareProtectionService
if %winbuild% LSS 9200 (set "aword=2010/2013/2016/2019") else (set "aword=2010")
wmic path %sps% get Version /VALUE %_Nul_1_2% || (echo. &exit /b)
wmic path %spp% where (Description like '%%KMSCLIENT%%') get Name /VALUE %_Nul_1_2% || (echo. &exit /b)
reg delete "%OSPP%\59a52881-a989-479d-af46-f275c6370663" /f %_Nul_1_2%
reg delete "%OSPP%\0ff1ce15-a989-479d-af46-f275c6370663" /f %_Nul_1_2%
for /f "tokens=2 delims==" %%A in ('"wmic path %sps% get Version /VALUE" %_Nul_2e%') do set ver=%%A
wmic path %sps% where version='%ver%' call SetKeyManagementServiceMachine MachineName="%KMS_IP%" %_Nul_1_2%
wmic path %sps% where version='%ver%' call SetKeyManagementServicePort %KMS_Port% %_Nul_1_2%
for /f "tokens=2 delims==" %%G in ('"wmic path %spp% where (Description like '%%KMSCLIENT%%') get ID /VALUE"') do (set app=%%G&call :osppchk)
call :cKMS
exit /b
::===============================================================================================================
:osppchk
wmic path %spp% where ID='%app%' get Name > "!tempdir!\osppchk.txt"
find /i "Office 14" "!tempdir!\osppchk.txt" %_Nul_1% && (if %loc_off14% equ 0 exit /b)
find /i "Office 15" "!tempdir!\osppchk.txt" %_Nul_1% && (if %loc_off15% equ 0 exit /b)
find /i "Office 16" "!tempdir!\osppchk.txt" %_Nul_1% && (if %loc_off16% equ 0 exit /b)
find /i "Office 19" "!tempdir!\osppchk.txt" %_Nul_1% && (if %loc_off19% equ 0 exit /b)
set office=0
wmic path %spp% where (PartialProductKey is not NULL) get ID | findstr /i "%app%" %_Nul_1_2% && (echo.&call :activate %app%&exit /b)
for /f "tokens=3 delims==, " %%G in ('"wmic path %spp% where ID='%app%' get Name /value"') do set OffVer=%%G
call :offchk%OffVer%
exit /b
::===============================================================================================================
:offchk
set ls=0
set ls2=0
for /f "tokens=2 delims==" %%A in ('"wmic path %spp% where (Name like '%%Office%~2%%') get LicenseStatus /VALUE" %_Nul_2e%') do set /a ls=%%A
if "%~4" neq "" (
for /f "tokens=2 delims==" %%A in ('"wmic path %spp% where (Name like '%%Office%~4%%') get LicenseStatus /VALUE" %_Nul_2e%') do set /a ls2=%%A
)
if "%ls2%" equ "1" (
echo.
echo %5 preactivated.
echo.
exit /b
)
if "%ls%" equ "1" (
echo.
echo %3 preactivated.
echo.
exit /b
)
call :insKey %app%
exit /b
::===============================================================================================================
:offchk19
if /i '%app%' equ '0bc88885-718c-491d-921f-6f214349e79c' exit /b
if /i '%app%' equ 'fc7c4d0c-2e85-4bb9-afd4-01ed1476b5e9' exit /b
if /i '%app%' equ '500f6619-ef93-4b75-bcb4-82819998a3ca' exit /b
if /i '%app%' equ '85dd8b5f-eaa4-4af3-a628-cce9e77c9a03' (
wmic path %spp% where 'PartialProductKey is not NULL' get ID | findstr /i "0bc88885-718c-491d-921f-6f214349e79c" %_Nul_1_2% && (exit /b)
)
if /i '%app%' equ '2ca2bf3f-949e-446a-82c7-e25a15ec78c4' (
wmic path %spp% where 'PartialProductKey is not NULL' get ID | findstr /i "fc7c4d0c-2e85-4bb9-afd4-01ed1476b5e9" %_Nul_1_2% && (exit /b)
)
if /i '%app%' equ '5b5cf08f-b81a-431d-b080-3450d8620565' (
wmic path %spp% where 'PartialProductKey is not NULL' get ID | findstr /i "500f6619-ef93-4b75-bcb4-82819998a3ca" %_Nul_1_2% && (exit /b)
)
if /i '%app%' equ '85dd8b5f-eaa4-4af3-a628-cce9e77c9a03' (
call :offchk "%app%" "19ProPlus2019VL_MAK_AE" "Office ProPlus 2019" "19ProPlus2019XC2RVL_MAKC2R" "Office ProPlus 2019 C2R"
exit /b
)
if /i '%app%' equ '6912a74b-a5fb-401a-bfdb-2e3ab46f4b02' (
call :offchk "%app%" "19Standard2019VL_MAK_AE" "Office Standard 2019"
exit /b
)
if /i '%app%' equ '2ca2bf3f-949e-446a-82c7-e25a15ec78c4' (
call :offchk "%app%" "19ProjectPro2019VL_MAK_AE" "Project Pro 2019" "19ProjectPro2019XC2RVL_MAKC2R" "Project Pro 2019 C2R"
exit /b
)
if /i '%app%' equ '1777f0e3-7392-4198-97ea-8ae4de6f6381' (
call :offchk "%app%" "19ProjectStd2019VL_MAK_AE" "Project Standard 2019"
exit /b
)
if /i '%app%' equ '5b5cf08f-b81a-431d-b080-3450d8620565' (
call :offchk "%app%" "19VisioPro2019VL_MAK_AE" "Visio Pro 2019" "19VisioPro2019XC2RVL_MAKC2R" "Visio Pro 2019 C2R"
exit /b
)
if /i '%app%' equ 'e06d7df3-aad0-419d-8dfb-0ac37e2bdf39' (
call :offchk "%app%" "19VisioStd2019VL_MAK_AE" "Visio Standard 2019"
exit /b
)
call :insKey %app%
exit /b
::===============================================================================================================
:offchk16
if /i '%app%' equ 'd450596f-894d-49e0-966a-fd39ed4c4c64' (
call :offchk "%app%" "16ProPlusVL_MAK" "Office ProPlus 2016"
exit /b
)
if /i '%app%' equ 'dedfa23d-6ed1-45a6-85dc-63cae0546de6' (
call :offchk "%app%" "16StandardVL_MAK" "Office Standard 2016"
exit /b
)
if /i '%app%' equ '4f414197-0fc2-4c01-b68a-86cbb9ac254c' (
call :offchk "%app%" "16ProjectProVL_MAK" "Project Pro 2016"
exit /b
)
if /i '%app%' equ 'da7ddabc-3fbe-4447-9e01-6ab7440b4cd4' (
call :offchk "%app%" "16ProjectStdVL_MAK" "Project Standard 2016"
exit /b
)
if /i '%app%' equ '6bf301c1-b94a-43e9-ba31-d494598c47fb' (
call :offchk "%app%" "16VisioProVL_MAK" "Visio Pro 2016"
exit /b
)
if /i '%app%' equ 'aa2a7821-1827-4c2c-8f1d-4513a34dda97' (
call :offchk "%app%" "16VisioStdVL_MAK" "Visio Standard 2016"
exit /b
)
if /i '%app%' equ '829b8110-0e6f-4349-bca4-42803577788d' (
call :offchk "%app%" "16ProjectProXC2RVL_MAKC2R" "Project Pro 2016 C2R"
exit /b
)
if /i '%app%' equ 'cbbaca45-556a-4416-ad03-bda598eaa7c8' (
call :offchk "%app%" "16ProjectStdXC2RVL_MAKC2R" "Project Standard 2016 C2R"
exit /b
)
if /i '%app%' equ 'b234abe3-0857-4f9c-b05a-4dc314f85557' (
call :offchk "%app%" "16VisioProXC2RVL_MAKC2R" "Visio Pro 2016 C2R"
exit /b
)
if /i '%app%' equ '361fe620-64f4-41b5-ba77-84f8e079b1f7' (
call :offchk "%app%" "16VisioStdXC2RVL_MAKC2R" "Visio Standard 2016 C2R"
exit /b
)
call :insKey %app%
exit /b
::===============================================================================================================
:offchk15
if /i '%app%' equ 'b322da9c-a2e2-4058-9e4e-f59a6970bd69' (
call :offchk "%app%" "ProPlusVL_MAK" "Office ProPlus 2013"
exit /b
)
if /i '%app%' equ 'b13afb38-cd79-4ae5-9f7f-eed058d750ca' (
call :offchk "%app%" "StandardVL_MAK" "Office Standard 2013"
exit /b
)
if /i '%app%' equ '4a5d124a-e620-44ba-b6ff-658961b33b9a' (
call :offchk "%app%" "ProjectProVL_MAK" "Project Pro 2013"
exit /b
)
if /i '%app%' equ '427a28d1-d17c-4abf-b717-32c780ba6f07' (
call :offchk "%app%" "ProjectStdVL_MAK" "Project Standard 2013"
exit /b
)
if /i '%app%' equ 'e13ac10e-75d0-4aff-a0cd-764982cf541c' (
call :offchk "%app%" "VisioProVL_MAK" "Visio Pro 2013"
exit /b
)
if /i '%app%' equ 'ac4efaf0-f81f-4f61-bdf7-ea32b02ab117' (
call :offchk "%app%" "VisioStdVL_MAK" "Visio Standard 2013"
exit /b
)
call :insKey %app%
exit /b
::===============================================================================================================
:offchk14
set "vPrem="&set "vPro="
for /f "tokens=2 delims==" %%A in ('"wmic path %spp% where (Name like '%%OfficeVisioPrem-MAK%%') get LicenseStatus /VALUE" %_Nul_2e%') do set vPrem=%%A
for /f "tokens=2 delims==" %%A in ('"wmic path %spp% where (Name like '%%OfficeVisioPro-MAK%%') get LicenseStatus /VALUE" %_Nul_2e%') do set vPro=%%A
if /i '%app%' equ '6f327760-8c5c-417c-9b61-836a98287e0c' (
call :offchk "%app%" "ProPlus-MAK" "Office ProPlus 2010" "ProPlusAcad-MAK" "Office Professional Academic 2010"
exit /b
)
if /i '%app%' equ '9da2a678-fb6b-4e67-ab84-60dd6a9c819a' (
call :offchk "%app%" "Standard-MAK" "Office Standard 2010"
exit /b
)
if /i '%app%' equ 'ea509e87-07a1-4a45-9edc-eba5a39f36af' (
call :offchk "%app%" "SmallBusBasics-MAK" "Office Home and Business 2010"
exit /b
)
if /i '%app%' equ 'df133ff7-bf14-4f95-afe3-7b48e7e331ef' (
call :offchk "%app%" "ProjectPro-MAK" "Project Pro 2010"
exit /b
)
if /i '%app%' equ '5dc7bf61-5ec9-4996-9ccb-df806a2d0efe' (
call :offchk "%app%" "ProjectStd-MAK" "Project Standard 2010"
exit /b
)
if /i '%app%' equ '92236105-bb67-494f-94c7-7f7a607929bd' (
call :offchk "%app%" "VisioPrem-MAK" "Visio Premium 2010" "VisioPro-MAK" "Visio Pro 2010"
exit /b
)
if defined vPrem exit /b
if /i '%app%' equ 'e558389c-83c3-4b29-adfe-5e4d7f46c358' (
call :offchk "%app%" "VisioPro-MAK" "Visio Pro 2010" "VisioStd-MAK" "Visio Standard 2010"
exit /b
)
if defined vPro exit /b
if /i '%app%' equ '9ed833ff-4f92-4f36-b370-8683a4f13275' (
call :offchk "%app%" "VisioStd-MAK" "Visio Standard 2010"
exit /b
)
call :insKey %app%
exit /b
::===============================================================================================================
:officeLoc
set loc_off%1=0
if %1 equ 19 (
if defined _C2R reg query %_C2R% /v ProductReleaseIds %_Nul_2% | findstr 2019 %_Nul_1% && set loc_off%1=1
exit /b
)

for /f "tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\Microsoft\Office\%1.0\Common\InstallRoot /v Path" %_Nul_2e%') do if exist "%%b\OSPP.VBS" set loc_off%1=1
for /f "tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\Wow6432Node\Microsoft\Office\%1.0\Common\InstallRoot /v Path" %_Nul_2e%') do if exist "%%b\OSPP.VBS" set loc_off%1=1

if %1 equ 16 if defined _C2R (
for /f "skip=2 tokens=2*" %%a in ('reg query %_C2R% /v ProductReleaseIds') do echo %%b> "!tempdir!\c2rchk.txt"
for %%a in (Mondo,ProPlus,Standard,ProjectProX,ProjectStdX,ProjectPro,ProjectStd,VisioProX,VisioStdX,VisioPro,VisioStd,Access,Excel,OneNote,Outlook,PowerPoint,Publisher,SkypeforBusiness,Word) do (
  findstr /I /C:"%%aVolume" "!tempdir!\c2rchk.txt" %_Nul_1% && set loc_off%1=1
  findstr /I /C:"%%aRetail" "!tempdir!\c2rchk.txt" %_Nul_1% && set loc_off%1=1
  )
exit /b
)

if exist "%ProgramFiles%\Microsoft Office\Office%1\OSPP.VBS" set loc_off%1=1
if exist "%ProgramFiles(x86)%\Microsoft Office\Office%1\OSPP.VBS" set loc_off%1=1
exit /b
::===============================================================================================================
:cKMS
wmic path %sps% where version='%ver%' call ClearKeyManagementServiceMachine %_Nul_1_2%
wmic path %sps% where version='%ver%' call ClearKeyManagementServicePort %_Nul_1_2%
wmic path %sps% where version='%ver%' call DisableKeyManagementServiceDnsPublishing 1 %_Nul_1_2%
wmic path %sps% where version='%ver%' call DisableKeyManagementServiceHostCaching 1 %_Nul_1_2%
if /i %sps% EQU SoftwareLicensingService (
reg delete "HKLM\%SPPk%\55c92734-d682-4d71-983e-d6ec3f16059f" /f %_Nul_1_2%
reg delete "HKLM\%SPPk%\0ff1ce15-a989-479d-af46-f275c6370663" /f %_Nul_1_2%
reg delete "HKEY_USERS\S-1-5-20\%SPPk%\55c92734-d682-4d71-983e-d6ec3f16059f" /f %_Nul_1_2%
reg delete "HKEY_USERS\S-1-5-20\%SPPk%\0ff1ce15-a989-479d-af46-f275c6370663" /f %_Nul_1_2%
) else (
reg delete "%OSPP%\59a52881-a989-479d-af46-f275c6370663" /f %_Nul_1_2%
reg delete "%OSPP%\0ff1ce15-a989-479d-af46-f275c6370663" /f %_Nul_1_2%
)
goto :eof
::===============================================================================================================
:insKey
echo.
set "key="
for /f "tokens=2 delims==" %%A in ('"wmic path %spp% where ID='%1' get Name /VALUE"') do echo Installing key for %%A
call :keys %1
if "%key%" EQU "" (echo Could not find matching KMS Client key&exit /b)
wmic path %sps% where version='%ver%' call InstallProductKey ProductKey="%key%" %_Nul_1_2%
set ERRORCODE=%ERRORLEVEL%
if %ERRORCODE% neq 0 (
cmd /c exit /b %ERRORCODE%
echo Failed: 0x!=ExitCode!
exit /b
)
::===============================================================================================================
:activate
wmic path %spp% where ID='%1' call ClearKeyManagementServiceMachine %_Nul_1_2%
wmic path %spp% where ID='%1' call ClearKeyManagementServicePort %_Nul_1_2%
if %W1nd0ws% equ 0 if %office% equ 0 if %sps% equ SoftwareLicensingService (
wmic path %spp% where ID='%1' call SetKeyManagementServiceMachine MachineName="127.0.0.2" %_Nul_1_2%
wmic path %spp% where ID='%1' call SetKeyManagementServicePort %KMS_Port% %_Nul_1_2%
for /f "tokens=2 delims==" %%x in ('"wmic path %spp% where ID='%1' get Name /VALUE"') do echo.
echo %NameOS% %SP%%xOS% is KMS 2038 Activated.
exit /b
)
for /f "tokens=2 delims==" %%x in ('"wmic path %spp% where ID='%1' get Name /VALUE"') do echo Activating: %%x
wmic path %spp% where ID='%1' call Activate %_Nul_1_2%
set ERRORCODE=%ERRORLEVEL%
if /i %sps% equ SoftwareLicensingService wmic path %sps% where version='%ver%' call RefreshLicenseStatus %_Nul_1_2%
for /f "tokens=2 delims==" %%x in ('"wmic path %spp% where ID='%1' get GracePeriodRemaining /VALUE"') do (set gpr=%%x&set /a gpr2=%%x/1440)
if %gpr% equ 43200 if %office% equ 0 if %winbuild% geq 9200 (echo Windows Core/ProfessionalWMC Activation Successful&echo Remaining Period: 30 days ^(%gpr% minutes^)&exit /b)
if %gpr% equ 64800 (echo Windows Core/ProfessionalWMC Activation Successful&echo Remaining Period: 45 days ^(%gpr% minutes^)&exit /b)
if %gpr% gtr 259200 if %Win10Gov% equ 1 (echo Windows 10 %EditionID% Activation Successful&echo Remaining Period: %gpr2% days ^(%gpr% minutes^)&exit /b)
if %gpr% equ 259200 (
echo Product Activation Successful
) else (
cmd /c exit /b %ERRORCODE%
echo Product Activation Failed: 0x!=ExitCode!
)
echo Remaining Period: %gpr2% days ^(%gpr% minutes^)
exit /b
::===============================================================================================================
:Task
if exist "%SystemRoot%\KMS\KMSClient.exe" goto :WinDivert
cd /d "%~dp0"
IF /I "%PROCESSOR_ARCHITECTURE%" EQU "AMD64" (set xOS=x64) else (set xOS=x86)
echo.
if not exist "%windir%\KMS\KMSInject.cmd" (
echo.
xcopy /cryi %xOS%\* %windir%\KMS\%xOS% >nul 2>&1
copy /y KMSInject.cmd %windir%\KMS\ >nul 2>&1
schtasks /create /tn "KMS_Activation" /xml "%~dp0x86\KMS.xml" /f >nul 2>&1
)
del /f /q %windir%\KMS\%xOS%\*.xml >nul 2>&1
echo.
echo Created KMS task scheduler.
echo.
echo Press any key to continue...
pause >nul
CLS
GOTO MAINMENU
::===============================================================================================================
:TaskDelete
echo.
del /f /q "%windir%\KMS\%xOS%\*.*" >nul 2>&1
rmdir %windir%\KMS /s /q >nul 2>&1
schtasks /delete /tn "KMS_Activation" /f >nul 2>&1
cscript //nologo %systemroot%\System32\slmgr.vbs /ckms 
echo Deleted KMS task scheduler...
echo.
echo Press any key to continue...
pause >nul
CLS
GOTO MAINMENU
::===============================================================================================================
:OEM
cd /d "%userprofile%\desktop\"
IF EXIST $OEM$ (
echo.
echo ===============================================
echo $OEM$ folder already exists on Desktop.
echo ===============================================
echo. 
echo Press any key to continue...
pause >nul
CLS
GOTO MAINMENU
) ELSE (
md %userprofile%\desktop\$OEM$
cd /d "%~dp0"
md %userprofile%\desktop\$OEM$\$$\Setup\Scripts\x64\
md %userprofile%\desktop\$OEM$\$$\Setup\Scripts\x86\
xcopy $OEM$\* %userprofile%\desktop\$OEM$ /s /i /y >nul 2>&1
xcopy /cryi x64\* %userprofile%\desktop\$OEM$\$$\Setup\Scripts\x64\ >nul 2>&1 
xcopy /cryi x86\* %userprofile%\desktop\$OEM$\$$\Setup\Scripts\x86\ >nul 2>&1 
echo MSGBOX "$OEM$ FOLDER EXTRACT TO DESKTOP." > %temp%\TEMPmessage.vbS
call %temp%\TEMPmessage.vbs )
del %temp%\TEMPmessage.vbs /f /q
CLS
GOTO MAINMENU
::===============================================================================================================
:Check
@echo off
set verb=0
set spp=SoftwareLicensingProduct
for /f "tokens=2 delims==" %%G in ('"wmic path %spp% where (ProductKeyID like '%%-%%' AND Description like '%%Windows%%') get ID /value"') do (set winapp=%%G&call :winchk)
echo.
exit

:winchk
echo.
echo ********************************************************************************
echo ***                     Windows Activation Status                            ***
echo ********************************************************************************
wscript //nologo "%systemroot%\System32\slmgr.vbs" /dli %winapp% | wscript //nologo "%systemroot%\System32\slmgr.vbs" /xpr %winapp%
echo.

set verb=0
set spp=SoftwareLicensingProduct
for /f "tokens=2 delims==" %%G in ('"wmic path %spp% where (ProductKeyID like '%%-%%' AND Description like '%%Office%%') get ID /value"') do (set officeapp=%%G&call :officechk)
echo.
CLS
GOTO MAINMENU

:officechk
wmic path %spp% where ID='%officeapp%' get Name /value | findstr /i "Windows" 1>nul && (exit /b)
if %verb%==0 (
set verb=1
echo ********************************************************************************
echo ***                     Office Activation Status                             ***
echo ********************************************************************************
)
wscript //nologo "%systemroot%\System32\slmgr.vbs" /dli %officeapp% | wscript //nologo "%systemroot%\System32\slmgr.vbs" /xpr %officeapp%
echo.
exit /b
::===============================================================================================================
:TNCTR
echo.
start https://www.tnctr.com/topic/450916-kms2038-dijital-online-aktivasyon-suite-v64/
CLS
GOTO MAINMENU
::===============================================================================================================
:Exit
echo.
echo MSGBOX "SPECIAL THANKS : TNCTR Family - CODYQX4, abbodi1406, qewlpal, s1ave77, cynecx, qad, Mouri_Naruto (MDL)", vbInformation,"..:: mephistooo2 | TNCTR ::.."  > %temp%\TEMPmessage.vbs
call %temp%\TEMPmessage.vbs
del %temp%\TEMPmessage.vbs /f /q
ENDLOCAL
exit
::===============================================================================================================
:WinDivert
echo.
echo ==== ERROR ====
echo WinDivert Method is installed on the system.
echo Please uninstall WinDivert Method for use KMSInject Method 
echo.
echo Press any key to continue...
pause >nul
CLS
GOTO MAINMENU
::===============================================================================================================
:KMSSuite
cd..
cd..
call KMS_Suite.cmd
::===============================================================================================================
:UnsupportedVersion
echo ==== ERROR ====
echo Unsupported OS version Detected.
echo Project is supported only for Windows 7/8/8.1/10 and their Server equivalent.
echo ________________________________________________________________________________
timeout /t 3 >nul
%Pause%
goto :eof
::===============================================================================================================
:keys
if "%~1"=="" exit /b
goto :%1 2>nul || exit /b

:: Windows 10 [RS5]
:32d2fab3-e4a8-42c2-923b-4bf4fd13e6ee
set "key=M7XTQ-FN8P6-TTKYV-9D4CC-J462D" &:: Enterprise LTSC 2019
exit /b

:7103a333-b8c8-49cc-93ce-d37c09687f92
set "key=92NFX-8DJQP-P6BBQ-THF9C-7CG2H" &:: Enterprise LTSC 2019 N
exit /b

:ec868e65-fadf-4759-b23e-93fe37f2cc29
set "key=CPWHC-NT2C7-VYW78-DHDB2-PG3GK" &:: Enterprise for Virtual Desktops
exit /b

:0df4f814-3f57-4b8b-9a9d-fddadcd69fac
set "key=NBTWJ-3DR69-3C4V8-C26MC-GQ9M6" &:: Lean
exit /b

:: Windows 10 [RS3]
:82bbc092-bc50-4e16-8e18-b74fc486aec3
set "key=NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J" &:: Pro Workstation
exit /b

:4b1571d3-bafb-4b40-8087-a961be2caf65
set "key=9FNHH-K3HBT-3W4TD-6383H-6XYWF" &:: Pro Workstation N
exit /b

:e4db50ea-bda1-4566-b047-0ca50abc6f07
set "key=7NBT4-WGBQX-MP4H7-QXFF8-YP3KX" &:: Enterprise Remote Server
exit /b

:: Windows 10 [RS2]
:e0b2d383-d112-413f-8a80-97f373a5820c
set "key=YYVX9-NTFWV-6MDM3-9PT4T-4M68B" &:: Enterprise G
exit /b

:e38454fb-41a4-4f59-a5dc-25080e354730
set "key=44RPN-FTY23-9VTTB-MP9BX-T84FV" &:: Enterprise G N
exit /b

:: Windows 10 [RS1]
:2d5a5a60-3040-48bf-beb0-fcd770c20ce0
set "key=DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ" &:: Enterprise 2016 LTSB
exit /b

:9f776d83-7156-45b2-8a5c-359b9c9f22a3
set "key=QFFDN-GRT3P-VKWWX-X7T3R-8B639" &:: Enterprise 2016 LTSB N
exit /b

:3f1afc82-f8ac-4f6c-8005-1d233e606eee
set "key=6TP4R-GNPTD-KYYHQ-7B7DP-J447Y" &:: Pro Education
exit /b

:5300b18c-2e33-4dc2-8291-47ffcec746dd
set "key=YVWGF-BXNMC-HTQYQ-CPQ99-66QFC" &:: Pro Education N
exit /b

:: Windows 10 [TH]
:58e97c99-f377-4ef1-81d5-4ad5522b5fd8
set "key=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99" &:: Home
exit /b

:7b9e1751-a8da-4f75-9560-5fadfe3d8e38
set "key=3KHY7-WNT83-DGQKR-F7HPR-844BM" &:: Home N
exit /b

:cd918a57-a41b-4c82-8dce-1a538e221a83
set "key=7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH" &:: Home Single Language
exit /b

:a9107544-f4a0-4053-a96a-1479abdef912
set "key=PVMJN-6DFY6-9CCP6-7BKTT-D3WVR" &:: Home China
exit /b

:2de67392-b7a7-462a-b1ca-108dd189f588
set "key=W269N-WFGWX-YVC9B-4J6C9-T83GX" &:: Pro
exit /b

:a80b5abf-76ad-428b-b05d-a47d2dffeebf
set "key=MH37W-N47XK-V7XM9-C7227-GCQG9" &:: Pro N
exit /b

:e0c42288-980c-4788-a014-c080d2e1926e
set "key=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2" &:: Education
exit /b

:3c102355-d027-42c6-ad23-2e7ef8a02585
set "key=2WH4N-8QGBV-H22JP-CT43Q-MDWWJ" &:: Education N
exit /b

:73111121-5638-40f6-bc11-f1d7b0d64300
set "key=NPPR9-FWDCX-D2C8J-H872K-2YT43" &:: Enterprise
exit /b

:e272e3e2-732f-4c65-a8f0-484747d0d947
set "key=DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4" &:: Enterprise N
exit /b

:7b51a46c-0c04-4e8f-9af4-8496cca90d5e
set "key=WNMTR-4C88C-JK8YV-HQ7T2-76DF9" &:: Enterprise 2015 LTSB
exit /b

:87b838b7-41b6-4590-8318-5797951d8529
set "key=2F77B-TNFGY-69QQF-B8YKP-D69TJ" &:: Enterprise 2015 LTSB N
exit /b

:: Windows Server 2019 [RS5]
:de32eafd-aaee-4662-9444-c1befb41bde2
set "key=N69G4-B89J2-4G8F4-WWYCC-J464C" &:: Standard
exit /b

:34e1ae55-27f8-4950-8877-7a03be5fb181
set "key=WMDGN-G9PQG-XVVXX-R3X43-63DFG" &:: Datacenter
exit /b

:034d3cbb-5d4b-4245-b3f8-f84571314078
set "key=WVDHN-86M7X-466P6-VHXV7-YY726" &:: Essentials
exit /b

:a99cc1f0-7719-4306-9645-294102fbff95
set "key=FDNH6-VW9RW-BXPJ7-4XTYG-239TB" &:: Azure Core
exit /b

:73e3957c-fc0c-400d-9184-5f7b6f2eb409
set "key=N2KJX-J94YW-TQVFB-DG9YT-724CC" &:: Standard ACor
exit /b

:90c362e5-0da1-4bfd-b53b-b87d309ade43
set "key=6NMRW-2C8FM-D24W7-TQWMY-CWH2D" &:: Datacenter ACor
exit /b

:8de8eb62-bbe0-40ac-ac17-f75595071ea3
set "key=GRFBW-QNDC4-6QBHG-CCK3B-2PR88" &:: ServerARM64
exit /b

:: Windows Server 2016 [RS4]
:43d9af6e-5e86-4be8-a797-d072a046896c
set "key=K9FYF-G6NCK-73M32-XMVPY-F9DRR" &:: ServerARM64
exit /b

:: Windows Server 2016 [RS3]
:61c5ef22-f14f-4553-a824-c4b31e84b100
set "key=PTXN8-JFHJM-4WC78-MPCBR-9W4KR" &:: Standard ACor
exit /b

:e49c08e7-da82-42f8-bde2-b570fbcae76c
set "key=2HXDN-KRXHB-GPYC7-YCKFJ-7FVDG" &:: Datacenter ACor
exit /b

:: Windows Server 2016 [RS1]
:8c1c5410-9f39-4805-8c9d-63a07706358f
set "key=WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY" &:: Standard
exit /b

:21c56779-b449-4d20-adfc-eece0e1ad74b
set "key=CB7KF-BWN84-R7R2Y-793K2-8XDDG" &:: Datacenter
exit /b

:2b5a1b0f-a5ab-4c54-ac2f-a6d94824a283
set "key=JCKRF-N37P4-C2D82-9YXRT-4M63B" &:: Essentials
exit /b

:7b4433f4-b1e7-4788-895a-c45378d38253
set "key=QN4C6-GBJD2-FB422-GHWJK-GJG2R" &:: Cloud Storage
exit /b

:3dbf341b-5f6c-4fa7-b936-699dce9e263f
set "key=VP34G-4NPPG-79JTQ-864T4-R3MQX" &:: Azure Core
exit /b

:: Windows 8.1
:fe1c3238-432a-43a1-8e25-97e7d1ef10f3
set "key=M9Q9P-WNJJT-6PXPY-DWX8H-6XWKK" &:: Core
exit /b

:78558a64-dc19-43fe-a0d0-8075b2a370a3
set "key=7B9N3-D94CG-YTVHR-QBPX3-RJP64" &:: Core N
exit /b

:c72c6a1d-f252-4e7e-bdd1-3fca342acb35
set "key=BB6NG-PQ82V-VRDPW-8XVD2-V8P66" &:: Core Single Language
exit /b

:db78b74f-ef1c-4892-abfe-1e66b8231df6
set "key=NCTT7-2RGK8-WMHRF-RY7YQ-JTXG3" &:: Core China
exit /b

:ffee456a-cd87-4390-8e07-16146c672fd0
set "key=XYTND-K6QKT-K2MRH-66RTM-43JKP" &:: Core ARM
exit /b

:c06b6981-d7fd-4a35-b7b4-054742b7af67
set "key=GCRJD-8NW9H-F2CDX-CCM8D-9D6T9" &:: Pro
exit /b

:7476d79f-8e48-49b4-ab63-4d0b813a16e4
set "key=HMCNV-VVBFX-7HMBH-CTY9B-B4FXY" &:: Pro N
exit /b

:096ce63d-4fac-48a9-82a9-61ae9e800e5f
set "key=789NJ-TQK6T-6XTH8-J39CJ-J8D3P" &:: Pro with Media Center
exit /b

:81671aaf-79d1-4eb1-b004-8cbbe173afea
set "key=MHF9N-XY6XB-WVXMC-BTDCT-MKKG7" &:: Enterprise
exit /b

:113e705c-fa49-48a4-beea-7dd879b46b14
set "key=TT4HM-HN7YT-62K67-RGRQJ-JFFXW" &:: Enterprise N
exit /b

:0ab82d54-47f4-4acb-818c-cc5bf0ecb649
set "key=NMMPB-38DD4-R2823-62W8D-VXKJB" &:: Embedded Industry Pro
exit /b

:cd4e2d9f-5059-4a50-a92d-05d5bb1267c7
set "key=FNFKF-PWTVT-9RC8H-32HB2-JB34X" &:: Embedded Industry Enterprise
exit /b

:f7e88590-dfc7-4c78-bccb-6f3865b99d1a
set "key=VHXM3-NR6FT-RY6RT-CK882-KW2CJ" &:: Embedded Industry Automotive
exit /b

:e9942b32-2e55-4197-b0bd-5ff58cba8860
set "key=3PY8R-QHNP9-W7XQD-G6DPH-3J2C9" &:: with Bing
exit /b

:c6ddecd6-2354-4c19-909b-306a3058484e
set "key=Q6HTR-N24GM-PMJFP-69CD8-2GXKR" &:: with Bing N
exit /b

:b8f5e3a3-ed33-4608-81e1-37d6c9dcfd9c
set "key=KF37N-VDV38-GRRTV-XH8X6-6F3BB" &:: with Bing Single Language
exit /b

:ba998212-460a-44db-bfb5-71bf09d1c68b
set "key=R962J-37N87-9VVK2-WJ74P-XTMHR" &:: with Bing China
exit /b

:e58d87b5-8126-4580-80fb-861b22f79296
set "key=MX3RK-9HNGX-K3QKC-6PJ3F-W8D7B" &:: Pro for Students
exit /b

:cab491c7-a918-4f60-b502-dab75e334f40
set "key=TNFGH-2R6PB-8XM3K-QYHX2-J4296" &:: Pro for Students N
exit /b

:: Windows Server 2012 R2
:b3ca044e-a358-4d68-9883-aaa2941aca99
set "key=D2N9P-3P6X9-2R39C-7RTCD-MDVJX" &:: Standard
exit /b

:00091344-1ea4-4f37-b789-01750ba6988c
set "key=W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9" &:: Datacenter
exit /b

:21db6ba4-9a7b-4a14-9e29-64a60c59301d
set "key=KNC87-3J2TX-XB4WP-VCPJV-M4FWM" &:: Essentials
exit /b

:b743a2be-68d4-4dd3-af32-92425b7bb623
set "key=3NPTF-33KPT-GGBPR-YX76B-39KDD" &:: Cloud Storage
exit /b

:: Windows 8
:c04ed6bf-55c8-4b47-9f8e-5a1f31ceee60
set "key=BN3D2-R7TKB-3YPBD-8DRP2-27GG4" &:: Core
exit /b

:197390a0-65f6-4a95-bdc4-55d58a3b0253
set "key=8N2M2-HWPGY-7PGT9-HGDD8-GVGGY" &:: Core N
exit /b

:8860fcd4-a77b-4a20-9045-a150ff11d609
set "key=2WN2H-YGCQR-KFX6K-CD6TF-84YXQ" &:: Core Single Language
exit /b

:9d5584a2-2d85-419a-982c-a00888bb9ddf
set "key=4K36P-JN4VD-GDC6V-KDT89-DYFKP" &:: Core China
exit /b

:af35d7b7-5035-4b63-8972-f0b747b9f4dc
set "key=DXHJF-N9KQX-MFPVR-GHGQK-Y7RKV" &:: Core ARM
exit /b

:a98bcd6d-5343-4603-8afe-5908e4611112
set "key=NG4HW-VH26C-733KW-K6F98-J8CK4" &:: Pro
exit /b

:ebf245c1-29a8-4daf-9cb1-38dfc608a8c8
set "key=XCVCF-2NXM9-723PB-MHCB7-2RYQQ" &:: Pro N
exit /b

:a00018a3-f20f-4632-bf7c-8daa5351c914
set "key=GNBB8-YVD74-QJHX6-27H4K-8QHDG" &:: Pro with Media Center
exit /b

:458e1bec-837a-45f6-b9d5-925ed5d299de
set "key=32JNW-9KQ84-P47T8-D8GGY-CWCK7" &:: Enterprise
exit /b

:e14997e7-800a-4cf7-ad10-de4b45b578db
set "key=JMNMF-RHW7P-DMY6X-RF3DR-X2BQT" &:: Enterprise N
exit /b

:10018baf-ce21-4060-80bd-47fe74ed4dab
set "key=RYXVT-BNQG7-VD29F-DBMRY-HT73M" &:: Embedded Industry Pro
exit /b

:18db1848-12e0-4167-b9d7-da7fcda507db
set "key=NKB3R-R2F8T-3XCDP-7Q2KW-XWYQ2" &:: Embedded Industry Enterprise
exit /b

:: Windows Server 2012
:f0f5ec41-0d55-4732-af02-440a44a3cf0f
set "key=XC9B7-NBPP2-83J2H-RHMBY-92BT4" &:: Standard
exit /b

:d3643d60-0c42-412d-a7d6-52e6635327f6
set "key=48HP8-DN98B-MYWDG-T2DCC-8W83P" &:: Datacenter
exit /b

:7d5486c7-e120-4771-b7f1-7b56c6d3170c
set "key=HM7DN-YVMH3-46JC3-XYTG7-CYQJJ" &:: MultiPoint Standard
exit /b

:95fd1c83-7df5-494a-be8b-1300e1c9d1cd
set "key=XNH6W-2V9GX-RGJ4K-Y8X6F-QGJ2G" &:: MultiPoint Premium
exit /b

:: Windows 7
:b92e9980-b9d5-4821-9c94-140f632f6312
set "key=FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4" &:: Professional
exit /b

:54a09a0d-d57b-4c10-8b69-a842d6590ad5
set "key=MRPKT-YTG23-K7D7T-X2JMM-QY7MG" &:: Professional N
exit /b

:5a041529-fef8-4d07-b06f-b59b573b32d2
set "key=W82YF-2Q76Y-63HXB-FGJG9-GF7QX" &:: Professional E
exit /b

:ae2ee509-1b34-41c0-acb7-6d4650168915
set "key=33PXH-7Y6KF-2VJC9-XBBR8-HVTHH" &:: Enterprise
exit /b

:1cb6d605-11b3-4e14-bb30-da91c8e3983a
set "key=YDRBP-3D83W-TY26F-D46B2-XCKRJ" &:: Enterprise N
exit /b

:46bbed08-9c7b-48fc-a614-95250573f4ea
set "key=C29WB-22CC8-VJ326-GHFJW-H9DH4" &:: Enterprise E
exit /b

:db537896-376f-48ae-a492-53d0547773d0
set "key=YBYF6-BHCR3-JPKRB-CDW7B-F9BK4" &:: Embedded POSReady 7
exit /b

:e1a8296a-db37-44d1-8cce-7bc961d59c54
set "key=XGY72-BRBBT-FF8MH-2GG8H-W7KCW" &:: Embedded Standard
exit /b

:aa6dd3aa-c2b4-40e2-a544-a6bbb3f5c395
set "key=73KQT-CD9G6-K7TQG-66MRP-CQ22C" &:: Embedded ThinPC
exit /b

:: Windows Server 2008 R2
:a78b8bd9-8017-4df5-b86a-09f756affa7c
set "key=6TPJF-RBVHG-WBW2R-86QPH-6RTM4" &:: Web
exit /b

:cda18cf3-c196-46ad-b289-60c072869994
set "key=TT8MH-CG224-D3D7Q-498W2-9QCTX" &:: HPC
exit /b

:68531fb9-5511-4989-97be-d11a0f55633f
set "key=YC6KT-GKW9T-YTKYR-T4X34-R7VHC" &:: Standard
exit /b

:7482e61b-c589-4b7f-8ecc-46d455ac3b87
set "key=74YFP-3QFB3-KQT8W-PMXWJ-7M648" &:: Datacenter
exit /b

:620e2b3d-09e7-42fd-802a-17a13652fe7a
set "key=489J6-VHDMP-X63PK-3K798-CPX3Y" &:: Enterprise
exit /b

:8a26851c-1c7e-48d3-a687-fbca9b9ac16b
set "key=GT63C-RJFQ3-4GMB6-BRFB9-CB83V" &:: Itanium
exit /b

:f772515c-0e87-48d5-a676-e6962c3e1195
set "key=736RG-XDKJK-V34PF-BHK87-J6X3K" &:: MultiPoint Server
exit /b

:: Office 2019
:0bc88885-718c-491d-921f-6f214349e79c
set "key=VQ9DP-NVHPH-T9HJC-J9PDT-KTQRG" &:: Professional Plus C2R-P
exit /b

:fc7c4d0c-2e85-4bb9-afd4-01ed1476b5e9
set "key=XM2V9-DN9HH-QB449-XDGKC-W2RMW" &:: Project Professional C2R-P
exit /b

:500f6619-ef93-4b75-bcb4-82819998a3ca
set "key=N2CG9-YD3YK-936X4-3WR82-Q3X4H" &:: Visio Professional C2R-P
exit /b

:85dd8b5f-eaa4-4af3-a628-cce9e77c9a03
set "key=NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP" &:: Professional Plus
exit /b

:6912a74b-a5fb-401a-bfdb-2e3ab46f4b02
set "key=6NWWJ-YQWMR-QKGCB-6TMB3-9D9HK" &:: Standard
exit /b

:2ca2bf3f-949e-446a-82c7-e25a15ec78c4
set "key=B4NPR-3FKK7-T2MBV-FRQ4W-PKD2B" &:: Project Professional
exit /b

:1777f0e3-7392-4198-97ea-8ae4de6f6381
set "key=C4F7P-NCP8C-6CQPT-MQHV9-JXD2M" &:: Project Standard
exit /b

:5b5cf08f-b81a-431d-b080-3450d8620565
set "key=9BGNQ-K37YR-RQHF2-38RQ3-7VCBB" &:: Visio Professional
exit /b

:e06d7df3-aad0-419d-8dfb-0ac37e2bdf39
set "key=7TQNQ-K3YQQ-3PFH7-CCPPM-X4VQ2" &:: Visio Standard
exit /b

:9e9bceeb-e736-4f26-88de-763f87dcc485
set "key=9N9PT-27V4Y-VJ2PD-YXFMF-YTFQT" &:: Access
exit /b

:237854e9-79fc-4497-a0c1-a70969691c6b
set "key=TMJWT-YYNMB-3BKTF-644FC-RVXBD" &:: Excel
exit /b

:c8f8a301-19f5-4132-96ce-2de9d4adbd33
set "key=7HD7K-N4PVK-BHBCQ-YWQRW-XW4VK" &:: Outlook
exit /b

:3131fd61-5e4f-4308-8d6d-62be1987c92c
set "key=RRNCX-C64HY-W2MM7-MCH9G-TJHMQ" &:: PowerPoint
exit /b

:9d3e4cca-e172-46f1-a2f4-1d2107051444
set "key=G2KWX-3NW6P-PY93R-JXK2T-C9Y9V" &:: Publisher
exit /b

:734c6c6e-b0ba-4298-a891-671772b2bd1b
set "key=NCJ33-JHBBY-HTK98-MYCV8-HMKHJ" &:: Skype for Business
exit /b

:059834fe-a8ea-4bff-b67b-4d006b5447d3
set "key=PBX3G-NWMT6-Q7XBW-PYJGG-WXD33" &:: Word
exit /b

:: Office 2016
:829b8110-0e6f-4349-bca4-42803577788d
set "key=WGT24-HCNMF-FQ7XH-6M8K7-DRTW9" &:: Project Professional C2R-P
exit /b

:cbbaca45-556a-4416-ad03-bda598eaa7c8
set "key=D8NRQ-JTYM3-7J2DX-646CT-6836M" &:: Project Standard C2R-P
exit /b

:b234abe3-0857-4f9c-b05a-4dc314f85557
set "key=69WXN-MBYV6-22PQG-3WGHK-RM6XC" &:: Visio Professional C2R-P
exit /b

:361fe620-64f4-41b5-ba77-84f8e079b1f7
set "key=NY48V-PPYYH-3F4PX-XJRKJ-W4423" &:: Visio Standard C2R-P
exit /b

:e914ea6e-a5fa-4439-a394-a9bb3293ca09
set "key=DMTCJ-KNRKX-26982-JYCKT-P7KB6" &:: MondoR
exit /b

:9caabccb-61b1-4b4b-8bec-d10a3c3ac2ce
set "key=HFTND-W9MK4-8B7MJ-B6C4G-XQBR2" &:: Mondo
exit /b

:d450596f-894d-49e0-966a-fd39ed4c4c64
set "key=XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99" &:: Professional Plus
exit /b

:dedfa23d-6ed1-45a6-85dc-63cae0546de6
set "key=JNRGM-WHDWX-FJJG3-K47QV-DRTFM" &:: Standard
exit /b

:4f414197-0fc2-4c01-b68a-86cbb9ac254c
set "key=YG9NW-3K39V-2T3HJ-93F3Q-G83KT" &:: Project Professional
exit /b

:da7ddabc-3fbe-4447-9e01-6ab7440b4cd4
set "key=GNFHQ-F6YQM-KQDGJ-327XX-KQBVC" &:: Project Standard
exit /b

:6bf301c1-b94a-43e9-ba31-d494598c47fb
set "key=PD3PC-RHNGV-FXJ29-8JK7D-RJRJK" &:: Visio Professional
exit /b

:aa2a7821-1827-4c2c-8f1d-4513a34dda97
set "key=7WHWN-4T7MP-G96JF-G33KR-W8GF4" &:: Visio Standard
exit /b

:67c0fc0c-deba-401b-bf8b-9c8ad8395804
set "key=GNH9Y-D2J4T-FJHGG-QRVH7-QPFDW" &:: Access
exit /b

:c3e65d36-141f-4d2f-a303-a842ee756a29
set "key=9C2PK-NWTVB-JMPW8-BFT28-7FTBF" &:: Excel
exit /b

:d8cace59-33d2-4ac7-9b1b-9b72339c51c8
set "key=DR92N-9HTF2-97XKM-XW2WJ-XW3J6" &:: OneNote
exit /b

:ec9d9265-9d1e-4ed0-838a-cdc20f2551a1
set "key=R69KK-NTPKF-7M3Q4-QYBHW-6MT9B" &:: Outlook
exit /b

:d70b1bba-b893-4544-96e2-b7a318091c33
set "key=J7MQP-HNJ4Y-WJ7YM-PFYGF-BY6C6" &:: Powerpoint
exit /b

:041a06cb-c5b8-4772-809f-416d03d16654
set "key=F47MM-N3XJP-TQXJ9-BP99D-8K837" &:: Publisher
exit /b

:83e04ee1-fa8d-436d-8994-d31a862cab77
set "key=869NQ-FJ69K-466HW-QYCP2-DDBV6" &:: Skype for Business
exit /b

:bb11badf-d8aa-470e-9311-20eaf80fe5cc
set "key=WXY84-JN2Q9-RBCCQ-3Q3J3-3PFJ6" &:: Word
exit /b

:: Office 2013
:dc981c6b-fc8e-420f-aa43-f8f33e5c0923
set "key=42QTK-RN8M7-J3C4G-BBGYM-88CYV" &:: Mondo
exit /b

:b322da9c-a2e2-4058-9e4e-f59a6970bd69
set "key=YC7DK-G2NP3-2QQC3-J6H88-GVGXT" &:: Professional Plus
exit /b

:b13afb38-cd79-4ae5-9f7f-eed058d750ca
set "key=KBKQT-2NMXY-JJWGP-M62JB-92CD4" &:: Standard
exit /b

:4a5d124a-e620-44ba-b6ff-658961b33b9a
set "key=FN8TT-7WMH6-2D4X9-M337T-2342K" &:: Project Professional
exit /b

:427a28d1-d17c-4abf-b717-32c780ba6f07
set "key=6NTH3-CW976-3G3Y2-JK3TX-8QHTT" &:: Project Standard
exit /b

:e13ac10e-75d0-4aff-a0cd-764982cf541c
set "key=C2FG9-N6J68-H8BTJ-BW3QX-RM3B3" &:: Visio Professional
exit /b

:ac4efaf0-f81f-4f61-bdf7-ea32b02ab117
set "key=J484Y-4NKBF-W2HMG-DBMJC-PGWR7" &:: Visio Standard
exit /b

:6ee7622c-18d8-4005-9fb7-92db644a279b
set "key=NG2JY-H4JBT-HQXYP-78QH9-4JM2D" &:: Access
exit /b

:f7461d52-7c2b-43b2-8744-ea958e0bd09a
set "key=VGPNG-Y7HQW-9RHP7-TKPV3-BG7GB" &:: Excel
exit /b

:fb4875ec-0c6b-450f-b82b-ab57d8d1677f
set "key=H7R7V-WPNXQ-WCYYC-76BGV-VT7GH" &:: Groove
exit /b

:a30b8040-d68a-423f-b0b5-9ce292ea5a8f
set "key=DKT8B-N7VXH-D963P-Q4PHY-F8894" &:: InfoPath
exit /b

:1b9f11e3-c85c-4e1b-bb29-879ad2c909e3
set "key=2MG3G-3BNTT-3MFW9-KDQW3-TCK7R" &:: Lync
exit /b

:efe1f3e6-aea2-4144-a208-32aa872b6545
set "key=TGN6P-8MMBC-37P2F-XHXXK-P34VW" &:: OneNote
exit /b

:771c3afa-50c5-443f-b151-ff2546d863a0
set "key=QPN8Q-BJBTJ-334K3-93TGY-2PMBT" &:: Outlook
exit /b

:8c762649-97d1-4953-ad27-b7e2c25b972e
set "key=4NT99-8RJFH-Q2VDH-KYG2C-4RD4F" &:: Powerpoint
exit /b

:00c79ff1-6850-443d-bf61-71cde0de305f
set "key=PN2WF-29XG2-T9HJ7-JQPJR-FCXK4" &:: Publisher
exit /b

:d9f5b1c6-5386-495a-88f9-9ad6b41ac9b3
set "key=6Q7VD-NX8JD-WJ2VH-88V73-4GBJ7" &:: Word
exit /b

:: Office 2010
:09ed9640-f020-400a-acd8-d7d867dfd9c2
set "key=YBJTT-JG6MD-V9Q7P-DBKXJ-38W9R" &:: Mondo
exit /b

:ef3d4e49-a53d-4d81-a2b1-2ca6c2556b2c
set "key=7TC2V-WXF6P-TD7RT-BQRXR-B8K32" &:: Mondo2
exit /b

:6f327760-8c5c-417c-9b61-836a98287e0c
set "key=VYBBJ-TRJPB-QFQRF-QFT4D-H3GVB" &:: Professional Plus
exit /b

:9da2a678-fb6b-4e67-ab84-60dd6a9c819a
set "key=V7QKV-4XVVR-XYV4D-F7DFM-8R6BM" &:: Standard
exit /b

:df133ff7-bf14-4f95-afe3-7b48e7e331ef
set "key=YGX6F-PGV49-PGW3J-9BTGG-VHKC6" &:: Project Professional
exit /b

:5dc7bf61-5ec9-4996-9ccb-df806a2d0efe
set "key=4HP3K-88W3F-W2K3D-6677X-F9PGB" &:: Project Standard
exit /b

:92236105-bb67-494f-94c7-7f7a607929bd
set "key=D9DWC-HPYVV-JGF4P-BTWQB-WX8BJ" &:: Visio Premium
exit /b

:e558389c-83c3-4b29-adfe-5e4d7f46c358
set "key=7MCW8-VRQVK-G677T-PDJCM-Q8TCP" &:: Visio Professional
exit /b

:9ed833ff-4f92-4f36-b370-8683a4f13275
set "key=767HD-QGMWX-8QTDB-9G3R2-KHFGJ" &:: Visio Standard
exit /b

:8ce7e872-188c-4b98-9d90-f8f90b7aad02
set "key=V7Y44-9T38C-R2VJK-666HK-T7DDX" &:: Access
exit /b

:cee5d470-6e3b-4fcc-8c2b-d17428568a9f
set "key=H62QG-HXVKF-PP4HP-66KMR-CW9BM" &:: Excel
exit /b

:8947d0b8-c33b-43e1-8c56-9b674c052832
set "key=QYYW6-QP4CB-MBV6G-HYMCJ-4T3J4" &:: Groove (SharePoint Workspace)
exit /b

:ca6b6639-4ad6-40ae-a575-14dee07f6430
set "key=K96W8-67RPQ-62T9Y-J8FQJ-BT37T" &:: InfoPath
exit /b

:ab586f5c-5256-4632-962f-fefd8b49e6f4
set "key=Q4Y4M-RHWJM-PY37F-MTKWH-D3XHX" &:: OneNote
exit /b

:ecb7c192-73ab-4ded-acf4-2399b095d0cc
set "key=7YDC2-CWM8M-RRTJC-8MDVC-X3DWQ" &:: Outlook
exit /b

:45593b1d-dfb1-4e91-bbfb-2d5d0ce2227a
set "key=RC8FX-88JRY-3PF7C-X8P67-P4VTT" &:: Powerpoint
exit /b

:b50c4f75-599b-43e8-8dcd-1081a7967241
set "key=BFK7F-9MYHM-V68C7-DRQ66-83YTP" &:: Publisher
exit /b

:2d0882e7-a4e7-423b-8ccc-70d91e0158b1
set "key=HVHB3-C6FV7-KQX9W-YQG79-CRY7T" &:: Word
exit /b

:ea509e87-07a1-4a45-9edc-eba5a39f36af
set "key=D6QFG-VBYP2-XQHM7-J97RH-VVRCK" &:: Home and Business
exit /b
::===============================================================================================================
:Exit
echo.
echo MSGBOX "SPECIAL THANKS : TNCTR Family - CODYQX4, abbodi1406, qewlpal, s1ave77, cynecx, qad, Mouri_Naruto (MDL)", vbInformation,"..:: mephistooo2 | TNCTR ::.."  > %temp%\TEMPmessage.vbs
call %temp%\TEMPmessage.vbs
del %temp%\TEMPmessage.vbs /f /q
exit