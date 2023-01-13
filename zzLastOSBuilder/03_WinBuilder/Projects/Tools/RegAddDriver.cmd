@echo OFF
SetLocal EnableDelayEdexpansion
Set HKFindKey=%~1

Set HKMainOrg=HKEY_LOCAL_MACHINE\Tmp_Install_Drivers\DriverDatabase\DriverInfFiles
Set HKMainNew=HKEY_LOCAL_MACHINE\Tmp_Drivers\DriverDatabase\DriverInfFiles
Reg Query "%HKMainNew%" >nul 2>nul
If %ERRORLEVEL% NEQ 0 Exit 1
Reg Query "%HKMainOrg%\%HKFindKey%" >nul 2>nul
If %ERRORLEVEL% NEQ 0 Exit 1
Call :_RegCopy "%HKMainOrg%\%HKFindKey%"

Set HKMainOrg="HKEY_LOCAL_MACHINE\Tmp_Install_Drivers\DriverDatabase\DeviceIds"
Set HKMainNew="HKEY_LOCAL_MACHINE\Tmp_Drivers\DriverDatabase\DeviceIds"
For /F "tokens=1,2,3*" %%A IN ('REG Query %HKMainOrg% /s /e /f %HKFindKey%') Do (
  If /I Not "%%A" EQU "%HKFindKey%" (Set "HKeyOrg=%%A") Else (
    Set HKeyNew=!HKeyOrg:HKEY_LOCAL_MACHINE\Tmp_Install_=HKEY_LOCAL_MACHINE\Tmp_!
    ::Echo Reg Add "!HKeyNew!" /v "%%A" /t %%B /d "%%C" /f
    If "%%B" NEQ "REG_NONE" (Reg Add "!HKeyNew!" /v %%A /t %%B /d "%%C" /f >nul) Else (Call :_RegNone "!HKeyNew!" "%%A")
  )
)

Set HKMainOrg=HKEY_LOCAL_MACHINE\Tmp_Install_Drivers\DriverDatabase\DriverFiles
Set HKMainNew=HKEY_LOCAL_MACHINE\Tmp_Drivers\DriverDatabase\DriverFiles
For /F %%A IN ('REG Query "%HKMainOrg%" /s /d /e /f "%HKFindKey%"') Do Call :_RegCopy "%%A"

Set HKMainOrg=HKEY_LOCAL_MACHINE\Tmp_Install_Drivers\DriverDatabase\DriverPackages
Set HKMainNew=HKEY_LOCAL_MACHINE\Tmp_Drivers\DriverDatabase\DriverPackages
For /F %%A IN ('Reg Query "%HKMainOrg%" /k /f "%HKFindKey%"') Do Call :_RegCopy "%%A"
Exit

:_RegCopy
Set HKeyOrg=%~1
If "%HKeyOrg:~0,5%" NEQ "HKEY_" Goto :EOF
Call Set HKeyNew=%%HKeyOrg:!HKMainOrg!=!HKMainNew!%%
Reg Query "%HKeyOrg%" >nul 2>nul
::If Not ErrorLevel 1 Echo Reg Copy "%HKeyOrg%" "%HKeyNew%" /s /f
If Not ErrorLevel 1 Reg Copy "%HKeyOrg%" "%HKeyNew%" /s /f
Goto :EOF

:_RegNone
Set RegNone="%TEMP%\RegNone.txt"
Echo Windows Registry Editor Version 5.00 > %RegNone%
Echo [%~1] >> %RegNone%
Echo "%~2"=hex(0): >> %RegNone%
Reg Import %RegNone%
Del /q %RegNone% 2>nul
Goto :EOF