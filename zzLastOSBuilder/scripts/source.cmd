rem source.cmd
@echo off
rem Win11 script
set scriptver=0.0.8
title %~nx0  v%scriptver%

rem This first for routine will give the current path without a trailing \
@REM %~d0
@REM cd "%~dp0"
@REM cd %~dps0
@REM for %%f in ("%CD%") do set CP=%%~sf
@REM rem CPS= CP Scripts
@REM set CPS=%CP%\scripts
echo cps = %CPS%
echo cp = %CP%
@REM echo MCTool = %MCTool%
set "MCTool=%CP%\MCT"
echo MCTool = %MCTool%

pause

::-------------------------------------------------------------------------------------------
:: LastOS Toolkit - Select Source Menu
::-------------------------------------------------------------------------------------------
:SourceMenu

cls
echo.===============================================================================
echo.                         LastOS ToolKit Builder - Source Menu
echo.                           v%BuilderVersion% 
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
echo.  [7]   Download Windows 11 ISO from Microsoft
echo.
echo.  [8]   Download Windows ISO from Microsoft
echo.
echo.
echo.
echo.
echo.  [X]   Go Back
echo.
echo.===============================================================================
echo.
choice /C:12345678X /N /M "Enter Your Choice : "
if errorlevel 9 goto :MainMenu
if errorlevel 8 goto :DownloadMS
if errorlevel 7 goto :Downloadwin11
if errorlevel 6 goto :ExtractSourceESD
if errorlevel 5 goto :ExtractSourceStoreESD
if errorlevel 4 goto :ExtractSourceIMG
if errorlevel 3 goto :ExtractSourceISO
if errorlevel 2 goto :CopySourceDVD
if errorlevel 1 goto :SelectSourceDVD
::-------------------------------------------------------------------------------------------


::-------------------------------------------------------------------------------------------
:: LastOS Toolkit - Select Source from <DVD> folder
::-------------------------------------------------------------------------------------------
:SelectSourceDVD

cls
echo.===============================================================================
echo.               LastOS ToolKit - Select Source from ^<DVD^> folder
echo.===============================================================================
echo.

:: Checking whether Windows Source Boot Image exist
if not exist "%BootWim%" (
	echo.Can't find Windows Setup "Boot.wim" Image in ^<DVD\Sources^> folder...
	echo.
	echo.Please copy Windows Setup "Boot.wim" Image to ^<DVD\Sources^> folder...
	goto :Stop
)

:: Checking whether Windows Source Install Image is a ESD Image
if exist "%InstallEsd%" (
	echo.ToolKit found Windows Installation image in a .esd format, an ESD image
	echo.is a highly compressed image which cannot be directly serviced.
	echo.
	echo.The Toolkit requires the Windows Installation image to be in a .wim
	echo.format for servciing.
	echo.
	echo.Please use a Windows Installation image in a .wim format or use the
	echo.Extract Source from Store ESD Image menu from Source menu.
	goto :Stop
)

:: Checking whether Windows Source Install Image exist
if not exist "%InstallWim%" (
	echo.Can't find Windows Setup "Install.wim" Image in ^<DVD\Sources^> folder...
	echo.
	echo.Please copy Windows Setup "Install.wim" Image to ^<DVD\Sources^> folder...
	goto :Stop
)

echo.-------------------------------------------------------------------------------
echo.####Selecting Source Images####################################################
echo.-------------------------------------------------------------------------------

:: Getting Image Index Number to Service
call :GetImageIndexNo "%InstallWim%"

:: Checking for Image Index Validation
if not defined ImageIndexNo (
	echo.
	echo.Invalid Index # Entered, Valid Range is [1,...%ImageCount%, 'A'll, 'Q'uit]
	echo.
	pause
	goto :SelectSourceDVD
)

if /i "%ImageIndexNo%" equ "A" (
	set "ImageIndexNo=1"
    for /l %%i in (2, 1, %ImageCount%) do (
        set "ImageIndexNo=!ImageIndexNo!,%%i"
    )
)

if /i "%ImageIndexNo%" equ "Q" (
   set ImageIndexNo=
   goto :MainMenu
)

