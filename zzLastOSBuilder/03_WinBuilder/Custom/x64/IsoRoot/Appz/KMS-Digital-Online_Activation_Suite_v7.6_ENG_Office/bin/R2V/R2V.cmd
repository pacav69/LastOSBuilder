@echo off
CLS

:init
setlocal DisableDelayedExpansion
set cmdInvoke=1
set winSysFolder=System32
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
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

:Precheck
color 1F
title Office Click-to-Run Retail-to-Volume
for /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G
if /i "%PROCESSOR_ARCHITECTURE%" equ "AMD64" (set arch=x64) else (set arch=x86)
set "_SLMGR=%SystemRoot%\System32\slmgr.vbs"

if %winbuild% LSS 7601 (
set "msg=Windows 7 SP1 is the minimum supported OS..."
goto :end
)
sc query ClickToRunSvc >nul 2>&1
set error1=%errorlevel%
sc query OfficeSvc >nul 2>&1
set error2=%errorlevel%
if %error1% equ 1060 if %error2% equ 1060 (
set "msg=Could not detect Office ClickToRun service..."
goto :end
)

set _Office16=0
for /f "skip=2 tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\Microsoft\Office\ClickToRun /v InstallPath" 2^>nul') do if exist "%%b\Office16\OSPP.VBS" (
  set _Office16=1&set "_OSPP=%%b\Office16\OSPP.VBS"
)
if exist "%ProgramFiles%\Microsoft Office\Office16\OSPP.VBS" (
  set _Office16=1&set "_OSPP=%ProgramFiles%\Microsoft Office\Office16\OSPP.VBS"
) else if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\OSPP.VBS" (
  set _Office16=1&set "_OSPP=%ProgramFiles(x86)%\Microsoft Office\Office16\OSPP.VBS"
)
if %_Office16% equ 0 (
set "msg=No installed Office 2016/2019 product detected..."
goto :end
)

for /f "skip=2 tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\Microsoft\Office\ClickToRun /v InstallPath" 2^>nul') do if not errorlevel 1 (set "_InstallRoot=%%b\root")
if "%_InstallRoot%" neq "" (
  for /f "skip=2 tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\Microsoft\Office\ClickToRun /v PackageGUID" 2^>nul') do if not errorlevel 1 (set "_GUID=%%b")
  for /f "skip=2 tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration /v ProductReleaseIds" 2^>nul') do if not errorlevel 1 (set "ProductIds=%%b")
  set "_Config=HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration"
  set "_PRIDs=HKLM\SOFTWARE\Microsoft\Office\ClickToRun\ProductReleaseIDs"
) else (
  for /f "skip=2 tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun /v InstallPath" 2^>nul') do if not errorlevel 1 (set "_InstallRoot=%%b\root")
  for /f "skip=2 tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun /v PackageGUID" 2^>nul') do if not errorlevel 1 (set "_GUID=%%b")
  for /f "skip=2 tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun\Configuration /v ProductReleaseIds" 2^>nul') do if not errorlevel 1 (set "ProductIds=%%b")
  set "_Config=HKLM\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun\Configuration"
  set "_PRIDs=HKLM\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun\ProductReleaseIDs"
)
set "_LicensesPath=%_InstallRoot%\Licenses16"
set "_Integrator=%_InstallRoot%\integration\integrator.exe"
for /f "skip=2 tokens=2*" %%a in ('"reg query %_PRIDs% /v ActiveConfiguration" 2^>nul') do set "_PRIDs=%_PRIDs%\%%b"

if "%ProductIds%" equ "" (
set "msg=Could not detect Office ProductIDs..."
goto :end
)
if not exist "%_LicensesPath%\*.xrm-ms" (
set "msg=Could not detect Office Licenses files..."
goto :end
)
if not exist "%_Integrator%" (
set "msg=Could not detect Office Licenses Integrator..."
goto :end
)
if %winbuild% lss 9200 if not exist "%_OSPP%" (
set "msg=Could not detect Licensing tool OSPP.vbs..."
goto :end
)

