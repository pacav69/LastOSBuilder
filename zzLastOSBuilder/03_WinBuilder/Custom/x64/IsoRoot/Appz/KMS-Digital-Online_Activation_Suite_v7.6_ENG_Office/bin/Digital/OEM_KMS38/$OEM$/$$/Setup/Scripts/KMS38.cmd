@echo off
:Start
set ver=v7.6
title Digital ^& KMS 2038 Activation Windows 10 %ver% by mephistooo2 - TNCTR.com
mode con cols=70 lines=2
color 4e
set Auto=0
IF "%~1"=="-digi" set Auto=1
IF "%~1"=="-kms38" set Auto=1
IF "%~1"=="-digi" GOTO :Digital
IF "%~1"=="-kms38" GOTO :KMS38
:init
setlocal DisableDelayedExpansion
set cmdInvoke=1
set winSysFolder=System32
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
echo ADMIN RIGHTS ACTIVATE...
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
if '%cmdInvoke%'=='1' goto InvokeCmd 
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
goto ExecElevation

:InvokeCmd
ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
"%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)
::===============================================================================================================
setlocal enabledelayedexpansion
setlocal EnableExtensions
pushd "%~dp0"
mode con cols=80 lines=41
color 5f
cd /d "%~dp0"
if /i "%PROCESSOR_ARCHITECTURE%"=="x86" if not defined PROCESSOR_ARCHITEW6432 set xOS=x86
for /f "tokens=2 delims==" %%a IN ('"wmic Path Win32_OperatingSystem Get Caption /format:LIST"')do (set NameOS=%%a) >nul 2>&1
for /f "tokens=2 delims==" %%a IN ('"wmic Path Win32_OperatingSystem Get CSDVersion /format:LIST"')do (set SP=%%a) >nul 2>&1
for /f "tokens=2 delims==" %%a IN ('"wmic Path Win32_OperatingSystem Get Version /format:LIST"')do (set Version=%%a) >nul 2>&1
for /f "tokens=2* delims= " %%a in ('reg query "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v "PROCESSOR_ARCHITECTURE"') do if "%%b"=="AMD64" (set vera=x64) else (set vera=x86)
:MAINMENU
echo ================================================================================
set ver=v7.6
set yy=%date:~-4%
set mm=%date:~-7,2%
set dd=%date:~-10,2%
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a:%%b)
echo                                                             %dd%.%mm%.%yy% ^- %mytime%
echo.
echo   Digital ^& KMS 2038 Activation Windows 10 %ver% - mephistooo2 - www.TNCTR.com 
echo.
echo   SUPPORT MICROSOFT PRUDUCTS:
echo   Windows 10 (all versions)
echo.
echo          OS NAME : %NameOS% %SP% %xOS%
reg.exe query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v DigitalProductId >nul 2>&1
echo          VERSION : %Version%
echo    ARCHITECTURAL : %PROCESSOR_ARCHITECTURE%
echo          PC NAME : %computername%
echo ================================================================================
echo.
Echo.        [1] DIGITAL ACTIVATION START FOR WINDOWS 10 
Echo.
Echo.        [2] KMS38 ACTIVATION START FOR WINDOWS 10 
Echo.
Echo.        [3] DIGITAL or KMS38 $OEM$ ACTIVATION FOLDER EXTRACT TO DESKTOP
Echo.
Echo.        [4] WINDOWS ^& OFFICE ACTIVATION STATUS CHECK
Echo.
Echo.        [5] DIGITAL ACTIVATION VISIT WEBSITE (TNCTR)
Echo.
Echo.        [6] EXIT 
Echo.
Echo.        [7] RETURN KMS SUITE MENU
echo.
echo ================================================================================
choice /C:1234567 /N /M "YOUR CHOICE : "
if errorlevel 7 goto :KMSSuite
if errorlevel 6 goto :Exit 
if errorlevel 5 goto :TNCTR
if errorlevel 4 goto :Check
if errorlevel 3 goto :OEM
if errorlevel 2 goto :KMS38
if errorlevel 1 goto :Digital
::===============================================================================================================
:Digital
set "DIGI=1"
if exist "bin\editions" del /f /q "bin\editions" >nul 2>&1
goto HWIDActivate
:KMS38
set "KMS38=1"
if exist "bin\editions" del /f /q "bin\editions" >nul 2>&1
goto HWIDActivate
:HWIDActivate
mode con cols=78 lines=33
for /f "tokens=2 delims==" %%a in ('wmic path Win32_OperatingSystem get BuildNumber /value') do (
  set /a WinBuild=%%a
)