:: Setting the default Image Index No
for /f "tokens=1 delims=," %%a in ("!ImageIndexNo!") do (set DefaultIndexNo=%%a)

:: Getting first Image Index Information
call :GetImageIndexInfo "%InstallWim%", %DefaultIndexNo% >nul

:: Setting selected Source OS version
if "%ImageVersion%" equ "6.1.7601" set "SelectedSourceOS=w7"
if "%ImageVersion%" equ "6.3.9600" set "SelectedSourceOS=w81"

if "%ImageVersion:~0,-6%" equ "10.0" (
   if "%ImageBuild%" leq "20348" (
       set "SelectedSourceOS=w10"
       set "OSID=10"
   )
   if "%ImageBuild%" geq "22000" (
       set "SelectedSourceOS=w11"
       set "OSID=11"
   )
)

if "%ImageVersion:~0,-6%" equ "11.0" (
   set "SelectedSourceOS=w11"
   set "OSID=11"
)

:: Setting Package Service Pack Build, Version and Service Pack Build 
if "%SelectedSourceOS%" equ "w7" set "PackageServicePackBuild=17514"
if "%SelectedSourceOS%" equ "w81" set "PackageServicePackBuild=16384"

if "%SelectedSourceOS%" equ "w10" (
   if "%ImageBuild%" geq "10240" if "%ImageBuild%" leq "15063" (
       set "PackageBuild=%ImageBuild%"
       set "PackageVersion=10.0.%ImageBuild%"
       set "PackageServicePackBuild=0"
   )
   if "%ImageBuild%" equ "16299" (
		set "PackageBuild=16299"
		set "PackageVersion=10.0.16299"
		set "PackageServicePackBuild=15"
	)
	if "%ImageBuild%" geq "17134" if "%ImageBuild%" leq "17763" (
       set "PackageBuild=%ImageBuild%"
       set "PackageVersion=10.0.%ImageBuild%"
       set "PackageServicePackBuild=1"
   )
	if "%ImageBuild%" geq "18362" if "%ImageBuild%" leq "18363" (
		set "PackageBuild=18362"
		set "PackageVersion=10.0.18362"
		set "PackageServicePackBuild=1"
	)
	if "%ImageBuild%" geq "19041" if "%ImageBuild%" leq "19045" (
		set "PackageBuild=19041"
		set "PackageVersion=10.0.19041"
		set "PackageServicePackBuild=1"
	)
	if "%ImageBuild%" equ "20348" (
		set "PackageBuild=%ImageBuild%"
		set "PackageVersion=10.0.%ImageBuild%"
		set "PackageServicePackBuild=1"
	)
)

if "%SelectedSourceOS%" equ "w11" (
	if "%ImageBuild%" geq "22000" (
		set "PackageBuild=%ImageBuild%"
		set "PackageVersion=10.0.%ImageBuild%"
		set "PackageServicePackBuild=1"
	)
)

:: Setting Package Index and Architecture
if "%ImageArchitecture%" equ "x86" (
   set "PackageIndex=1"
   set "PackageArchitecture=x86"
)
if "%ImageArchitecture%" equ "x64" (
   set "PackageIndex=2"
   set "PackageArchitecture=amd64"
)
if "%ImageArchitecture%" equ "arm" (
   set "PackageIndex=3"
   set "PackageArchitecture=arm"
)
if "%ImageArchitecture%" equ "arm64" (
   set "PackageIndex=4"
   set "PackageArchitecture=arm64"
)

:: Checking whether the HOST OS is Windows 7 and selected Source OS is Windows 10/11
if "%HostVersion%" equ "6.1" if "%SelectedSourceOS%" neq "w7" if "%SelectedSourceOS%" neq "w81" (
    echo.
    echo.ToolKit cannot service Windows 10/11 Source OS on Windows 7 HOST OS...
    echo.
    echo.ToolKit requires a Windows 8.1/10/11 HOST OS for servicing Windows 10/11 Source OS...
    goto :Stop
)

echo.
choice /C:YN /N /M "Do you want to mount Windows Setup Boot Image ? ['Y'es/'N'o] : "
if errorlevel 2 set "IsBootImageSelected=No"
if errorlevel 1 set "IsBootImageSelected=Yes"

