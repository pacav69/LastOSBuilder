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