:Check
echo.
echo ============================================================
echo Checking Office Licenses...
echo ============================================================
if %winbuild% geq 9200 (
set spp=SoftwareLicensingProduct
set sps=SoftwareLicensingService
) else (
set spp=OfficeSoftwareProtectionProduct
set sps=OfficeSoftwareProtectionService
)
for /f "tokens=2 delims==" %%a in ('"wmic path %sps% get version /value" 2^>nul') do set ver=%%a
set _Free=0
for %%a in (Professional2019,ProPlus2019,ProjectPro2019,VisioPro2019) do (
wmic path %spp% where LicenseFamily='Office19%%aR_PrepidBypass' get LicenseStatus 2>nul | findstr "1" >nul 2>&1 && (set _%%aR=1&set _Free=1) || (set _%%aR=0)
)
wmic path %spp% where (Description like '%%KMSCLIENT%%' AND not LicenseFamily='Office16MondoR_KMS_Automation') get LicenseFamily 2>nul | findstr /i /C:"Office" 1>nul && (set _KMS=1) || (set _KMS=0)
wmic path %spp% where (Description like '%%TIMEBASED%%') get LicenseFamily 2>nul | findstr /i /C:"Office" 1>nul && (set _Time=1) || (set _Time=0)
wmic path %spp% where (Description like '%%Grace%%') get LicenseFamily 2>nul | findstr /i /C:"Office" 1>nul && (set _Grace=1) || (set _Grace=0)
if %_Time% equ 0 if %_Grace% equ 0 if %_Free% equ 0 if %_KMS% equ 1 (
set "msg=No Conversion or Cleanup Required..."
goto :end
)
if %_Free% equ 1 if %_KMS% equ 0 (
set "msg=No Conversion or Cleanup Required..."
goto :end
)
setlocal EnableDelayedExpansion
for %%a in (Professional2019,ProPlus2019,ProjectPro2019,VisioPro2019) do if !_%%aR! equ 1 (
if "!_Preserve!" equ "" (set "_Preserve=%%aRetail") else (set "_Preserve=!_Preserve!,%%aRetail")
)
if %_KMS% equ 0 goto :Retail2Volume
for /f "tokens=2 delims==_" %%a in ('"wmic path %spp% where (Description like '%%KMSCLIENT%%' AND LicenseFamily like 'Office%%' AND LicenseStatus='1') get LicenseFamily /value"') do (call :Preserve %%a)
goto :Retail2Volume

:Preserve
if /i '%1' equ 'Office16MondoR' exit /b
set "_License=%1"
set "_License=!_License:~8!"
if /i "!_License:~-6!" equ "XC2RVL" (set "_License=!_License:~0,-6!") else (set "_License=!_License:~0,-2!")
if "!_Preserve!" equ "" (set "_Preserve=!_License!") else (set "_Preserve=!_Preserve!,!_License!")
exit /b

:Retail2Volume
echo.
echo ============================================================
echo Cleaning Current Office Licenses...
echo ============================================================
cd /d "%~dp0"
%arch%\cleanospp.exe -Licenses >nul 2>&1
echo.
echo ============================================================
echo Installing Office Volume Licenses...
echo ============================================================
echo.
set O19Ids=ProPlus2019,ProjectPro2019,VisioPro2019,Standard2019,ProjectStd2019,VisioStd2019
set SkuIds=O365ProPlus,Professional,ProjectPro,VisioPro,Standard,ProjectStd,VisioStd
set A19Ids=Excel2019,Outlook2019,PowerPoint2019,Publisher2019,Word2019
set AppIds=Excel,OneNote,Outlook,PowerPoint,Publisher,Word

for %%a in (Mondo,%O19Ids%,%A19Ids%,Access2019,SkypeforBusiness2019,Professional2019,%SkuIds%,%AppIds%,Access,SkypeforBusiness,ProPlus) do (
set _%%a=0
)
for %%a in (Mondo,%O19Ids%,%A19Ids%,Access2019,SkypeforBusiness2019,Professional2019,%SkuIds%,%AppIds%,Access,SkypeforBusiness) do (
echo %ProductIds%| findstr /I /C:"%%aRetail" 1>nul && set _%%a=1
)
for %%a in (Mondo,%O19Ids%,%A19Ids%,Access2019,SkypeforBusiness2019,%SkuIds%,%AppIds%,Access,SkypeforBusiness) do (
echo %ProductIds%| findstr /I /C:"%%aVolume" 1>nul && set _%%a=0
)
reg query %_PRIDs%\ProPlusRetail.16 1>nul 2>nul && set _ProPlus=1
reg query %_PRIDs%\ProPlusVolume.16 1>nul 2>nul && set _ProPlus=0