choice /C:YN /N /M "Do you want to mount Windows Recovery Image ? ['Y'es/'N'o] : "
if errorlevel 2 set "IsRecoveryImageSelected=No"
if errorlevel 1 set "IsRecoveryImageSelected=Yes"

echo.
echo.-------------------------------------------------------------------------------
echo.####Source Image Information###################################################
echo.-------------------------------------------------------------------------------
echo.
echo.    Image                    :  Install.wim
echo.    Image Index No           :  %ImageIndexNo%
echo.    Image Architecture       :  %ImageArchitecture%
echo.    Image Version            :  %ImageVersion%
echo.    Image Service Pack Build :  %ImageServicePackBuild%
echo.    Image Service Pack Level :  %ImageServicePackLevel%
echo.    Image Build              :  %ImageBuild%
echo.    Image Default Language   :  %ImageDefaultLanguage%
echo.
echo.-------------------------------------------------------------------------------
echo.####Mounting Source Images#####################################################
echo.-------------------------------------------------------------------------------
echo.
:: Mounting Source Boot Image Index to Service
if "%IsBootImageSelected%" equ "Yes" (
   for /l %%i in (1, 1, 2) do (
	   call :CreateFolder "%BootMount%\%%i"

       echo.-------------------------------------------------------------------------------
       echo.Mounting [Boot.wim, Index : %%i] Image at ^<\Mount\Boot\%%i^>...
       echo.-------------------------------------------------------------------------------
       call :MountImage "%BootWim%", %%i, "%BootMount%\%%i"
   )
)

:: Mounting Source Install & Recovery Images Index to Service
for %%i in (%ImageIndexNo%) do (
	call :CreateFolder "%InstallMount%\%%i"

	:: Mounting Source Install Image Indexes to Service
	echo.-------------------------------------------------------------------------------
	echo.Mounting [Install.wim, Index : %%i] Image at ^<\Mount\Install\%%i^>...
	echo.-------------------------------------------------------------------------------
	call :MountImage "%InstallWim%", %%i, "%InstallMount%\%%i"
)

if "%IsRecoveryImageSelected%" equ "Yes" (
	call :CreateFolder "%WinReMount%"

	:: Mounting Source Recovery Image Indexes to Service
	echo.-------------------------------------------------------------------------------
	echo.Mounting [Install.wim, Index : %DefaultIndexNo% -^> WinRE.wim] Image at ^<\Mount\WinRE^>...
	echo.-------------------------------------------------------------------------------
	call :MountImage "%InstallMount%\%DefaultIndexNo%\%WinReWim%", 1, "%WinReMount%"
)

echo.-------------------------------------------------------------------------------
echo.####Finished Selecting ^& Mounting Source Images################################
echo.-------------------------------------------------------------------------------

set "IsSourceSelected=Yes"

:Stop
echo.
echo.===============================================================================
echo.
pause

goto :MainMenu
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: LastOS Toolkit - Copy Source from DVD Drive to ^<DVD^> folder
::-------------------------------------------------------------------------------------------
:CopySourceDVD

setlocal

set DriveLetter=

cls
echo.===============================================================================
echo.          LastOS ToolKit - Copy Source from DVD Drive to ^<DVD^> folder
echo.===============================================================================
echo.

:: Checking whether Windows Source DVD folder is empty
if exist "%DVD%\sources\*.wim" (
	echo.Toolkit's Source ^<DVD^> folder is not empty...
	echo.
	choice /C:YN /N /M "Do you want to remove it & continue ? ['Y'es/'N'o] : "
	if errorlevel 2 goto :Stop
)

echo.-------------------------------------------------------------------------------
echo.####Starting Copying Source from DVD Drive to ^<DVD^> folder#####################
echo.-------------------------------------------------------------------------------
echo.
echo.-------------------------------------------------------------------------------
echo.####Getting DVD Drive Options##################################################
echo.-------------------------------------------------------------------------------
echo.
:: Getting DVD Drive Letter
set /p DriveLetter=Enter DVD Drive Letter : 

:: Setting DVD Drive Letter
set "DriveLetter=%DriveLetter%:"
echo.

