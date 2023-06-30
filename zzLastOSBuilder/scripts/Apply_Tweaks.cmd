@echo off
set "scriptver=0.0.1"

::------------------------------------------------------------------------------
:: Apply tweaks v%scriptver%
:: Copyright (c) 2023 LastOS. All rights reserved.
::------------------------------------------------------------------------------
::
:: Credits: CREDITS.TXT
:: License: LICENSE.TXT
:: 3rd Party License: <Bin\LICENSES>
::
::-------------------------------------------------------------------------------------------

rem color 1f
color 02
title Apply tweaks v%scriptver%

reg add "HKCU\Console\%%SystemRoot%%_system32_cmd.exe" /v "ScreenBufferSize" /t REG_DWORD /d "0x23290050" /f >nul
reg add "HKCU\Console\%%SystemRoot%%_system32_cmd.exe" /v "WindowSize" /t REG_DWORD /d "0x190050" /f >nul

setlocal EnableExtensions EnableDelayedExpansion

:: Setting Toolkit environment path variables
set "Bin=%~dp0Bin"
set "Custom=%~dp0Custom"
set "Drivers=%~dp0Drivers"
set "DVD=%~dp0DVD"
set "ISO=%~dp0ISO"
set "Logs=%~dp0Logs"
set "Mount=%~dp0Mount"
set "Packs=%~dp0Packs"
set "ROOT=%~dp0"
set "Temp=%~dp0Temp"
set "Updates=%~dp0Updates"
set "WHD=%~dp0WHD"

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

:: Setting Apps status flags
for %%i in (I_3DViewer,I_Alarms,I_AmazonAppStore,I_AV1VideoExtension,I_BingFinance,I_BingFoodDrink,I_BingHealthFitness,I_BingMaps,I_BingNews,I_BingSports,I_BingTravel,I_BingWeather,I_Calculator,I_Camera,I_ClientWebExperience,I_Clipchamp,I_CommunicationsApps,I_Cortana,I_D3DMappingLayers,I_DesktopAppInstaller,I_DirectXRuntime,I_FeedbackHub,I_GamingApp,I_GamingServices,I_GetHelp,I_Getstarted,I_HEIFImageExtension,I_HelpAndTips,I_HEVCVideoExtension,I_Journal,I_Maps,I_Messaging,I_MicrosoftPowerBI,I_MinecraftEducationEdition,I_MixedRealityPortal,I_MPEG2VideoExtension,I_Notepad,I_NVIDIAControlPanel,I_OfficeHub,I_OfficeOneNote,I_OneConnect,I_Paint,I_Paint3D,I_People,I_Photos,I_PowerAutomateDesktop,I_Print3D,I_QuickAssist,I_RawImageExtension,I_Reader,I_ReadingList,I_RealtekAudioControl,I_Scan,I_ScreenSketch,I_SkypeApp,I_SolitaireCollection,I_SoundRecorder,I_StickyNotes,I_StorePurchaseApp,I_TeamsChat,I_Terminal,I_Todos,I_VP9VideoExtensions,I_Wallet,I_WebMediaExtensions,I_WebpImageExtension,I_Whiteboard,I_WindowsDefender,I_WindowsStore,I_WindowsSubsystemForAndroid,I_WindowsSubsystemForLinux,I_Xbox,I_XboxGameOverlay,I_XboxGamingOverlay,I_XboxIdentityProvider,I_XboxLiveGames,I_XboxSpeechToTextOverlay,I_XboxTCUI,I_YourPhone,I_ZuneMusic,I_ZuneVideo) do (
	set "%%i=-"
)

:: Setting Components status flags
for %%i in (C_AdobeFlashForWindows,C_EdgeChromium,C_EdgeWebView,C_InternetExplorer,C_FirstLogonAnimation,C_GameExplorer,C_LockScreenBackground,C_ScreenSavers,C_SnippingTool,C_SoundThemes,C_SpeechRecognition,C_Wallpapers,C_WindowsMediaPlayer,C_WindowsPhotoViewer,C_WindowsThemes,C_WindowsTIFFIFilter,C_WinSAT,C_OfflineFiles,C_OpenSSH,C_RemoteDesktopClient,C_RemoteDifferentialCompression,C_SimpleTCPIPServices,C_TelnetClient,C_TFTPClient,C_WalletService,C_WindowsMail,C_AssignedAccess,C_CEIP,C_FaceRecognition,C_KernelDebugging,C_LocationService,C_PicturePassword,C_PinEnrollment,C_UnifiedTelemetryClient,C_WiFiNetworkManager,C_WindowsErrorReporting,C_WindowsInsiderHub,C_HomeGroup,C_MultiPointConnector,C_OneDrive,C_RemoteAssistance,C_RemoteDesktopServer,C_RemoteRegistry,C_WorkFoldersClient,C_AccessibilityTools,C_Calculator,C_DeviceLockdown,C_EaseOfAccessCursors,C_EaseOfAccessThemes,C_EasyTransfer,C_FileHistory,C_Magnifier,C_ManualSetup,C_Narrator,C_Notepad,C_OnScreenKeyboard,C_Paint,C_ProjFS,C_SecurityCenter,C_StepsRecorder,C_StorageSpaces,C_SystemRestore,C_WindowsBackup,C_WindowsFirewall,C_WindowsSubsystemForLinux,C_WindowsToGo,C_Wordpad,C_AADBrokerPlugin,C_AccountsControl,C_AddSuggestedFoldersToLibraryDialog,C_AppResolverUX,C_AssignedAccessLockApp,C_AsyncTextService,C_BioEnrollment,C_CallingShellApp,C_CapturePicker,C_CBSPreview,C_ContentDeliveryManager,C_Cortana,C_CredDialogHost,C_ECApp,C_Edge,C_EdgeDevToolsClient,C_FileExplorer,C_FilePicker,C_LockApp,C_MapControl,C_NarratorQuickStart,C_NcsiUwpApp,C_OOBENetworkCaptivePortal,C_OOBENetworkConnectionFlow,C_ParentalControls,C_PeopleExperienceHost,C_PinningConfirmationDialog,C_PrintDialog,C_PPIProjection,C_QuickAssist,C_RetailDemoContent,C_SearchApp,C_SecureAssessmentBrowser,C_SettingSync,C_SkypeORTC,C_SmartScreen,C_WebcamExperience,C_WebView2SDK,C_Win32WebViewHost,C_WindowsDefender,C_WindowsMixedReality,C_WindowsReaderPDF,C_WindowsStoreClient,C_XboxClient,C_XboxGameCallableUI,C_XGpuEjectDialog,C_3DViewer,C_AdvertisingXaml,C_Alarms,C_BingNews,C_BingWeather,C_CalculatorApp,C_Camera,C_ClientWebExperience,C_Clipchamp,C_CommunicationsApps,C_DesktopAppInstaller,C_Family,C_FeedbackHub,C_GamingApp,C_GetHelp,C_Getstarted,C_HEIFImageExtension,C_HEVCVideoExtension,C_Maps,C_Messaging,C_MixedRealityPortal,C_NotepadApp,C_OfficeHub,C_OfficeOneNote,C_OneConnect,C_Paint3D,C_People,C_Photos,C_PowerAutomateDesktop,C_Print3D,C_RawImageExtension,C_ScreenSketch,C_ServicesStoreEngagement,C_SkypeApp,C_SolitaireCollection,C_SoundRecorder,C_StickyNotes,C_StorePurchaseApp,C_Terminal,C_Todos,C_VP9VideoExtensions,C_Wallet,C_WebMediaExtensions,C_WebpImageExtension,C_WindowsStoreApp,C_XboxApp,C_XboxGameOverlay,C_XboxGamingOverlay,C_XboxIdentityProvider,C_XboxSpeechToTextOverlay,C_XboxTCUI,C_YourPhone,C_ZuneMusic,C_ZuneVideo) do (
	set "%%i=+"
)