if %winbuild% LSS 10240 (
echo Not detected Windows 10. 
echo.
echo Digital License/KMS38 Activation is Not Supported.
del /f /q "bin\editions"
)

CALL :DetectEdition

If defined KMS38 (
set "A2=KMS38"
set "A3=GVLK"
set "A4=Volume:GVLK"
set "A5=digi-ltsbc-kms38.exe"
set "A6= >nul 2>&1"
)
If defined DIGI (
set "B2=Digital License"
set "B3=Retail-OEM_Key"
set "B4=Retail"
set "B5=digi-ltsbc-kms38.exe"
)
::===========================================================
call:%A3%%B3%

for /f "tokens=1-4 usebackq" %%a in ("bin\editions") do (if ^[%%a^]==^[%osedition%^] (
    set edition=%%a
    set sku=%%b 
    set Key=%%c
    goto:parseAndPatch))
echo:
echo %osedition% %vera% %A2%%B2% Activation is Not Supported.
echo:
Endlocal
del /f /q "bin\editions"
pause
CLS
mode con cols=80 lines=41
GOTO Start
::===========================================================
:parseAndPatch
echo.
echo ==============================================================================
echo                Windows 10 %osedition% %vera% %A2%%B2% Activation
echo ==============================================================================
echo.
echo Cleaning ClipsSVC tokens...
sc stop clipsvc >nul 2>&1
del /f /s /q "%allusersprofile%\Microsoft\Windows\ClipSVC\tokens.dat" >nul 2>&1
If defined KMS38 (
echo.
cscript /nologo %windir%\system32\slmgr.vbs -ckms >nul 2>&1
echo Rearming Windows Application ID...
cscript /nologo %windir%\system32\slmgr.vbs -rearm-app 55c92734-d682-4d71-983e-d6ec3f16059f >nul 2>&1

echo.
for /f "tokens=2 delims==" %%G in ('"wmic path SoftwareLicensingProduct where (ProductKeyID like '%%-%%' AND Description like '%%Windows%%') get ID /value"') do (set winapp=%%G) >nul 2>&1
echo Rearming Windows SKU ID...
cscript //nologo "%systemroot%\System32\slmgr.vbs" /rearm-sku %winapp% >nul 2>&1
)
echo.
echo Installing key %key%
cscript /nologo %windir%\system32\slmgr.vbs -ipk %key% >nul 2>&1
echo.

echo Create GenuineTicket.XML file for Windows 10 %edition% %vera%

for /f "tokens=2 delims==" %%a IN ('"wmic Path Win32_OperatingSystem Get OperatingSystemSKU /format:LIST"')do (set SKU=%%a)
if not exist sku.txt echo | set /p "dummyName=%SKU%">bin\sku.txt
echo. >> bin\sku.txt

If defined DIGI (
echo Retail >> bin\sku.txt
)
If defined KMS38 (
echo Volume:GVLK >> bin\sku.txt
)

cd bin\
start /wait digi-ltsbc-kms38.exe
timeout /t 3 >nul 2>&1
cd..

echo.
echo GenuineTicket.XML file is installing for Windows 10 %edition% %vera%
clipup -v -o -altto %~dp0bin\
echo.

del /f /q bin\sku.txt >nul 2>&1
del /f /q "bin\editions" >nul 2>&1

echo Activating...
echo.
cscript /nologo %windir%\system32\slmgr.vbs -ato >nul 2>&1
cscript /nologo %windir%\system32\slmgr.vbs -xpr
if "%Auto%"=="1" (
     GOTO :Out 
) ELSE (
     GOTO :Done 
)

for /f "tokens=2 delims==" %%A in ('"wmic path SoftwareLicensingProduct where (Description like '%%KMSCLIENT%%' and Name like 'Windows%%' and PartialProductKey is not NULL) get GracePeriodRemaining /VALUE" ') do set "gpr=%%A"
if %gpr% GTR 259200 echo Windows 10 %edition% %vera% is KMS38 activated. &goto:Done 