:: Checking whether the specified DVD Drive letter is empty
if not exist "%DriveLetter%\sources\boot.wim" (
	echo.Can't find Windows OS Installation files in the specified Drive Letter..
	echo.
	echo.Please enter the correct DVD Drive Letter..
	goto :Stop
)

:: Checking whether the specified DVD Drive Letter is empty
if not exist "%DriveLetter%\sources\install.wim" (
	echo.Can't find Windows OS Installation files in the specified Drive Letter..
	echo.
	echo.Please enter the correct DVD Drive Letter..
	goto :Stop
)

echo.-------------------------------------------------------------------------------
echo.####Copying Source from DVD Drive to ^<DVD^> folder##############################
echo.-------------------------------------------------------------------------------
echo.
call :RemoveFolder "%DVD%"
echo.Copying Source from DVD Drive ^<%DriveLetter%^> to Source ^<DVD^> folder...
echo.
echo.Copying from DVD Drive may take some time, so please wait...
%XCopy% %DriveLetter% "%DVD%" >nul
echo.
echo.Copying Complete...
echo.
echo.-------------------------------------------------------------------------------
echo.####Finished Copying Source from DVD Drive to ^<DVD^> folder#####################
echo.-------------------------------------------------------------------------------

:Stop
echo.
echo.===============================================================================
echo.
pause

set DriveLetter=

endlocal

:: Returning to Main Menu
goto :MainMenu
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: LastOS Toolkit - Extract Source from DVD ISO Image to <DVD> folder
::-------------------------------------------------------------------------------------------
:ExtractSourceISO

setlocal

set ISOFileName=

cls
echo.===============================================================================
echo.      LastOS ToolKit - Extract Source from DVD ISO Image to ^<DVD^> folder
echo.===============================================================================
echo.

:: Checking whether Windows Source DVD folder is empty
if exist "%DVD%\sources\*.wim" (
	echo.Toolkit's Source ^<DVD^> folder is not empty...
	echo.
	choice /C:YN /N /M "Do you want to remove it & continue ? ['Y'es/'N'o] : "
	if errorlevel 2 goto :Stop
	echo.
)

:: Checking whether DVD ISO Image folder is empty
if not exist "%ISO%\*.iso" (
	echo.DVD ISO Image folder ^<ISO^> is empty...
	echo.
	echo.Please copy DVD ISO Images to ^<ISO^> folder...
	goto :Stop
)

echo.-------------------------------------------------------------------------------
echo.####Starting Extracting Source from DVD ISO Image to ^<DVD^> folder##############
echo.-------------------------------------------------------------------------------
echo.
echo.-------------------------------------------------------------------------------
echo.####Getting DVD ISO Image Options##############################################
echo.-------------------------------------------------------------------------------
echo.
:: Getting DVD ISO Image file Name
set /p ISOFileName=Enter the ISO Image filename without .iso : 

:: Setting DVD ISO Image file Name
set "ISOFileName=%ISOFileName%.iso"
echo.

:: Checking whether the specified DVD ISO Image file exist
if not exist "%ISO%\%ISOFileName%" (
	echo.Can't find the specified DVD ISO Image in ^<ISO^> folder...
	echo.
	echo.Please enter the correct DVD ISO Image filename...
	goto :Stop
)

echo.-------------------------------------------------------------------------------
echo.####Extracting Source from DVD ISO Image to ^<DVD^> folder#######################
echo.-------------------------------------------------------------------------------
echo.
call :RemoveFolder "%DVD%"
echo.Extracting DVD ISO Image contents to Source ^<DVD^> folder...
echo.
echo.Extraction may take some time, so please wait...
"%Zip%" x -y "%ISO%\%ISOFileName%" -o"%DVD%" >nul
echo.
set /a n=0
if exist "%DVD%\sources\boot.wim" set /a n+=1
if exist "%DVD%\sources\install.wim" set /a n+=1
if exist "%DVD%\sources\install.esd" set /a n+=1
if "%n%" equ "2" (echo.Extraction Complete...) else echo.Extraction Failed...
echo.
echo.-------------------------------------------------------------------------------
echo.####Finished Extracting Source from DVD ISO Image to ^<DVD^> folder##############
echo.-------------------------------------------------------------------------------