::-------------------------------------------------------------------------------------------
:: MSMG ToolKit - EULA
::-------------------------------------------------------------------------------------------
cls

echo.===============================================================================
echo.########################## MSMG ToolKit - EULA ################################
echo.===============================================================================
echo.
echo.
echo. The MSMG Toolkit is basically a tool to service, customize, add or remove
echo. features and components, enable or disable features to Windows operating
echo. system.
echo.
echo. The MSMG Toolkit is intended to be used with licensed Microsoft Windows
echo. operating systems only.
echo.
echo. This MSMG Toolkit is provided 'as-is', without any express or implied warranty.
echo. In no event will the author be held liable for any damages arising from the
echo. use of this script.
echo.
echo. The MSMG Toolkit uses various 3rd party tools to accomplish some of it's
echo. tasks.
echo.
echo. MSMG ToolKit, Windows are registered trademarks of their respective authors
echo. or companies.
echo.
echo.
echo.===============================================================================
choice /C:AR /N /M "###########################[ 'A'ccept / 'R'eject ]############################"
if errorlevel 2 (
	reg delete "HKCU\Console\%%SystemRoot%%_system32_cmd.exe" /f >nul

	color 00
	endlocal

	exit
)

::-------------------------------------------------------------------------------------------
:: MSMG Toolkit - Startup function
::-------------------------------------------------------------------------------------------
cls

echo.
echo.Performing Toolkit pre-cleanup operation, please wait...
call :Cleanup >nul
cls
echo.===============================================================================
echo.                           MSMG ToolKit - StartUp
echo.===============================================================================
echo.
echo.Reading Host OS Information...
echo.
echo.%HostOSName% %HostDisplayVersion% - v%HostVersion%.%HostBuild%.%HostServicePackBuild% %HostArchitecture% %HostLanguage%

:: Setting DOS character codepage
if "%HostLanguage%" equ "en-GB" chcp 437 >nul
if "%HostLanguage%" equ "en-US" chcp 437 >nul
if "%HostLanguage%" equ "zh-CN" chcp 936 >nul

echo.
echo.Setting Toolkit and WADK tools environment path variables...
echo.
echo.DISM.exe           =  %DISM%
call :CreateFolder "%DismScratch%"
set "DISM=%DISM% %DismFormat%"
echo.Imagex.exe         =  %Imagex%
echo.Oscdimg.exe        =  %Oscdimg%
echo.Dvdburn.exe        =  %Dvdburn%
echo.7zip.exe           =  %Zip%
echo.Dism++CUI.exe      =  %W10EsdDecrypter%
echo.EsdDecrypt.exe     =  %W81EsdDecrypter%
echo.ToolKitHelper.exe  =  %ToolKitHelper%
echo.ResourceHacker.exe =  %ResourceHacker%
echo.WimlibImagex.exe   =  %WimlibImagex%
echo.
echo.===============================================================================
echo.
pause
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: MSMG Toolkit - Main Menu
::-------------------------------------------------------------------------------------------
:MainMenu

cls
echo.===============================================================================
echo.                           MSMG ToolKit - Main Menu
echo.===============================================================================
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
echo.
echo.                             [X]   Quit
echo.
echo.===============================================================================
echo.
choice /C:1234567X /N /M "Enter Your Choice : "
if errorlevel 8 goto :Quit
if errorlevel 7 goto :ToolsMenu
if errorlevel 6 goto :MenuTarget
if errorlevel 5 goto :ApplyMenu
if errorlevel 4 goto :CustomizeMenu
if errorlevel 3 goto :MenuRemove
if errorlevel 2 goto :MenuIntegrate.cmd
if errorlevel 1 goto :MenuSource
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: MSMG Toolkit - Select Source Menu
::-------------------------------------------------------------------------------------------
:MenuSource

cls
echo.===============================================================================
echo.                         MSMG ToolKit - Source Menu
echo.===============================================================================
echo.

:: Checking whether Source OS is selected
if "%IsSourceSelected%" equ "Yes" (
	echo.Source OS has already been selected...
	echo.
	echo.===============================================================================
	echo.
	pause
	goto :MainMenu
)

:: Checking whether Image Registry is loaded
if "%IsImageRegistryLoaded%" equ "Yes" (
	echo.Source OS Image Registry is loaded, please do unload it using Tools-^>Options..
	echo.
	echo.===============================================================================
	echo.
	pause
	goto :MainMenu
)

echo.  [1]   Select Source from ^<DVD^> Folder
echo.
echo.  [2]   Copy Source from DVD Drive
echo.
echo.  [3]   Extract Source from DVD ISO Image
echo.
echo.  [4]   Extract Source from OEM IMG Image
echo.
echo.  [5]   Extract Source from Store ESD Image
echo.
echo.  [6]   Extract Source from MCT or Custom ESD Image
echo.
echo.
echo.
echo.
echo.  [X]   Go Back
echo.
echo.===============================================================================
echo.
choice /C:123456X /N /M "Enter Your Choice : "
if errorlevel 7 goto :MainMenu
if errorlevel 6 goto :ExtractSourceESD
if errorlevel 5 goto :ExtractSourceStoreESD
if errorlevel 4 goto :ExtractSourceIMG
if errorlevel 3 goto :ExtractSourceISO
if errorlevel 2 goto :CopySourceDVD
if errorlevel 1 goto :SelectSourceDVD
::-------------------------------------------------------------------------------------------



rem*****************************************************************************

rem set variables
set "SelectedSourceOS=w11"



::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to Apply Tweaks Menu
::-------------------------------------------------------------------------------------------
:ApplyTweaksMenu

setlocal

set Tweak=

cls
echo.===============================================================================
echo.                      MSMG ToolKit - Apply Tweaks Menu
echo.===============================================================================
echo.

if "%SelectedSourceOS%" equ "w81" (
	echo.  [A]   Disable Automatic Driver Updates through Windows Update
	echo.  [B]   Disable Automatic Downloading and Installing 3rd Party Apps
	echo.  [C]   Disable Windows Defender
	echo.  [D]   Disable Windows Firewall
	echo.  [E]   Disable Windows SmartScreen
	echo.  [F]   Disable Automatic Windows Upgrade
	echo.  [G]   Disable Windows Update
	echo.  [H]   Force .NET Programs to Use Newest .NET Framework
	echo.  [I]   Enable Windows Photo Viewer
	echo.  [J]   Enable Fraunhofer MP3 Professional Codec
	echo.
	echo.
	echo.
	echo.
	echo.  [1]   All Tweaks
	echo.  [X]   Go Back
	echo.
	echo.===============================================================================
	echo.
	choice /C:ABCDEFGHIJ1X /N /M "Enter Your Choice : "
	if errorlevel 12 goto :CustomizeMenu
	if errorlevel 11 set "Tweak=AllTweaks"
	if errorlevel 10 set "Tweak=EnableFMP3ProCodec"
	if errorlevel 9  set "Tweak=EnablePhotoViewer"
	if errorlevel 8  set "Tweak=ForceLatestNetFramework"
	if errorlevel 7  set "Tweak=DisableWindowsUpdate"
	if errorlevel 6  set "Tweak=DisableWindowsUpgrade"
	if errorlevel 5  set "Tweak=DisableWindowsSmartScreen"
	if errorlevel 4  set "Tweak=DisableWindowsFirewall"
	if errorlevel 3  set "Tweak=DisableWindowsDefender"
	if errorlevel 2  set "Tweak=Disable3RDPartyApps"
	if errorlevel 1  set "Tweak=DisableDriversUpdates"
)