for %%a in (Professional2019,ProPlus2019,ProjectPro2019,VisioPro2019) do if !_%%aR! equ 1 (
set _%%a=0
)
if !_Mondo! equ 1 (
echo Mondo Suite
echo.
call :InsLic Mondo
goto :GVLK
)
if !_O365ProPlus! equ 1 (
echo O365ProPlus Suite -^> Mondo Licenses
echo.
call :InsLic Mondo
goto :GVLK
)
if !_ProPlus2019! equ 1 (
echo ProPlus2019 Suite
echo.
call :InsLic ProPlus2019
)
if !_ProPlus! equ 1 if !_ProPlus2019! equ 0 if !_O365ProPlus! equ 0 (
echo ProPlus Suite
echo.
call :InsLic ProPlus
)
if !_Professional2019! equ 1 if !_ProPlus2019! equ 0 if !_O365ProPlus! equ 0 if !_ProPlus! equ 0 (
echo Professional2019 Suite -^> ProPlus2019 Licenses
echo.
call :InsLic ProPlus2019
)
if !_Professional! equ 1 if !_ProPlus2019! equ 0 if !_O365ProPlus! equ 0 if !_ProPlus! equ 0 if !_Professional2019! equ 0 (
echo Professional Suite -^> ProPlus Licenses
echo.
call :InsLic ProPlus
)
if !_Standard2019! equ 1 if !_ProPlus2019! equ 0 if !_O365ProPlus! equ 0 if !_ProPlus! equ 0 if !_Professional2019! equ 0 if !_Professional! equ 0 (
echo Standard2019 Suite
echo.
call :InsLic Standard2019
)
if !_Standard! equ 1 if !_ProPlus2019! equ 0 if !_O365ProPlus! equ 0 if !_ProPlus! equ 0 if !_Professional2019! equ 0 if !_Professional! equ 0 if !_Standard2019! equ 0 (
echo Standard Suite
echo.
call :InsLic Standard
)
for %%a in (ProjectPro2019,VisioPro2019,ProjectStd2019,VisioStd2019) do if !_%%a! equ 1 (
echo %%a SKU
echo.
call :InsLic %%a
)
for %%a in (ProjectPro,ProjectStd,VisioPro,VisioStd) do if !_%%a! equ 1 (
if !_%%a2019! equ 0 (echo %%a SKU&echo.&call :InsLic %%aX)
)
for %%a in (%A19Ids%,%AppIds%) do if !_%%a! equ 1 (
if !_ProPlus2019! equ 0 if !_O365ProPlus! equ 0 if !_ProPlus! equ 0 if !_Professional2019! equ 0 if !_Professional! equ 0 if !_Standard2019! equ 0 if !_Standard! equ 0 (echo %%a App&echo.&call :InsLic %%a)
)
for %%a in (Access2019,Access) do if !_%%a! equ 1 (
if !_ProPlus2019! equ 0 if !_O365ProPlus! equ 0 if !_ProPlus! equ 0 if !_Professional2019! equ 0 if !_Professional! equ 0 (echo %%a App&echo.&call :InsLic %%a)
)
for %%a in (SkypeforBusiness2019,SkypeforBusiness) do if !_%%a! equ 1 (
if !_ProPlus2019! equ 0 if !_O365ProPlus! equ 0 if !_ProPlus! equ 0 (echo %%a App&echo.&call :InsLic %%a)
)
goto :GVLK

:InsLic
set "_ID=%1Volume"
"%_Integrator%" /I /License PRIDName=%_ID%.16 PackageGUID="%_GUID%" PackageRoot="%_InstallRoot%" >nul
reg add %_Config% /v %_ID%.OSPPReady /t REG_SZ /d 1 /f >nul
reg query %_Config% /v ProductReleaseIds | findstr /I "%_ID%" >nul 
if %errorlevel% neq 0 (
for /f "skip=2 tokens=2*" %%a in ('reg query %_Config% /v ProductReleaseIds') do reg add %_Config% /v ProductReleaseIds /t REG_SZ /d "%%b,%_ID%" /f >nul
)
exit /b

:GVLK
if "!_Preserve!" neq "" (
for %%a in (!_Preserve!) do "%_Integrator%" /I /License PRIDName=%%a.16 PackageGUID="%_GUID%" PackageRoot="%_InstallRoot%" >nul
)
echo ============================================================
echo Installing KMS Client Keys...
echo ============================================================
echo.
for /f "tokens=2 delims==" %%G in ('"wmic path %spp% where (Description like '%%KMSCLIENT%%' AND LicenseFamily like 'Office%%' AND PartialProductKey=NULL) get ID /value" 2^>nul') do (set app=%%G&call :InsKey)
set "msg=Finished"
goto :end

:InsKey
if /i '%app%' equ 'e914ea6e-a5fa-4439-a394-a9bb3293ca09' exit /b
if /i '%app%' equ '0bc88885-718c-491d-921f-6f214349e79c' exit /b
if /i '%app%' equ 'fc7c4d0c-2e85-4bb9-afd4-01ed1476b5e9' exit /b
if /i '%app%' equ '500f6619-ef93-4b75-bcb4-82819998a3ca' exit /b
set "key="
for /f "tokens=2 delims==" %%A in ('"wmic path %spp% where ID='%app%' get LicenseFamily /value"') do echo %%A
for /f %%A in ('cscript //Nologo x86\key.vbs %app%') do set "key=%%A"
if "%key%" equ "" (echo Could not find matching gVLK&echo.&exit /b)
wmic path %sps% where version='%ver%' call InstallProductKey ProductKey="%key%" >nul 2>&1
echo.
exit /b

:end
echo.
echo ============================================================
echo %msg%
echo ============================================================
echo.
goto :Finish

:Finish
Choice /C 12 /N /M "YOUR CHOICE: [1] RETURN KMS SUITE MENU or [2] EXIT ==>"
if %errorlevel%==1 goto :KMSSuite
if %errorlevel%==2 goto :Exit

:KMSSuite
cd..
cd..
call KMS_Suite.cmd
exit

:Exit
exit