:Stop
echo.
echo.===============================================================================
echo.
pause

set ISOFileName=

endlocal

:: Returning to Main Menu
goto :MainMenu
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: LastOS Toolkit - Extract Source from OEM IMG Image to <DVD> folder
::-------------------------------------------------------------------------------------------
:ExtractSourceIMG

setlocal

set IMGFileName=

cls
echo.===============================================================================
echo.      LastOS ToolKit - Extract Source from OEM IMG Image to ^<DVD^> folder
echo.===============================================================================
echo.

:: Checking whether Windows Source DVD folder is empty
if exist "%DVD%\sources\*.wim" (
	echo.Toolkit's Source ^<DVD^> folder is not empty...
	echo.
	choice /C:YN /N /M "Do you want to remove it & continue ? ['Y'es/'N'o] : "
	if errorlevel 2 goto :Stop
)

:: Checking whether OEM IMG folder is empty
if not exist "%ISO%\*.img" (
	echo.Can't find Windows Install OEM IMG Image file in ^<ISO^> folder...
	echo.
	echo.Please copy Windows Install OEM IMG Image file to ^<ISO^> folder...
	goto :Stop
)

echo.-------------------------------------------------------------------------------
echo.####Starting Extracting Source from OEM IMG Image to ^<DVD^> folder##############
echo.-------------------------------------------------------------------------------
echo.
echo.-------------------------------------------------------------------------------
echo.####Getting OEM IMG Image Options##############################################
echo.-------------------------------------------------------------------------------
echo.
:: Getting OEM IMG file Name
set /p IMGFileName=Enter the OEM IMG filename without .img : 

:: Setting OEM IMG file Name
set "IMGFileName=%IMGFileName%.img"
echo.

:: Checking whether the specified OEM IMG Image file exist
if not exist "%ISO%\%IMGFileName%" (
	echo.Can't find the specified OEM IMG Image file...
	echo.
	echo.Please enter the correct OEM IMG Image filename...
	goto :Stop
)

echo.-------------------------------------------------------------------------------
echo.####Extracting Source from OEM IMG Image to ^<DVD^> folder#######################
echo.-------------------------------------------------------------------------------
echo.
call :RemoveFolder "%DVD%"
echo.Extracting OEM IMG Image Contents to Source ^<DVD^> folder...
echo.
echo.Extraction may take some time, so please wait...
"%Zip%" x -y "%ISO%\%IMGFileName%" -o"%DVD%" >nul
echo.
set /a n=0
if exist "%DVD%\sources\boot.wim" set /a n+=1
if exist "%DVD%\sources\install.wim" set /a n+=1
if "%n%" equ "2" (echo.Extraction Complete...) else echo.Extraction Failed...
echo.
echo.-------------------------------------------------------------------------------
echo.####Finished Extracting Source from OEM IMG Image to ^<DVD^> folder##############
echo.-------------------------------------------------------------------------------

:Stop
echo.
echo.===============================================================================
echo.
pause

set IMGFileName=

endlocal

:: Returning to Main Menu
goto :MainMenu
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: LastOS Toolkit - Extract Source from Store ESD Image
::-------------------------------------------------------------------------------------------
:ExtractSourceStoreESD

setlocal

set ImageBuild=

cls
echo.===============================================================================
echo.            LastOS ToolKit - Extract Source from Store ESD Image
echo.===============================================================================
echo.