if "%SelectedSourceOS%" equ "w10" (
	echo.  [A]   Disable Automatic Driver Updates through Windows Update
	echo.  [B]   Disable Automatic Download and Install of 3rd Party Apps
	echo.  [C]   Disable Automatic Windows Upgrade
	echo.  [D]   Disable Cortana App
	echo.  [E]   Disable Microsoft Reserved Storage Space for Windows Updates
	echo.  [F]   Disable Windows Defender
	echo.  [G]   Disable Windows Firewall
	echo.  [H]   Disable Windows SmartScreen
	echo.  [I]   Disable Windows Update
	echo.  [J]   Enable DISM Image Cleanup with Full ResetBase
	echo.  [K]   Enable Fraunhofer MP3 Professional Codec
	echo.  [L]   Enable Windows Photo Viewer
	echo.  [M]   Force .NET Programs to Use Newest .NET Framework
	echo.  [N]   Hide Taskbar Cortana Icon
	echo.  [O]   Hide Taskbar Meet Now Icon
	echo.  [P]   Hide Taskbar News and Interests
	echo   [Q]   Hide Taskbar Search Bar
	echo.  [R]   Hide Taskbar Task View Icon
	echo.
	echo.  [1]   All Tweaks
	echo.  [X]   Go Back
	echo.===============================================================================
	echo.
	choice /C:ABCDEFGHIJKLMNOPQR1X /N /M "Enter Your Choice : "
	if errorlevel 20 goto :CustomizeMenu
	if errorlevel 19 set "Tweak=AllTweaks"
	if errorlevel 18 set "Tweak=HideTaskViewIcon"
	if errorlevel 17 set "Tweak=HideSearchBar"
	if errorlevel 16 set "Tweak=HideNewsAndInterests"
	if errorlevel 15 set "Tweak=HideMeetNowIcon"
	if errorlevel 14 set "Tweak=HideCortanaIcon"
	if errorlevel 13 set "Tweak=ForceLatestNetFramework"
	if errorlevel 12 set "Tweak=EnablePhotoViewer"
	if errorlevel 11 set "Tweak=EnableFMP3ProCodec"
	if errorlevel 10 set "Tweak=EnableFullResetBase"
	if errorlevel 9  set "Tweak=DisableWindowsUpdate"
	if errorlevel 8  set "Tweak=DisableWindowsSmartScreen"
	if errorlevel 7  set "Tweak=DisableWindowsFirewall"
	if errorlevel 6  set "Tweak=DisableWindowsDefender"
	if errorlevel 5  set "Tweak=DisableReservedStorage"
	if errorlevel 4  set "Tweak=DisableCortanaApp"
	if errorlevel 3  set "Tweak=DisableWindowsUpgrade"
	if errorlevel 2  set "Tweak=Disable3RDPartyApps"
	if errorlevel 1  set "Tweak=DisableDriversUpdates"
)

if "%SelectedSourceOS%" equ "w11" (
	echo.  [A]   Disable Automatic Driver Updates through Windows Update
	echo.  [B]   Disable Automatic Download and Install of 3rd Party Apps
	echo.  [C]   Disable Automatic Download and Install of Microsoft Teams App
	echo.  [D]   Disable Automatic Windows Upgrade
	echo.  [E]   Disable Cortana App
	echo.  [F]   Disable Microsoft Reserved Storage Space for Windows Updates
	echo.  [G]   Disable Windows 11 Installer Hardware Check TPM
	echo.  [H]   Disable Windows Defender
	echo.  [I]   Disable Windows Firewall
	echo.  [J]   Disable Windows SmartScreen
	echo.  [K]   Disable Windows Update
	echo.  [L]   Enable DISM Image Cleanup with Full ResetBase
	echo.  [M]   Enable Fraunhofer MP3 Professional Codec
	echo.  [N]   Enable Windows Classic Context Menus
	echo.  [O]   Enable Windows Local Account
	echo.  [P]   Enable Windows Photo Viewer
	echo.  [Q]   Force .NET Programs to Use Newest .NET Framework
	echo.  [R]   Hide Taskbar Chat Icon
	echo.  [S]   Hide Taskbar Cortana Icon
	echo.  [T]   Hide Taskbar Meet Now Icon
	echo.  [U]   Hide Taskbar News and Interests
	echo   [V]   Hide Taskbar Search Bar
	echo.  [W]   Hide Taskbar Task View Icon
	echo.  [X]   Hide Taskbar Widgets Icon
	echo.
	echo.  [1]   All Tweaks
	echo.  [2]   Go Back
	echo.===============================================================================
	choice /C:ABCDEFGHIJKLMNOPQRSTUVWX12 /N /M "Enter Your Choice : "
	if errorlevel 26 goto :CustomizeMenu
	if errorlevel 25 set "Tweak=AllTweaks"
	if errorlevel 24 set "Tweak=HideWidgetsIcon"
	if errorlevel 23 set "Tweak=HideTaskViewIcon"
	if errorlevel 22 set "Tweak=HideSearchBar"
	if errorlevel 21 set "Tweak=HideNewsAndInterests"
	if errorlevel 20 set "Tweak=HideMeetNowIcon"
	if errorlevel 19 set "Tweak=HideCortanaIcon"
	if errorlevel 18 set "Tweak=HideChatIcon"
	if errorlevel 17 set "Tweak=ForceLatestNetFramework"
	if errorlevel 16 set "Tweak=EnablePhotoViewer"
	if errorlevel 15 set "Tweak=EnableLocalAccount"
	if errorlevel 14 set "Tweak=EnableClassicContextMenu"
	if errorlevel 13 set "Tweak=EnableFMP3ProCodec"
	if errorlevel 12 set "Tweak=EnableFullResetBase"
	if errorlevel 11 set "Tweak=DisableWindowsUpdate"
	if errorlevel 10 set "Tweak=DisableWindowsSmartScreen"
	if errorlevel 9  set "Tweak=DisableWindowsFirewall"
	if errorlevel 8  set "Tweak=DisableWindowsDefender"
	if errorlevel 7  set "Tweak=DisableW11InstHardwareCheck"
	if errorlevel 6  set "Tweak=DisableReservedStorage"
	if errorlevel 5  set "Tweak=DisableCortanaApp"
	if errorlevel 4  set "Tweak=DisableWindowsUpgrade"
	if errorlevel 3  set "Tweak=DisableTeamsApp"
	if errorlevel 2  set "Tweak=Disable3RDPartyApps"
	if errorlevel 1  set "Tweak=DisableDriversUpdates"
)

cls
echo.===============================================================================
echo.                       MSMG ToolKit - Apply Tweaks
echo.===============================================================================
echo.
:: Get updated Image Information
if "%ImageBuild%" geq "18362" if "%ImageBuild%" leq "19045" (
   call :GetUpdatedImageInformation
)

:: Getting Install Image Index Architecture
call :GetImageArchitecture "%InstallWim%", %DefaultIndexNo% >nul

if "%Tweak%" equ "DisableW11InstHardwareCheck" if "%IsBootImageSelected%" equ "No" (
	echo.Windows Setup Boot Image is not selected...
	echo.
	echo.Please choose Windows Setup Boot Image while selecting Source...
	goto :Stop
)

