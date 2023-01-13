@echo off
title %~nx0
echo.
echo ~ Applying Tweaks ~
echo.

rem ************************************************************
rem ****************** Tweak Default Account *******************
rem ************************************************************

reg load HKLM\DEFAULT C:\users\default\ntuser.dat
 
rem Hide Taskview button on Taskbar
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f
 
rem Hide People button from Taskbar
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v PeopleBand /t REG_DWORD /d 0 /f
 
rem Remove OneDrive Setup from the RUN key
reg delete "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v OneDriveSetup /F
 
rem This tweak causes the Immersive Panel in Win10 to use its built-in dark theme
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f

rem my default dark colors
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\DWM" /v Composition /t REG_DWORD /d 1 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\DWM" /v ColorizationColor /t REG_DWORD /d 0xc44c4a48 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\DWM" /v ColorizationAfterglow /t REG_DWORD /d 0xc44c4a48 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\DWM" /v AccentColor /t REG_DWORD /d 0xff484a4c /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\DWM" /v ColorPrevalence /t REG_DWORD /d 1 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\DWM" /v AccentColorInactive /t REG_DWORD /d 0x00636363 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\DWM" /v ColorizationColorBalance /t REG_DWORD /d 0x00000059 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\DWM" /v ColorizationAfterglowBalance /t REG_DWORD /d 0x0000000a /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\DWM" /v ColorizationBlurBalance /t REG_DWORD /d 1 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\DWM" /v EnableWindowColorization /t REG_DWORD /d 1 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\DWM" /v ColorizationGlassAttribute /t REG_DWORD /d 1 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 1 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\DWM" /v AlwaysHibernateThumbnails /t REG_DWORD /d 0 /f

rem Expand More Details during File Processors
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v EnthusiastMode /t REG_DWORD /d 1 /f

rem rem Disable Security and Maintenance Notifications (Disabled By Glenn)
rem reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v Enabled /t REG_DWORD /d 0 /f
 
rem rem Disable Game DVR (Disabled By Glenn)
rem reg add "HKLM\DEFAULT\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
rem reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f

reg unload HKLM\DEFAULT

rem ************************************************************
rem *************** Tweak current Admin Account ****************
rem ************************************************************

rem Hide Taskview button on Taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f
 
rem Hide People button from Taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v PeopleBand /t REG_DWORD /d 0 /f

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

rem Expand More Details during File Processors
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v EnthusiastMode /t REG_DWORD /d 1 /f

IF [%1]==[] pause