:: Checking whether Windows Source DVD folder is empty
if not exist "%InstallEsd%" (
	echo.Can't find Windows Store ESD Image file "Install.esd" in ^<DVD\Sources^> folder.
	echo.
	echo.Please copy Windows Store ESD Image file to ^<DVD\Sources^> folder...
	goto :Stop
)
echo.-------------------------------------------------------------------------------
echo.####Starting Extracting Source from Store ESD Image############################
echo.-------------------------------------------------------------------------------
echo.
echo.Reading Image Information...
echo.
echo.===============================================================================
echo.^|Index^| Arch ^| Name
echo.===============================================================================
for /f "tokens=2 delims=: " %%a in ('%DISM% /Get-WimInfo /WimFile:"%InstallEsd%" ^| findstr Index') do (
	for /f "tokens=2 delims=:" %%b in ('%DISM% /Get-WimInfo /WimFile:"%InstallEsd%" /Index:%%a ^| findstr /i Architecture') do (
		for /f "tokens=2 delims=:  " %%c in ('%DISM% /Get-WimInfo /WimFile:"%InstallEsd%" /Index:%%a ^| findstr /i Name') do (
			if %%a equ 1 echo.^|  %%a  ^|  -   ^|%%c
			if %%a gtr 1 if %%a leq 9 echo.^|  %%a  ^|%%b  ^|%%c
			if %%a gtr 9 echo.^|  %%a ^|%%b  ^|%%c
		)
	)
)
echo.===============================================================================
echo.

:: Finding total no of indexes present inside the ESD Image
call :GetImageCount "%InstallEsd%"

if %ImageCount% equ 4 set ImageIndexNo=4

if %ImageCount% gtr 4 (
	:: Getting Image Index Number to Service
	set /p ImageIndexNo=Enter the Image Index # [Range : 4,...%ImageCount%, 'A'll, 'Q'uit] : 

	:: Checking for Image Index Validation
	if not defined ImageIndexNo (
		echo.
		echo.Invalid Index # Entered, Valid Range is [4,...%ImageCount%, 'A'll, 'Q'uit]
		echo.
		pause
		goto :ExtractSourceStoreESD
	)

	if /i "%ImageIndexNo%" equ "A" (
		set "ImageIndexNo=3"

    	for /l %%i in (4, 1, %ImageCount%) do (
        	set "ImageIndexNo=!ImageIndexNo!,%%i"
    	)
	)

	if /i "%ImageIndexNo%" equ "Q" goto :MainMenu
)
echo.
echo.-------------------------------------------------------------------------------
echo.####Extracting Source from Store ESD Image#####################################
echo.-------------------------------------------------------------------------------
echo.
echo.Decrypting Windows Store ESD Image if it's been encrypted...
attrib -r -h -s -a "%InstallEsd%" >nul
for /f "skip=1 tokens=4 delims=:." %%e in ('%DISM% /Get-WimInfo /WimFile:"%InstallEsd%" /Index:4 ^| find /i "Version"') do set ImageBuild=%%e
if %ImageBuild% equ 9600 "%W81EsdDecrypter%" "%InstallEsd%" 2>nul
if %ImageBuild% gtr 9600 "%W10EsdDecrypter%" "%InstallEsd%" >nul
echo.
echo.-------------------------------------------------------------------------------
echo.Applying Windows Store ESD Image [Install.esd, Index : 1] to ^<Temp\DVD^>...
echo.-------------------------------------------------------------------------------
:: Creating Windows Setup Installation Media folder "%Temp%\DVD"
call :RemoveFolder "%Temp%\DVD"
call :CreateFolder "%Temp%\DVD"
call :ApplyImage "%InstallEsd%", 1, "%Temp%\DVD"
echo.-------------------------------------------------------------------------------
echo.Exporting Windows Store ESD Image [Install.esd, Index : 2] to Boot Image...
echo.-------------------------------------------------------------------------------
rem call :ExportImageIndex "%InstallEsd%", 2, "%Temp%\DVD\sources\boot.wim", "WIM", "Yes"
echo.
"%WimlibImagex%" export "%InstallEsd%" 2 "%Temp%\DVD\sources\boot.wim" --boot --compress=LZX
call :DeleteImage "%Temp%\DVD\sources\boot.wim", 1 >nul
echo.
echo.-------------------------------------------------------------------------------
echo.Exporting Windows Store ESD Image [Install.esd, Index : 3] to Boot Image...
echo.-------------------------------------------------------------------------------
rem call :ExportImageIndex "%InstallEsd%", 3, "%Temp%\DVD\sources\boot.wim", "WIM", "Yes"
echo.
"%WimlibImagex%" export "%InstallEsd%" 3 "%Temp%\DVD\sources\boot.wim" --boot --compress=LZX
echo.
if %ImageBuild% equ 9600 (
	echo.-------------------------------------------------------------------------------
	echo.Exporting Windows Store ESD Image [Install.esd, Index : 4] to Install Image...
	echo.-------------------------------------------------------------------------------
	rem call :ExportImageIndex "%InstallEsd%", 4, "%Temp%\DVD\sources\install.wim", "WIM", "No"
	echo.
	"%WimlibImagex%" export "%InstallEsd%" 4 "%Temp%\DVD\sources\install.wim" --compress=LZX
	echo.
)