echo.-------------------------------------------------------------------------------
echo.####Starting Applying Tweaks###################################################
echo.-------------------------------------------------------------------------------
echo.
echo.    Image                    : Install.wim
echo.    Image Index              : %ImageIndexNo%
echo.    Image Architecture       : %ImageArchitecture%
echo.    Image Version            : %ImageVersion%.%ImageServicePackBuild%.%ImageServicePackLevel%
echo.
echo.-------------------------------------------------------------------------------
if "%Tweak%" equ "AllTweaks" echo.####Applying All Tweaks########################################################
if "%Tweak%" equ "Disable3RDPartyApps" echo.####Applying Disable Automatic Download and Install of 3rd Party Apps Tweak####
if "%Tweak%" equ "DisableCortanaApp" echo.####Applying Disable Cortana App Tweak#########################################
if "%Tweak%" equ "DisableDriversUpdates" echo.####Applying Disable Automatic Driver Updates through Windows Update Tweak#####
if "%Tweak%" equ "DisableReservedStorage" echo.####Applying Disable Microsoft Reserved Storage Space for Windows Updates######
if "%Tweak%" equ "DisableTeamsApp" echo.####Applying Disable Automatic Download and Install of Teams App Tweak#########
if "%Tweak%" equ "DisableW11InstHardwareCheck" echo.####Applying Disable Windows 11 Installer Hardware Check#######################
if "%Tweak%" equ "DisableWindowsDefender" echo.####Applying Disable Windows Defender Tweak####################################
if "%Tweak%" equ "DisableWindowsFirewall" echo.####Applying Disable Windows Firewall Tweak####################################
if "%Tweak%" equ "DisableWindowsSmartScreen" echo.####Applying Disable Windows SmartScreen Tweak################################
if "%Tweak%" equ "DisableWindowsUpdate" echo.####Applying Disable Windows Update Tweak######################################
if "%Tweak%" equ "DisableWindowsUpgrade" echo.####Applying Disable Automatic Windows OS Upgrade Tweak########################
if "%Tweak%" equ "EnableClassicContextMenu" echo.####Applying Enable Windows Classic Context Menus##############################
if "%Tweak%" equ "EnableFMP3ProCodec" echo.####Applying Enable Fraunhofer MP3 Professional Codec Tweak####################
if "%Tweak%" equ "EnableFullResetBase" echo.####Applying Enable DISM Image Cleanup with Full ResetBase Tweak###############
if "%Tweak%" equ "EnableLocalAccount" echo.####Applying Enable Windows Local Account Tweak#################################
if "%Tweak%" equ "EnablePhotoViewer" echo.####Applying Enable Windows Photo Viewer Tweak#################################
if "%Tweak%" equ "ForceLatestNetFramework" echo.####Applying Force .NET Programs to Use Newest .NET Framework Tweak############
if "%Tweak%" equ "HideChatIcon" echo.####Applying Hide Taskbar Chat Icon Tweak######################################
if "%Tweak%" equ "HideCortanaIcon" echo.####Applying Hide Taskbar Cortana Icon Tweak###################################
if "%Tweak%" equ "HideMeetNowIcon" echo.####Applying Hide Taskbar Meet Now Icon Tweak##################################
if "%Tweak%" equ "HideNewsAndInterests" echo.####Applying Hide Taskbar News ^& Interest Tweak###############################
if "%Tweak%" equ "HideSearchBar" echo.####Applying Hide Taskbar Search Bar###########################################
if "%Tweak%" equ "HideTaskViewIcon" echo.####Applying Hide Taskbar TaskView Icon Tweak##################################
if "%Tweak%" equ "HideWidgetsIcon" echo.####Applying Hide Taskbar Widgets Icon Tweak###################################
echo.-------------------------------------------------------------------------------

rem ==========================================
rem DisableW11InstHardwareCheck start
rem ==========================================

if "%Tweak%" equ "DisableW11InstHardwareCheck" (
	echo.
	if not %%i gtr 9 echo.===========================[Boot.wim, Index : 2]============================
	echo.
	echo.Mounting Image Registry...
	echo.Applying Disable Windows 11 Installer Hardware Check Tweak...
	Reg load "HKLM\TK_BOOT_SYSTEM" "%BootMount%\2\Windows\System32\Config\SYSTEM" >nul 2>&1
	Reg add "HKLM\TK_BOOT_SYSTEM\Setup\LabConfig" /v "BypassCPUCheck" /t REG_DWORD /d "1" /f >nul 2>&1
	Reg add "HKLM\TK_BOOT_SYSTEM\Setup\LabConfig" /v "BypassRAMCheck" /t REG_DWORD /d "1" /f >nul 2>&1
	Reg add "HKLM\TK_BOOT_SYSTEM\Setup\LabConfig" /v "BypassSecureBootCheck" /t REG_DWORD /d "1" /f >nul 2>&1
	Reg add "HKLM\TK_BOOT_SYSTEM\Setup\LabConfig" /v "BypassStorageCheck" /t REG_DWORD /d "1" /f >nul 2>&1
	Reg add "HKLM\TK_BOOT_SYSTEM\Setup\LabConfig" /v "BypassTPMCheck" /t REG_DWORD /d "1" /f >nul 2>&1
	echo.Un-Mounting Image Registry...
	Reg unload "HKLM\TK_BOOT_SYSTEM" >nul 2>&1
	if exist "%DVD%\sources\appraiserres.dll" move "%DVD%\sources\appraiserres.dll" "%DVD%\sources\appraiserres.dll.bak"
)