if "%Auto%"=="1" (
     GOTO :Out 
) ELSE (
     GOTO :Done 
)
echo.
if %gpr% LEQ 259200 Goto:Rearm
:Rearm
echo Windows 10 %edition% %vera% KMS38 is not activated.
echo.
echo Applying slmgr /rearm to fix activation...
cscript /nologo %windir%\system32\slmgr.vbs -rearm >nul 2>&1
echo.
echo Restarting the system...
shutdown.exe /r /soft
echo.
::===============================================================================================================
:Done
echo.
echo Press any key to continue...
pause >nul
CLS
mode con cols=80 lines=41
GOTO Start
::===============================================================================================================
:Out
TIMEOUT /T 2 
exit
::===============================================================================================================
:DetectEdition
FOR /F "TOKENS=2 DELIMS==" %%A IN ('"WMIC PATH SoftwareLicensingProduct WHERE (Name LIKE 'Windows%%' AND PartialProductKey is not NULL) GET LicenseFamily /VALUE"') DO IF NOT ERRORLEVEL 1 SET "osedition=%%A"
if not defined osedition (FOR /F "TOKENS=3 DELIMS=: " %%A IN ('DISM /English /Online /Get-CurrentEdition 2^>nul ^| FIND /I "Current Edition :"') DO SET "osedition=%%A")

if %winbuild% EQU 10240 (
if "%osedition%"=="EnterpriseS" set "osedition=EnterpriseS2015"
if "%osedition%"=="EnterpriseSN" set "osedition=EnterpriseSN2015"
)
if %winbuild% EQU 14393 (
if "%osedition%"=="EnterpriseS" set "osedition=EnterpriseS2016"
if "%osedition%"=="EnterpriseSN" set "osedition=EnterpriseSN2016"
)
if %winbuild% GEQ 17763 (
if "%osedition%"=="EnterpriseS" set "osedition=EnterpriseS2019"
if "%osedition%"=="EnterpriseSN" set "osedition=EnterpriseSN2019"
)
exit /b
::===============================================================================================================
:Retail-OEM_Key
rem              Edition          SKU            Retail/OEM_Key         
(                                                                       
echo Core                         101      YTMG3-N6DKC-DKB77-7M9GH-8HVX7
echo CoreN                         98      4CPRK-NM3K3-X6XXQ-RXX86-WXCHW
echo CoreCountrySpecific           99      N2434-X9D7W-8PF6X-8DV9T-8TYMD
echo CoreSingleLanguage           100      BT79Q-G7N6G-PGBYW-4YWX6-6F4BT
echo Education                    121      YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY
echo EducationN                   122      84NGF-MHBT6-FXBX8-QWJK7-DRR8H
echo Enterprise                     4      XGVPP-NMH47-7TTHJ-W3FW7-8HV2C
echo EnterpriseN                   27      3V6Q6-NQXCX-V8YXR-9QCYV-QPFCT
echo EnterpriseS2015              125      FWN7H-PF93Q-4GGP8-M8RF3-MDWWW
echo EnterpriseSN2015             126      8V8WN-3GXBH-2TCMG-XHRX3-9766K
echo EnterpriseS2016              125      NK96Y-D9CD8-W44CQ-R8YTK-DYJWX
echo EnterpriseSN2016             126      2DBW3-N2PJG-MVHW3-G7TDK-9HKR4
echo Professional                  48      VK7JG-NPHTM-C97JM-9MPGT-3V66T
echo ProfessionalN                 49      2B87N-8KFHP-DKV6R-Y2C8J-PKCKT
echo ProfessionalEducation        164      8PTT6-RNW4C-6V7J2-C2D3X-MHBPB
echo ProfessionalEducationN       165      GJTYN-HDMQY-FRR76-HVGC7-QPF8P
echo ProfessionalWorkstation      161      DXG7C-N36C4-C4HTG-X4T3X-2YV77
echo ProfessionalWorkstationN     162      WYPNQ-8C467-V2W6J-TX4WX-WT2RQ
echo ServerRdsh                   175      NJCF7-PW8QT-3324D-688JX-2YV66
echo IoTEnterprise                188      XQQYW-NFFMW-XJPBH-K8732-CKFFD
                                                                       
) > "bin\editions" &exit /b                                                                                 
::===============================================================================================================
:GVLK
rem              Edition          SKU                  GVLK             
(                                                                       
echo Core                         101      TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
echo CoreN                         98      3KHY7-WNT83-DGQKR-F7HPR-844BM
echo CoreCountrySpecific           99      PVMJN-6DFY6-9CCP6-7BKTT-D3WVR
echo CoreSingleLanguage           100      7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH
echo Education                    121      NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
echo EducationN                   122      2WH4N-8QGBV-H22JP-CT43Q-MDWWJ
echo Enterprise                     4      NPPR9-FWDCX-D2C8J-H872K-2YT43
echo EnterpriseN                   27      DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4
echo EnterpriseS2016              125      DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ
echo EnterpriseSN2016             126      QFFDN-GRT3P-VKWWX-X7T3R-8B639
echo EnterpriseS2019              125      M7XTQ-FN8P6-TTKYV-9D4CC-J462D
echo EnterpriseSN2019             126      92NFX-8DJQP-P6BBQ-THF9C-7CG2H
echo Professional                  48      W269N-WFGWX-YVC9B-4J6C9-T83GX
echo ProfessionalN                 49      MH37W-N47XK-V7XM9-C7227-GCQG9
echo ProfessionalEducation        164      6TP4R-GNPTD-KYYHQ-7B7DP-J447Y
echo ProfessionalEducationN       165      YVWGF-BXNMC-HTQYQ-CPQ99-66QFC
echo ProfessionalWorkstation      161      NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J
echo ProfessionalWorkstationN     162      9FNHH-K3HBT-3W4TD-6383H-6XYWF
echo ServerStandard                 7      N69G4-B89J2-4G8F4-WWYCC-J464C
echo ServerStandardCore            13      N69G4-B89J2-4G8F4-WWYCC-J464C
echo ServerDatacenter               8      WMDGN-G9PQG-XVVXX-R3X43-63DFG
echo ServerDatacenterCore          12      WMDGN-G9PQG-XVVXX-R3X43-63DFG
echo ServerSolution                52      WVDHN-86M7X-466P6-VHXV7-YY726
echo ServerSolutionCore            53      WVDHN-86M7X-466P6-VHXV7-YY726
echo ServerRdsh                   175      7NBT4-WGBQX-MP4H7-QXFF8-YP3KX

) > "bin\editions" &exit /b                                                                                 
::===============================================================================================================
:OEM
Echo.
Echo.   [1] DIGITAL $OEM$       [2] KMS38 $OEM$
Echo.
choice /C:12 /N /M "YOUR CHOICE : "
if errorlevel 2 goto :KMS38OEM 
if errorlevel 1 goto :DIGIOEM