if %ImageBuild% gtr 9600 (
	for %%i in (%ImageIndexNo%) do (
		echo.-------------------------------------------------------------------------------
		echo.Exporting Windows Store ESD Image [Install.esd, Index : %%i] to Install Image...
		echo.-------------------------------------------------------------------------------
		rem call :ExportImageIndex "%InstallEsd%", %%i, "%Temp%\DVD\sources\install.wim", "WIM", "No"
		echo.
		"%WimlibImagex%" export "%InstallEsd%" %%i "%Temp%\DVD\sources\install.wim" --compress=LZX
		echo.
	)
)

:: Moving ESD to WIM converted folder <Temp\DVD> to <DVD> Source Folder
call :RemoveFolder "%DVD%"
move /y "%Temp%\DVD" "%ROOT%" >nul

echo.-------------------------------------------------------------------------------
echo.####Copying EI.CFG Config file to Source ^<DVD\sources^> folder##################
echo.-------------------------------------------------------------------------------
echo.
:: Getting Install Image Index Edition
call :GetImageEdition "%InstallWim%", 1

:: Writing EI.cfg Config file to <DVD\sources> folder
echo.Copying EI.CFG file to ^<DVD\sources^> folder...

if exist "%DVD%\sources\EI.CFG" del /f /q "%DVD%\sources\EI.CFG" >nul
(
	echo.[EditionID]
	if %ImageCount% equ 1 echo.%ImageEdition%
	if %ImageCount% gtr 1 echo.
	echo.
	echo.[Channel]
	echo.Retail
	echo.
	echo.[VL]
	echo.0
	echo.
)>"%DVD%\sources\EI.CFG"

:: Cleaning Up Unwanted files from Source folder
call :RemoveFile "%DVD%\MediaMeta.xml"
echo.
echo.-------------------------------------------------------------------------------
echo.####Finished Extracting Source from Store ESD Image############################
echo.-------------------------------------------------------------------------------

:Stop
echo.
echo.===============================================================================
echo.
pause

set ImageBuild=

endlocal

:: Returning to Main Menu
goto :MainMenu
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: LastOS Toolkit - Extract Source from MCT or Custom ESD Install Image
::-------------------------------------------------------------------------------------------
:ExtractSourceESD

setlocal

cls
echo.===============================================================================
echo.   LastOS ToolKit - Extract Source from MCT or Custom ESD Install Image
echo.===============================================================================
echo.

:: Checking whether Windows Source Boot Image exist
if not exist "%BootWim%" (
	echo.Can't find Windows Setup "Boot.wim" Image in ^<DVD\Sources^> folder...
	echo.
	echo.Please copy Windows Setup "Boot.wim" Image to ^<DVD\Sources^> folder...
	goto :Stop
)

:: Checking whether Windows Source Install ESD Image exist
if not exist "%InstallEsd%" (
	echo.Can't find Windows Setup "Install.esd" Image in ^<DVD\Sources^> folder...
	echo.
	echo.Please copy Windows Setup "Install.esd" Image to ^<DVD\Sources^> folder...
	goto :Stop
)

echo.-------------------------------------------------------------------------------
echo.####Starting Extract Source from MCT or Custom ESD Install Image###############
echo.-------------------------------------------------------------------------------
echo.
echo.Reading Image Information...
echo.
echo.===============================================================================
echo.^|Index^| Arch ^| Name
echo.===============================================================================
for /f "tokens=2 delims=: " %%a in ('%DISM% /Get-WimInfo /WimFile:"%InstallEsd%" ^| findstr Index') do (
	for /f "tokens=2 delims=:" %%b in ('%DISM% /Get-WimInfo /WimFile:"%InstallEsd%" /Index:%%a ^| findstr /i Architecture') do (
		for /f "tokens=2 delims=:  " %%c in ('%DISM% /Get-WimInfo /WimFile:"%InstallEsd%" /Index:%%a ^| findstr /i Name') do (
			if %%a leq 9 echo.^|  %%a  ^|%%b  ^|%%c
			if %%a gtr 9 echo.^|  %%a ^|%%b  ^|%%c
		)
	)
)
echo.===============================================================================
echo.