for /l %%i in (1, 1, %ImageCount%) do (
	if exist "%InstallMount%\%%i" (
		echo.
		if not %%i gtr 9 echo.===========================[Install.wim, Index : %%i]============================
		if %%i gtr 9 echo.==========================[Install.wim, Index : %%i]============================
		echo.
		echo.Mounting Image Registry...
		call :MountImageRegistry "%InstallMount%\%%i"
		echo.Importing Registry Settings to Image Registry...


		if "%Tweak%" equ "DisableW11InstHardwareCheck" (
			Reg add "HKLM\TK_DEFAULT\Control Panel\UnsupportedHardwareNotificationCache" /v "SV1" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\Control Panel\UnsupportedHardwareNotificationCache" /v "SV2" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Control Panel\UnsupportedHardwareNotificationCache" /v "SV1" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Control Panel\UnsupportedHardwareNotificationCache" /v "SV2" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\Setup\LabConfig" /v "BypassCPUCheck" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\Setup\LabConfig" /v "BypassRAMCheck" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\Setup\LabConfig" /v "BypassSecureBootCheck" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\Setup\LabConfig" /v "BypassStorageCheck" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\Setup\LabConfig" /v "BypassTPMCheck" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\Setup\MoSetup" /v "AllowUpgradesWithUnsupportedTPMOrCPU" /t REG_DWORD /d "1" /f >nul 2>&1
		)

		if "%Tweak%" equ "DisableCortanaApp" (
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "DeviceHistoryEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "HistoryViewEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaIsReplaceable" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaIsReplaced" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI" /v "EnableCortana" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "DeviceHistoryEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "HistoryViewEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaIsReplaceable" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaIsReplaced" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\PolicyManager\current\device\AboveLock" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\PolicyManager\current\device\Experience" /v "AllowCortana" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchPrivacy" /t REG_DWORD /d "3" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchSafeSearch" /t REG_DWORD /d "3" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWebOverMeteredConnections" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Wow6432Node\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Wow6432Node\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana ActionUriServer.exe" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\ActionUriServer.exe|Name=Block Cortana ActionUriServer.exe|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana Package" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|Name=Block Cortana Package|Desc=Block Cortana Outbound UDP/TCP Traffic|AppPkgId=S-1-15-2-1861897761-1695161497-2927542615-642690995-327840285-2659745135-2630312742|Platform=2:6:2|Platform2=GTEQ|" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana PlacesServer.exe" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\PlacesServer.exe|Name=Block Cortana PlacesServer.exe|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana RemindersServer.exe" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\RemindersServer.exe|Name=Block Cortana RemindersServer.exe|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana RemindersShareTargetApp.exe" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\RemindersShareTargetApp.exe|Name=Block Cortana RemindersShareTargetApp.exe|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana SearchUI.exe" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\SearchUI.exe|Name=Block Cortana SearchUI.exe|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f >nul 2>&1
		)

		if "%Tweak%" equ "HideChatIcon" (
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /v "ChatIcon" /t REG_DWORD /d "3" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d "0" /f >nul 2>&1
		)

		if "%Tweak%" equ "HideCortanaIcon" Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCortanaButton" /t REG_DWORD /d "0" /f >nul 2>&1

		if "%Tweak%" equ "HideMeetNowIcon" (
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f >nul 2>&1
		)

		if "%Tweak%" equ "HideNewsAndInterests" (
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d "2" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d "0" /f >nul 2>&1
		)

		if "%Tweak%" equ "HideTaskViewIcon" Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d "0" /f >nul 2>&1
		if "%Tweak%" equ "HideSearchBar" Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1
		if "%Tweak%" equ "HideWidgetsIcon" Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d "0" /f >nul 2>&1

		if "%Tweak%" equ "DisableDriversUpdates" (
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "DontPromptForWindowsUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "DontSearchWindowsUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "DriverUpdateWizardWuSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
		)

		if "%Tweak%" equ "Disable3RDPartyApps" (
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f >nul 2>&1

			if "%SelectedSourceOS%" equ "w11" (
				Reg add "HKLM\TK_SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v "ConfigureStartPins" /t REG_SZ /d "{\"pinnedList\": [{}]}" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v "ConfigureStartPins_ProviderSet" /t REG_DWORD /d "0" /f >nul 2>&1
			)
		)

		if "%Tweak%" equ "DisableTeamsApp" Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v "ConfigureChatAutoInstall" /t REG_DWORD /d "0" /f >nul 2>&1

		if "%Tweak%" equ "DisableWindowsDefender" (
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows Security Health\State" /v "AccountProtection_MicrosoftAccount_Disconnected" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows Security Health\State" /v "AccountProtection_MicrosoftAccount_Disconnected" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender" /v "DisableAntiVirus" /t REG_DWORD /d "1" /f >nul 2>&1
			if "%SelectedSourceOS%" neq "w11" Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d "0" /f >nul 2>&1
			if "%SelectedSourceOS%" equ "w11" Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtectionSource" /t REG_DWORD /d "2" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender\Signature Updates" /v "FirstAuGracePeriod" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender\UX Configuration" /v "DisablePrivacyMode" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "SecurityHealth" /t REG_BINARY /d "030000000000000000000000" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray" /v "HideSystray" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender" /v "PUAProtection" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender" /v "RandomizeScheduleTaskTimes" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions" /v "DisableAutoExclusions" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine" /v "MpEnablePus" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Quarantine" /v "LocalSettingOverridePurgeItemsAfterDelay" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Quarantine" /v "PurgeItemsAfterDelay" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScriptScanning" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Remediation" /v "Scan_ScheduleDay" /t REG_DWORD /d "8" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Remediation" /v "Scan_ScheduleTime" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "AdditionalActionTimeOut" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "CriticalFailureTimeOut" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableGenericRePorts" /t REG_DWORD /d 1 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "NonCriticalTimeOut" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "AvgCPULoadFactor" /t REG_DWORD /d "10" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableArchiveScanning" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableCatchupFullScan" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableCatchupQuickScan" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableRemovableDriveScanning" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableRestorePoint" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableScanningMappedNetworkDrivesForFullScan" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableScanningNetworkFiles" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "PurgeItemsAfterDelay" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "ScanOnlyIfIdle" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "ScanParameters" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "ScheduleDay" /t REG_DWORD /d 8 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "ScheduleTime" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v "DisableUpdateOnStartupWithoutEngine" /t REG_DWORD /d 1 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v "ScheduleDay" /t REG_DWORD /d 8 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v "ScheduleTime" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v "SignatureUpdateCatchupInterval" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\SpyNet" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "LocalSettingOverrideSpynetReporting" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpyNetReporting" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpyNetReportingLocation" /t REG_MULTI_SZ /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\EventLog\System\Microsoft-Antimalware-ShieldProvider" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\EventLog\System\WinDefend" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\MsSecFlt" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\Sense" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\WdBoot" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\WdFilter" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\WdNisDrv" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\WdNisSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\WinDefend" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Control\WMI\Autologger\DefenderApiLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Control\WMI\Autologger\DefenderAuditLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
		)

		if "%Tweak%" equ "DisableWindowsFirewall" (
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "DisableFirewall" /t REG_SZ /d "%%windir%%\System32\netsh.exe advfirewall set allprofiles state off" /f >nul 2>&1
		)

		if "%Tweak%" equ "DisableWindowsSmartScreen" (
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "PreventOverride" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "PreventOverride" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Security Health\State" /v "AppAndBrowser_StoreAppsSmartScreenOff" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Internet Explorer\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Internet Explorer\PhishingFilter" /v "PreventOverride" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "PreventOverride" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /v "ConfigureAppInstallControl" /t REG_SZ /d "Anywhere" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /v "ConfigureAppInstallControlEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
		)

		if "%Tweak%" equ "DisableWindowsUpgrade" (
			if "%SelectedSourceOS%" neq "w10" if "%SelectedSourceOS%" neq "w11" (
				Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Gwx" /v "DisableGwx" /t REG_DWORD /d "1" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableOSUpgrade" /t REG_DWORD /d "1" /f >nul 2>&1
			)

			if "%SelectedSourceOS%" neq "w7" if "%SelectedSourceOS%" neq "w81" (
				Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpdatePeriod" /t REG_DWORD /d "1" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgrade" /t REG_DWORD /d "1" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgradePeriod" /t REG_DWORD /d "1" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersion" /t REG_DWORD /d "1" /f >nul 2>&1
				if "%ImageBuild%" geq "17134" if "%ImageBuild%" leq "20348" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ProductVersion" /t REG_SZ /d "Windows 10" /f >nul 2>&1
				if "%ImageBuild%" equ "17134" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "1803" /f >nul 2>&1
				if "%ImageBuild%" equ "17763" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "1809" /f >nul 2>&1
				if "%ImageBuild%" equ "18362" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "1903" /f >nul 2>&1
				if "%ImageBuild%" equ "18363" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "1909" /f >nul 2>&1
				if "%ImageBuild%" equ "19041" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "2004" /f >nul 2>&1
				if "%ImageBuild%" equ "19042" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "2009" /f >nul 2>&1
				if "%ImageBuild%" equ "19043" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "21H1" /f >nul 2>&1
				if "%ImageBuild%" equ "19044" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "21H2" /f >nul 2>&1
				if "%ImageBuild%" equ "19045" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "22H2" /f >nul 2>&1
				if "%ImageBuild%" equ "20348" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "21H2" /f >nul 2>&1
				if "%ImageBuild%" equ "22000" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "21H2" /f >nul 2>&1
				if "%ImageBuild%" geq "22621" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "22H2" /f >nul 2>&1
				if "%ImageBuild%" equ "22622" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "22H2" /f >nul 2>&1
				if "%ImageBuild%" equ "22623" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "22H2" /f >nul 2>&1
			)
		)

		if "%Tweak%" equ "DisableWindowsUpdate" (
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "OptInOOBE" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /v "AutoDownload" /t REG_DWORD /d "5" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d" /v "RegisteredWithAU" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-DeviceUpdateAgent/Operational" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-WindowsUpdateClient/Operational]" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "HideMCTLink" /t REG_DWORD /d "1" /f >nul 2>&1

			if "%ImageDefaultLanguage%" equ "zh-CN" Reg add "HKLM\TK_SOFTWARE\Microsoft\LexiconUpdate\loc_0804" /v "HapDownloadEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			if "%ImageDefaultLanguage%" equ "zh-HK" Reg add "HKLM\TK_SOFTWARE\Microsoft\LexiconUpdate\loc_0804" /v "HapDownloadEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			if "%ImageDefaultLanguage%" equ "zh-TW" Reg add "HKLM\TK_SOFTWARE\Microsoft\LexiconUpdate\loc_0804" /v "HapDownloadEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableWindowsUpdateAccess" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUServer" /t REG_SZ /d " " /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUStatusServer" /t REG_SZ /d " " /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "UpdateServiceUrlAlternate" /t REG_SZ /d " " /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\wuauserv" /v "Start" /t REG_DWORD /d "3" /f >nul 2>&1
		)

		if "%Tweak%" equ "DisableReservedStorage" Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "ShippedWithReserves" /t REG_DWORD /d "0" /f >nul 2>&1
		if "%Tweak%" equ "ForceLatestNetFramework" Reg add "HKLM\TK_SOFTWARE\Microsoft\.NETFramework" /v "OnlyUseLatestCLR" /t REG_DWORD /d "1" /f >nul 2>&1
		if "%Tweak%" equ "EnableLocalAccount" Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v "BypassNRO" /t REG_DWORD /d "1" /f >nul 2>&1

		if "%Tweak%" equ "EnablePhotoViewer" (
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "emffile_.emf" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "rlefile_.rle" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "wmffile_.wmf" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "GlobalAssocChangedCounter" /t REG_DWORD /d "13" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bmp\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bmp\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bmp\UserChoice" /v "Hash" /t REG_SZ /d "TDU75KWAGi4=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bmp\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dib\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dib\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dib\UserChoice" /v "Hash" /t REG_SZ /d "hAQpLYJfRYE=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dib\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.gif\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.gif\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.gif\UserChoice" /v "Hash" /t REG_SZ /d "1in4hcmDrB4=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.gif\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Gif" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jfif\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jfif\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jfif\UserChoice" /v "Hash" /t REG_SZ /d "Y5upkzp3g5E=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jfif\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.JFIF" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpe\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpe\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpe\UserChoice" /v "Hash" /t REG_SZ /d "ZIeqfdrNtFk=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpe\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpeg\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpeg\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpeg\UserChoice" /v "Hash" /t REG_SZ /d "iVWM3EAePKw=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpeg\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\UserChoice" /v "Hash" /t REG_SZ /d "Xq9gH4jXoFM=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jxr\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jxr\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jxr\UserChoice" /v "Hash" /t REG_SZ /d "ahz7f/Yl09M=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jxr\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.png\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.png\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.png\UserChoice" /v "Hash" /t REG_SZ /d "Evm7jp++AWA=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.png\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Png" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tif\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tif\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tif\UserChoice" /v "Hash" /t REG_SZ /d "wEj9gLqtYH4=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tif\UserChoice" /v "ProgId" /t REG_SZ /d "TIFImage.Document" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tiff\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tiff\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tiff\UserChoice" /v "Hash" /t REG_SZ /d "/r2V12Yryig=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tiff\UserChoice" /v "ProgId" /t REG_SZ /d "TIFImage.Document" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.wdp\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.wdp\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.wdp\UserChoice" /v "Hash" /t REG_SZ /d "/qcrPB0bhuI=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.wdp\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.bmp\UserChoice" /v "Hash" /t REG_SZ /d "rEigxhAPyos=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.bmp\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.dib\UserChoice" /v "Hash" /t REG_SZ /d "R60f5QZs3Hg=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.dib\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.gif\UserChoice" /v "Hash" /t REG_SZ /d "YcQO9pssSPU=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.gif\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Gif" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jfif\UserChoice" /v "Hash" /t REG_SZ /d "5yjvWKb+Jns=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jfif\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.JFIF" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpe\UserChoice" /v "Hash" /t REG_SZ /d "TujD2rCi+po=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpe\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpeg\UserChoice" /v "Hash" /t REG_SZ /d "wdZ9wQI4vW8=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpeg\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpg\UserChoice" /v "Hash" /t REG_SZ /d "3xY0V0JOiFc=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpg\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jxr\UserChoice" /v "Hash" /t REG_SZ /d "ENXEd5Uzg84=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jxr\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.png\UserChoice" /v "Hash" /t REG_SZ /d "SPesrUKrIFE=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.png\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Png" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.tif\UserChoice" /v "Hash" /t REG_SZ /d "bCXQRSAHD/I=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.tif\UserChoice" /v "ProgId" /t REG_SZ /d "TIFImage.Document" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.tiff\UserChoice" /v "Hash" /t REG_SZ /d "7F/LfjhVnes=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.tiff\UserChoice" /v "ProgId" /t REG_SZ /d "TIFImage.Document" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.wdp\UserChoice" /v "Hash" /t REG_SZ /d "tu0JqOen+Es=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.wdp\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\Applications\photoviewer.dll\shell\open" /v "MuiVerb" /t REG_SZ /d "@photoviewer.dll,-3043" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\DropTarget" /v "Clsid" /t REG_SZ /d "{60fd46de-f830-4894-a628-6fa81bc0190d}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3056" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-70" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3057" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-83" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" /v "EditFlags" /t REG_DWORD /d "65536" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3055" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-72" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" /v "EditFlags" /t REG_DWORD /d "65536" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3055" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-72" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Png" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3057" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Png" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-71" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3058" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-122" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp" /v "EditFlags" /t REG_DWORD /d "65536" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\wmphoto.dll,-400" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" /v "ApplicationDescription" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3069" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" /v "ApplicationName" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3009" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".bmp" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".dib" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".gif" /t REG_SZ /d "PhotoViewer.FileAssoc.Gif" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jfif" /t REG_SZ /d "PhotoViewer.FileAssoc.JFIF" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpe" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpeg" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpg" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jxr" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".png" /t REG_SZ /d "PhotoViewer.FileAssoc.Png" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".tif" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".tiff" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".wdp" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f >nul 2>&1
		)

		if "%Tweak%" equ "EnableClassicContextMenu" Reg add "HKLM\TK_SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /f >nul 2>&1

		if "%Tweak%" equ "EnableFMP3ProCodec" (
			Reg delete "HKLM\TK_SOFTWARE\Microsoft\Windows NT\CurrentVersion\drivers.desc" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows NT\CurrentVersion\drivers.desc" /v "%%SystemRoot%%\System32\l3codecp.acm" /t REG_SZ /d "Fraunhofer IIS MPEG Layer-3 Codec (Professional)" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32" /v "msacm.l3acm" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\l3codecp.acm" /f >nul 2>&1

			if "%ImageArchitecture%" equ "x64" (
				Reg delete "HKLM\TK_SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\drivers.desc" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\drivers.desc" /v "%%SystemRoot%%\SysWOW64\l3codecp.acm" /t REG_SZ /d "Fraunhofer IIS MPEG Layer-3 Codec (Professional)" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Drivers32" /v "msacm.l3acm" /t REG_EXPAND_SZ /d "%%SystemRoot%%\SysWOW64\l3codecp.acm" /f >nul 2>&1
			)
		)

		if "%Tweak%" equ "EnableFullResetBase" Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "DisableResetbase" /t REG_DWORD /d "0" /f >nul 2>&1

		if "%Tweak%" equ "AllTweaks" (
			if "%SelectedSourceOS%" equ "w11" Reg add "HKLM\TK_SYSTEM\Setup\MoSetup" /v "AllowUpgradesWithUnsupportedTPMOrCPU" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "DeviceHistoryEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "HistoryViewEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaIsReplaceable" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaIsReplaced" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI" /v "EnableCortana" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "DeviceHistoryEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "HistoryViewEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaIsReplaceable" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaIsReplaced" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\PolicyManager\current\device\AboveLock" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\PolicyManager\current\device\Experience" /v "AllowCortana" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchPrivacy" /t REG_DWORD /d "3" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchSafeSearch" /t REG_DWORD /d "3" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWebOverMeteredConnections" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Wow6432Node\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Wow6432Node\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana ActionUriServer.exe" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\ActionUriServer.exe|Name=Block Cortana ActionUriServer.exe|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana Package" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|Name=Block Cortana Package|Desc=Block Cortana Outbound UDP/TCP Traffic|AppPkgId=S-1-15-2-1861897761-1695161497-2927542615-642690995-327840285-2659745135-2630312742|Platform=2:6:2|Platform2=GTEQ|" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana PlacesServer.exe" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\PlacesServer.exe|Name=Block Cortana PlacesServer.exe|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana RemindersServer.exe" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\RemindersServer.exe|Name=Block Cortana RemindersServer.exe|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana RemindersShareTargetApp.exe" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\RemindersShareTargetApp.exe|Name=Block Cortana RemindersShareTargetApp.exe|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana SearchUI.exe" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\SearchUI.exe|Name=Block Cortana SearchUI.exe|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /v "ChatIcon" /t REG_DWORD /d "3" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCortanaButton" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d "2" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1
			if "%SelectedSourceOS%" equ "w11" Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "DontPromptForWindowsUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "DontSearchWindowsUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "DriverUpdateWizardWuSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f >nul 2>&1

			if "%SelectedSourceOS%" equ "w11" (
				Reg add "HKLM\TK_SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v "ConfigureStartPins" /t REG_SZ /d "{\"pinnedList\": [{}]}" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v "ConfigureStartPins_ProviderSet" /t REG_DWORD /d "0" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v "ConfigureChatAutoInstall" /t REG_DWORD /d "0" /f >nul 2>&1
			)

			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows Security Health\State" /v "AccountProtection_MicrosoftAccount_Disconnected" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows Security Health\State" /v "AccountProtection_MicrosoftAccount_Disconnected" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender" /v "DisableAntiVirus" /t REG_DWORD /d "1" /f >nul 2>&1
			if "%SelectedSourceOS%" neq "w11" Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d "0" /f >nul 2>&1
			if "%SelectedSourceOS%" equ "w11" Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtectionSource" /t REG_DWORD /d "2" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender\Signature Updates" /v "FirstAuGracePeriod" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender\UX Configuration" /v "DisablePrivacyMode" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "SecurityHealth" /t REG_BINARY /d "030000000000000000000000" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray" /v "HideSystray" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender" /v "PUAProtection" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender" /v "RandomizeScheduleTaskTimes" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions" /v "DisableAutoExclusions" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine" /v "MpEnablePus" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Quarantine" /v "LocalSettingOverridePurgeItemsAfterDelay" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Quarantine" /v "PurgeItemsAfterDelay" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScriptScanning" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Remediation" /v "Scan_ScheduleDay" /t REG_DWORD /d "8" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Remediation" /v "Scan_ScheduleTime" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "AdditionalActionTimeOut" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "CriticalFailureTimeOut" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableGenericRePorts" /t REG_DWORD /d 1 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "NonCriticalTimeOut" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "AvgCPULoadFactor" /t REG_DWORD /d "10" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableArchiveScanning" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableCatchupFullScan" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableCatchupQuickScan" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableRemovableDriveScanning" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableRestorePoint" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableScanningMappedNetworkDrivesForFullScan" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableScanningNetworkFiles" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "PurgeItemsAfterDelay" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "ScanOnlyIfIdle" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "ScanParameters" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "ScheduleDay" /t REG_DWORD /d 8 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "ScheduleTime" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v "DisableUpdateOnStartupWithoutEngine" /t REG_DWORD /d 1 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v "ScheduleDay" /t REG_DWORD /d 8 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v "ScheduleTime" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v "SignatureUpdateCatchupInterval" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\SpyNet" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "LocalSettingOverrideSpynetReporting" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpyNetReporting" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpyNetReportingLocation" /t REG_MULTI_SZ /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\EventLog\System\Microsoft-Antimalware-ShieldProvider" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\EventLog\System\WinDefend" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\MsSecFlt" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\Sense" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\WdBoot" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\WdFilter" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\WdNisDrv" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\WdNisSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\WinDefend" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Control\WMI\Autologger\DefenderApiLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Control\WMI\Autologger\DefenderAuditLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "DisableFirewall" /t REG_SZ /d "%%windir%%\System32\netsh.exe advfirewall set allprofiles state off" /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "PreventOverride" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_DEFAULT\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "PreventOverride" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Security Health\State" /v "AppAndBrowser_StoreAppsSmartScreenOff" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Internet Explorer\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Internet Explorer\PhishingFilter" /v "PreventOverride" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "PreventOverride" /t REG_DWORD /d 0 /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /v "ConfigureAppInstallControl" /t REG_SZ /d "Anywhere" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /v "ConfigureAppInstallControlEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

			if "%SelectedSourceOS%" neq "w10" if "%SelectedSourceOS%" neq "w11" (
				Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Gwx" /v "DisableGwx" /t REG_DWORD /d "1" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableOSUpgrade" /t REG_DWORD /d "1" /f >nul 2>&1
			)

			if "%SelectedSourceOS%" neq "w7" if "%SelectedSourceOS%" neq "w81" (
				Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpdatePeriod" /t REG_DWORD /d "1" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgrade" /t REG_DWORD /d "1" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgradePeriod" /t REG_DWORD /d "1" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersion" /t REG_DWORD /d "1" /f >nul 2>&1
				if "%ImageBuild%" geq "17134" if "%ImageBuild%" leq "20348" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ProductVersion" /t REG_SZ /d "Windows 10" /f >nul 2>&1
				if "%ImageBuild%" equ "17134" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "1803" /f >nul 2>&1
				if "%ImageBuild%" equ "17763" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "1809" /f >nul 2>&1
				if "%ImageBuild%" equ "18362" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "1903" /f >nul 2>&1
				if "%ImageBuild%" equ "18363" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "1909" /f >nul 2>&1
				if "%ImageBuild%" equ "19041" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "2004" /f >nul 2>&1
				if "%ImageBuild%" equ "19042" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "2009" /f >nul 2>&1
				if "%ImageBuild%" equ "19043" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "21H1" /f >nul 2>&1
				if "%ImageBuild%" equ "19044" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "21H2" /f >nul 2>&1
				if "%ImageBuild%" equ "19045" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "22H2" /f >nul 2>&1
				if "%ImageBuild%" equ "20348" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "21H2" /f >nul 2>&1
				if "%ImageBuild%" equ "22000" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "21H2" /f >nul 2>&1
				if "%ImageBuild%" geq "22621" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "22H2" /f >nul 2>&1
				if "%ImageBuild%" equ "22622" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "22H2" /f >nul 2>&1
				if "%ImageBuild%" equ "22623" Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "22H2" /f >nul 2>&1
			)

			Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "OptInOOBE" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /v "AutoDownload" /t REG_DWORD /d "2" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d" /v "RegisteredWithAU" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-DeviceUpdateAgent/Operational" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-WindowsUpdateClient/Operational]" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "HideMCTLink" /t REG_DWORD /d "1" /f >nul 2>&1
			if "%ImageDefaultLanguage%" equ "zh-CN" Reg add "HKLM\TK_SOFTWARE\Microsoft\LexiconUpdate\loc_0804" /v "HapDownloadEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			if "%ImageDefaultLanguage%" equ "zh-HK" Reg add "HKLM\TK_SOFTWARE\Microsoft\LexiconUpdate\loc_0804" /v "HapDownloadEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			if "%ImageDefaultLanguage%" equ "zh-TW" Reg add "HKLM\TK_SOFTWARE\Microsoft\LexiconUpdate\loc_0804" /v "HapDownloadEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableWindowsUpdateAccess" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUServer" /t REG_SZ /d " " /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUStatusServer" /t REG_SZ /d " " /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "UpdateServiceUrlAlternate" /t REG_SZ /d " " /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\wuauserv" /v "Start" /t REG_DWORD /d "3" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "ShippedWithReserves" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\.NETFramework" /v "OnlyUseLatestCLR" /t REG_DWORD /d "1" /f >nul 2>&1
			if "%SelectedSourceOS%" equ "w11" Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v "BypassNRO" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "emffile_.emf" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "rlefile_.rle" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "wmffile_.wmf" /t REG_DWORD /d "0" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "GlobalAssocChangedCounter" /t REG_DWORD /d "13" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bmp\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bmp\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bmp\UserChoice" /v "Hash" /t REG_SZ /d "TDU75KWAGi4=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bmp\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dib\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dib\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dib\UserChoice" /v "Hash" /t REG_SZ /d "hAQpLYJfRYE=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dib\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.gif\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.gif\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.gif\UserChoice" /v "Hash" /t REG_SZ /d "1in4hcmDrB4=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.gif\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Gif" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jfif\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jfif\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jfif\UserChoice" /v "Hash" /t REG_SZ /d "Y5upkzp3g5E=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jfif\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.JFIF" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpe\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpe\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpe\UserChoice" /v "Hash" /t REG_SZ /d "ZIeqfdrNtFk=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpe\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpeg\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpeg\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpeg\UserChoice" /v "Hash" /t REG_SZ /d "iVWM3EAePKw=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpeg\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\UserChoice" /v "Hash" /t REG_SZ /d "Xq9gH4jXoFM=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jxr\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jxr\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jxr\UserChoice" /v "Hash" /t REG_SZ /d "ahz7f/Yl09M=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jxr\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.png\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.png\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.png\UserChoice" /v "Hash" /t REG_SZ /d "Evm7jp++AWA=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.png\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Png" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tif\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tif\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tif\UserChoice" /v "Hash" /t REG_SZ /d "wEj9gLqtYH4=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tif\UserChoice" /v "ProgId" /t REG_SZ /d "TIFImage.Document" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tiff\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tiff\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tiff\UserChoice" /v "Hash" /t REG_SZ /d "/r2V12Yryig=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tiff\UserChoice" /v "ProgId" /t REG_SZ /d "TIFImage.Document" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.wdp\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.wdp\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.wdp\UserChoice" /v "Hash" /t REG_SZ /d "/qcrPB0bhuI=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.wdp\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.bmp\UserChoice" /v "Hash" /t REG_SZ /d "rEigxhAPyos=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.bmp\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.dib\UserChoice" /v "Hash" /t REG_SZ /d "R60f5QZs3Hg=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.dib\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.gif\UserChoice" /v "Hash" /t REG_SZ /d "YcQO9pssSPU=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.gif\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Gif" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jfif\UserChoice" /v "Hash" /t REG_SZ /d "5yjvWKb+Jns=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jfif\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.JFIF" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpe\UserChoice" /v "Hash" /t REG_SZ /d "TujD2rCi+po=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpe\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpeg\UserChoice" /v "Hash" /t REG_SZ /d "wdZ9wQI4vW8=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpeg\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpg\UserChoice" /v "Hash" /t REG_SZ /d "3xY0V0JOiFc=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpg\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jxr\UserChoice" /v "Hash" /t REG_SZ /d "ENXEd5Uzg84=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jxr\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.png\UserChoice" /v "Hash" /t REG_SZ /d "SPesrUKrIFE=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.png\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Png" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.tif\UserChoice" /v "Hash" /t REG_SZ /d "bCXQRSAHD/I=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.tif\UserChoice" /v "ProgId" /t REG_SZ /d "TIFImage.Document" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.tiff\UserChoice" /v "Hash" /t REG_SZ /d "7F/LfjhVnes=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.tiff\UserChoice" /v "ProgId" /t REG_SZ /d "TIFImage.Document" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.wdp\UserChoice" /v "Hash" /t REG_SZ /d "tu0JqOen+Es=" /f >nul 2>&1
			Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.wdp\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\Applications\photoviewer.dll\shell\open" /v "MuiVerb" /t REG_SZ /d "@photoviewer.dll,-3043" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\DropTarget" /v "Clsid" /t REG_SZ /d "{60fd46de-f830-4894-a628-6fa81bc0190d}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3056" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-70" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3057" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-83" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" /v "EditFlags" /t REG_DWORD /d "65536" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3055" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-72" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" /v "EditFlags" /t REG_DWORD /d "65536" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3055" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-72" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Png" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3057" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Png" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-71" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3058" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-122" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp" /v "EditFlags" /t REG_DWORD /d "65536" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\wmphoto.dll,-400" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" /v "ApplicationDescription" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3069" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" /v "ApplicationName" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3009" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".bmp" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".dib" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".gif" /t REG_SZ /d "PhotoViewer.FileAssoc.Gif" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jfif" /t REG_SZ /d "PhotoViewer.FileAssoc.JFIF" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpe" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpeg" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpg" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jxr" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".png" /t REG_SZ /d "PhotoViewer.FileAssoc.Png" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".tif" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".tiff" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".wdp" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /f >nul 2>&1
			Reg delete "HKLM\TK_SOFTWARE\Microsoft\Windows NT\CurrentVersion\drivers.desc" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows NT\CurrentVersion\drivers.desc" /v "%%SystemRoot%%\System32\l3codecp.acm" /t REG_SZ /d "Fraunhofer IIS MPEG Layer-3 Codec (Professional)" /f >nul 2>&1
			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32" /v "msacm.l3acm" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\l3codecp.acm" /f >nul 2>&1

			if "%ImageArchitecture%" equ "x64" (
				Reg delete "HKLM\TK_SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\drivers.desc" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\drivers.desc" /v "%%SystemRoot%%\SysWOW64\l3codecp.acm" /t REG_SZ /d "Fraunhofer IIS MPEG Layer-3 Codec (Professional)" /f >nul 2>&1
				Reg add "HKLM\TK_SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Drivers32" /v "msacm.l3acm" /t REG_EXPAND_SZ /d "%%SystemRoot%%\SysWOW64\l3codecp.acm" /f >nul 2>&1
			)

			Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "DisableResetbase" /t REG_DWORD /d "0" /f >nul 2>&1
		)

		echo.Un-Mounting Image Registry...
		call :UnMountImageRegistry
	)
)

echo.
echo.-------------------------------------------------------------------------------
echo.####Finished Applying Tweaks###################################################
echo.-------------------------------------------------------------------------------

:Stop
echo.
echo.===============================================================================
echo.
pause

set Tweaks=

endlocal

:: Returning to Apply Tweaks Menu
goto :ApplyTweaksMenu