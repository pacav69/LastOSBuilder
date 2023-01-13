@echo OFF
SetLocal EnableDelayEdexpansion
Set HKFindKey=%~2
Set HKMainNew=HKEY_LOCAL_MACHINE\%~1
Set HKMainOrg=%HKMainNew:HKEY_LOCAL_MACHINE\Tmp_=HKEY_LOCAL_MACHINE\Tmp_Install_%
If "%HKMainOrg:~0,31%" neq "HKEY_LOCAL_MACHINE\Tmp_Install_" Goto :EOF
If "%HKFindKey%" equ "" Reg Copy "%HKMainOrg%" "%HKMainNew%" /S /F
If "%HKFindKey%" neq "" For /F "delims=" %%A IN ('Reg Query "%HKMainOrg%" /S /F "%HKFindKey%"') Do Call :_RegCopy "%%A"

Goto :EOF

:_RegCopy
Set HKeyOrg=%~1
If "%HKeyOrg:~0,5%" neq "HKEY_" Goto :EOF
Call Set HKeyNew=%%HKeyOrg:!HKMainOrg!=!HKMainNew!%%
Reg Query "%HKeyOrg%" >nul 2>nul
::If Not ErrorLevel 1 Echo Reg Copy "%HKeyOrg%" "%HKeyNew%" /S /F
If Not ErrorLevel 1 Reg Copy "%HKeyOrg%" "%HKeyNew%" /S /F
Goto :EOF

:_Info
:: Copy Registry Key between for ex: install.wim registry and Target registry.
::   Usage: MainKey SubKey Or Value (* accepted). Use quotes #$q if there are any spaces in the main key or in the searched key.
::   The main key must start with Tmp_Software, Tmp_System or Tmp_Drivers. And, the related hives Tmp_Install_Software, Tmp_Install_System are used as original key.
::   Both hives, Origin and target must be mounted before calling CopyRegKey.cmd and can be Unloaded then. Ex:
:: CopyRegKey.cmd Tmp_Software\Microsoft\Windows\CurrentVersion,SideBySide\Winners x86_microsoft.vc90.crt_*"  (Tmp_Software and Tmp_Install_Software must be mounted)
:: CopyRegKey.cmd Tmp_System\ControlSet001\Services\NlaSvc  (Tmp_System and Tmp_Install_System must be mounted)