:DIGIOEM
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
mode con cols=80 lines=41
GOTO Start
) ELSE (
md %userprofile%\desktop\$OEM$
cd /d "%~dp0"
md %userprofile%\desktop\$OEM$\$$\Setup\Scripts\bin\
xcopy OEM_Digital\* %userprofile%\desktop\ /s /i /y >nul 2>&1
xcopy /cryi bin\* %userprofile%\desktop\$OEM$\$$\Setup\Scripts\bin\) >nul 2>&1 
echo MSGBOX "DIGITAL ACTIVATION $OEM$ FOLDER EXTRACT TO DESKTOP." > %temp%\TEMPmessage.vbS
call %temp%\TEMPmessage.vbs
del %temp%\TEMPmessage.vbs /f /q
CLS
mode con cols=80 lines=41
GOTO Start
::===============================================================================================================
:KMS38OEM
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
mode con cols=80 lines=41
GOTO Start
) ELSE (
md %userprofile%\desktop\$OEM$
cd /d "%~dp0"
md %userprofile%\desktop\$OEM$\$$\Setup\Scripts\bin\
xcopy OEM_KMS38\* %userprofile%\desktop\ /s /i /y >nul 2>&1
xcopy /cryi bin\* %userprofile%\desktop\$OEM$\$$\Setup\Scripts\bin\) >nul 2>&1 
echo MSGBOX "KMS38 ACTIVATION $OEM$ FOLDER EXTRACT TO DESKTOP." > %temp%\TEMPmessage.vbS
call %temp%\TEMPmessage.vbs
del %temp%\TEMPmessage.vbs /f /q
CLS
mode con cols=80 lines=41
GOTO Start
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
GOTO Start

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
start https://www.tnctr.com/topic/450916-kms-dijital-online-aktivasyon-suite-v52/
CLS
GOTO Start
::===============================================================================================================
:Exit
echo.
echo MSGBOX "SPECIAL THANKS : TNCTR Family - CODYQX4, abbodi1406, qewlpal, s1ave77, cynecx, qad, Mouri_Naruto (MDL)", vbInformation,"..:: mephistooo2 | TNCTR ::.."  > %temp%\TEMPmessage.vbs
call %temp%\TEMPmessage.vbs
del %temp%\TEMPmessage.vbs /f /q
exit
::===============================================================================================================
:KMSSuite
cd..
cd..
call KMS_Suite.cmd
exit