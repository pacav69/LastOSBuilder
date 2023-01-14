@echo off

rem Make OOBE prettier (Maybe)

rem This tweak causes the Immersive Panel in Win10 to use its built-in dark theme
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f

rem my default dark colors
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v Composition /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v ColorizationColor /t REG_DWORD /d 0xc44c4a48 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v ColorizationAfterglow /t REG_DWORD /d 0xc44c4a48 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v AccentColor /t REG_DWORD /d 0xff484a4c /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v ColorPrevalence /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v AccentColorInactive /t REG_DWORD /d 0x00636363 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v ColorizationColorBalance /t REG_DWORD /d 0x00000059 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v ColorizationAfterglowBalance /t REG_DWORD /d 0x0000000a /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v ColorizationBlurBalance /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v EnableWindowColorization /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v ColorizationGlassAttribute /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v AlwaysHibernateThumbnails /t REG_DWORD /d 0 /f

REM customized to run in LastOS builds from \sources\$OEM$\$$\Setup\Scripts with KMSpico folder at \sources\$OEM$\$$
pushd "%~dp0"
echo Please wait...
REM Disable SmartScreen
regedit /S DisableSmartScreen.reg
REM Activate
%WinDir%\KMSpico\AutoPico.exe
REM Create Task for AutoReactivation
set directorio=%WinDir%\KMSpico
set name="AutoPico Daily Restart"
SCHTASKS /Create /TN %name% /TR "%WinDir%\KMSpico\AutoPico.exe /silent" /SC DAILY /ST 23:59:59 /RU SYSTEM /RL Highest /F
popd

REM Make Post-Setup.cmd Run
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce /f /v "CLEANUP" /d "C:\Windows\Setup\Scripts\Post-Setup.cmd"

REM Make Update Service Enabled
sc config UsoSvc start=demand