:: Finding total no of indexes present inside the ESD Image
call :GetImageCount "%InstallEsd%"

if %ImageCount% equ 1 (
	set /p ImageIndexNo=Enter the ESD Image Index # ['Q'uit] : 
) else set /p ImageIndexNo=Enter the ESD Image Index # [Range : 1,2,...%ImageCount%, 'A'll, 'Q'uit] : 

:: Checking for Image Index Validation
if not defined ImageIndexNo (
	echo.
	echo.Invalid Index # Entered, Valid Range is [1,2,...%ImageCount%, 'A'll, 'Q'uit]
	echo.
	pause
	goto :ExtractSourceESD
)

if /i "%ImageIndexNo%" equ "A" (
	set "ImageIndexNo=1"
    for /l %%i in (2, 1, %ImageCount%) do (
        set "ImageIndexNo=!ImageIndexNo!,%%i"
    )
)

if /i "%ImageIndexNo%" equ "Q" goto :MainMenu

echo.
echo.-------------------------------------------------------------------------------
echo.####Extracting Source from MCT or Custom ESD Install Image#####################
echo.-------------------------------------------------------------------------------

:: Converting Source MCT or Custom ESD Install Image to WIM Image
for %%i in (%ImageIndexNo%) do (
	echo.-------------------------------------------------------------------------------
	echo.Exporting [Install.esd, Index : %%i] to Install Image...
	echo.-------------------------------------------------------------------------------
	rem call :ExportImageIndex "%InstallEsd%", %%i, "%InstallWim%", "WIM", "No"
	echo.
	"%WimlibImagex%" export "%InstallEsd%" %%i "%InstallWim%" --compress=LZX
	echo.
)

:: Deleting original Source MCT or Custom ESD Install Image
call :RemoveFile "%InstallEsd%"

echo.-------------------------------------------------------------------------------
echo.####Finished Extract Source from MCT or Custom ESD Install Image###############
echo.-------------------------------------------------------------------------------

:Stop
echo.
echo.===============================================================================
echo.
pause

endlocal

:: Returning to Main Menu
goto :MainMenu
::-------------------------------------------------------------------------------------------


:Downloadwin11

rem setlocal

cls
echo.===============================================================================
echo.   LastOS ToolKit - Download Windows 11 from Microsoft
echo.===============================================================================
echo.
echo MCTool = %MCTool%
pause
@REM call %MCTool%\MediaCreationToolwin11.bat
echo.-------------------------------------------------------------------------------
echo.####Finished Downloading Windows 11 from Microsoft###############
echo.-------------------------------------------------------------------------------

echo.-------------------------------------------------------------------------------
echo.####Copying Windows 11 to %ISO% ###############
echo.-------------------------------------------------------------------------------
call %MCTool%\copywin11.cmd

pause 





echo.-------------------------------------------------------------------------------
echo.####Finished Downloading and copying Windows 11 from Microsoft###############
echo.-------------------------------------------------------------------------------

:Stop
echo.
echo.===============================================================================
echo.
pause

@REM endlocal

:: Returning to Main Menu
goto :MainMenu
::-------------------------------------------------------------------------------------------


:DownloadMS

@REM setlocal

cls
echo.===============================================================================
echo.   LastOS ToolKit - Download Windows from Microsoft
echo.===============================================================================
echo.

call %MCTool%\MediaCreationTool.bat




echo.-------------------------------------------------------------------------------
echo.####Finished Downloading Windows from Microsoft###############
echo.-------------------------------------------------------------------------------

:Stop
echo.
echo.===============================================================================
echo.
pause

@REM endlocal

:: Returning to Main Menu
goto :MainMenu
::-------------------------------------------------------------------------------------------



:MainMenu
exit