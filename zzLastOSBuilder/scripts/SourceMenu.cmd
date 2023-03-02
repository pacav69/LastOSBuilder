rem source.cmd
@echo off
rem Win11 script
set scriptver=0.0.9
title %~nx0  v%scriptver%

set Debug=1

@REM IF /I %debug% == 1 (

@REM echo. ########################################
@REM echo my project name is %ProjectName%
@REM echo MCTool = %MCTool%
@REM echo ISO = %ISO%
@REM echo. ########################################
@REM pause

@REM )
@REM ELSE
@REM (goto startcode)


@REM :startcode

@REM  call the "setvars.cmd" file in the Scripts directory
call %CPS%\setvars.cmd
set "Zip=%Bin%\%HostArchitecture%\7z.exe"
if "%HostVersion%" neq "6.1" set "DISM=%Bin%\%HostArchitecture%\DISM10\Dism.exe"
set "InstallEsd=%DVD%\sources\install.esd"
set "InstallWim=%DVD%\sources\install.wim"
set "W10EsdDecrypter=%Bin%\Dism++CUI.exe /ESDFile"
set "Temp=%CP%\Temp"

IF /I %debug% == 1 (
echo.
echo my project name is %ProjectName%
echo HostArchitecture = %HostArchitecture%
echo zip = %zip%
echo bin = %bin%
echo DISM = %DISM%
echo InstallEsd = %InstallEsd%
echo W10EsdDecrypter = %W10EsdDecrypter%
echo Temp = %Temp%
pause
)

IF /I %debug% == 1 (
echo cps = %CPS%
echo cp = %CP%
)
@REM echo MCTool = %MCTool%
set "MCTool=%CP%\MCT"
@REM echo MCTool = %MCTool%

@REM pause

::-------------------------------------------------------------------------------------------
:: LastOS Toolkit - Select Source Menu
::-------------------------------------------------------------------------------------------
:SourceMenu
set "downWin11=No"
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
	goto :Quit
)

:: Checking whether Image Registry is loaded
if "%IsImageRegistryLoaded%" equ "Yes" (
	echo.Source OS Image Registry is loaded, please do unload it using Tools-^>Options..
	echo.
	echo.===============================================================================
	echo.
	pause
	goto :Quit
)

echo.  [1]   Select Source from ^<00_source^> Folder
@REM echo.
@REM echo.  [2]   Copy Source from DVD Drive
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
if errorlevel 9 goto :Quit
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
echo.
@REM  debug
IF /I %debug% == 1 (
echo. BootWim = %BootWim%
pause
)

:: Checking whether Windows Source Boot Image exist
if not exist "%BootWim%" (
	echo.Can't find Windows Setup "Boot.wim" Image in ^<%DVD%\Sources^> folder...
	echo.
	echo.Please copy Windows Setup "Boot.wim" Image to ^<%DVD%\Sources^> folder...
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
   goto :Quit
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

goto :Quit
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

:: Returning to Quit
goto :Quit
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
@REM set  "ISOFileName=mswin11_test_22H2"

set  "ISOFileName=%MountISO%"

@REM debug
@REM set /p ISOFileName=Enter the ISO Image filename without .iso :

:: Setting DVD ISO Image file Name
@REM set "ISOFileName=%ISOFileName%.iso"
echo.

@REM echo file = "%ISO%\%ISOFileName%
@REM pause

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

:: Returning to Quit
goto :Quit
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

:: Returning to Quit
goto :Quit
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

@REM  debug
@REM echo DISM = %DISM%
@REM pause

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

@REM pause

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

	if /i "%ImageIndexNo%" equ "Q" goto :Quit
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

:: Returning to Quit
goto :Quit
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
    for /l %%i in (2, 1, %ImageCount%) do (MCT
        set "ImageIndexNo=!ImageIndexNo!,%%i"
    )
)

if /i "%ImageIndexNo%" equ "Q" goto :Quit

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

:: Returning to Quit
goto :Quit
::-------------------------------------------------------------------------------------------


:Downloadwin11

rem setlocal

cls
echo.===============================================================================
echo.   LastOS ToolKit - Download Windows 11 from Microsoft
echo.===============================================================================
echo.

@REM debug
@REM  check if win 11 exists
@REM  check that ISO file exists before proceeding
set "testfile=*.iso"
@REM set "testfile=*.txt"
echo MCTool = %MCTool%
echo testfile = %testfile%
@REM pause
REM find file
@REM IF /I %debug% == 1 (
IF EXIST "%MCTool%\%testfile%" (
  ECHO file %testfile% exists & goto runcode
) ELSE (
  ECHO file %testfile% does not exist & goto :DONE
)
@REM echo nope
@REM pause
@REM )

@REM pause
:runcode
echo.
choice /C:YN /N /M "ISO file found in %MCTool% are you sure you want to continue? ['Y'es/'N'o] : "
if errorlevel 2 goto :somewhere_else
if errorlevel 1 goto :somewhere

:somewhere
IF /I %debug% == 1 (
echo somewhere
pause
)
goto :DONE

@REM echo runcode
@REM echo MCTool = %MCTool%
@REM pause
@REM @REM if exists %ISO%
@REM rem Rename first found %ISO%\*.ISO to use as Windows Original source ISO
@REM cd /D "%ISO%"
@REM @REM pause
@REM for /f "tokens=* delims=" %%x in ('dir "*.iso" /B /O:N') do ren "%ISO%\%%x" "%MountISO%" & goto END

@REM cho end of the road
@REM pause

@REM file exists then exit
:somewhere_else
exit /B
@REM goto :eof


:DONE

@REM  ref https://ss64.com/nt/start.html

@REM  set "IsSourceSelected=No"

@REM if "%IsSourceSelected%" equ "Yes" (
@REM 	echo.Source OS has already been selected...
@REM 	echo.
@REM 	echo.===============================================================================
@REM 	echo.
@REM 	pause
@REM 	goto :MainMenu
@REM )
@REM Echo Starting
@REM  ref https://ss64.com/nt/start.html
@REM START /wait "demo" CMD /c demoscript.cmd
@REM Echo Done
@REM start the MediaCreationToolwin11

cls
echo.-------------------------------------------------------------------------------
echo.####Now Downloading Windows 11 from Microsoft###############
echo.-------------------------------------------------------------------------------
@REM set "downWin11=yes"
@REM start /wait  "Win11 download"   cmd /d /x /c call %MCTool%\MediaCreationToolwin11.bat
@REM call %MCTool%\MediaCreationToolwin11.bat

@REM START /wait  "wd11" cmd /c %MCTool%\MediaCreationToolwin11.cmd

call %CPS%\win11down.cmd


@REM check if iso exists
call :checkiso

@REM pause
goto :quit

:checkiso
@REM debug
@REM  check if win 11 exists
@REM  check that ISO file exists before proceeding
set "testfile=*.iso"
@REM set "testfile=*.txt"
echo MCTool = %MCTool%
echo testfile = %testfile%
@REM pause
REM find file
@REM IF /I %debug% == 1 (
IF EXIST "%MCTool%\%testfile%" (
  ECHO file %testfile% exists & goto runcode
) ELSE (
  ECHO file %testfile% does not exist &  TIMEOUT /T 5 & goto :DONE
)
@REM echo nope
@REM pause
@REM )

@REM pause
:DONE

@REM create error level 1
color 00
echo ERRORLEVEL = %ERRORLEVEL%

set "downWin11=No"
echo no download


 TIMEOUT /T 10
goto :finished

:runcode

set "downWin11=Yes"

goto :finished
@REM :quit




:finished
echo Finished
@REM pause

echo.-------------------------------------------------------------------------------
echo.####Finished Downloading Windows 11 from Microsoft###############
echo.-------------------------------------------------------------------------------


@REM debug


:: Checking whether Source ISO is found
if "%downWin11%" equ "No" (
	echo. Source ISO not found...
	echo.
	echo.===============================================================================
	echo.
	pause
	goto :MainMenu
)

echo.-------------------------------------------------------------------------------
echo.####Copying Windows 11 to %ISO% ###############
echo.-------------------------------------------------------------------------------

call %CPS%\win11copy.cmd

@REM debug

call %CPS%\00.0__Rename_First_ISO_To_Windows_Original_ISO.cmd

@REM debug
	echo.-------------------------------------------------------------------------------
echo.####Extracting Windows 11 to %WindowsOriginalPath% ###############
echo.----------------------------------------------------------------------------------

call %CPS%\00.1_Extract_Source_ISO

echo.-------------------------------------------------------------------------------
echo.####Finished #Extracting Windows 11 ###############
echo.-------------------------------------------------------------------------------

If %debug% NEQ 0 (
pause
)

echo.-------------------------------------------------------------------------------
echo.####Finished Downloading and Processing Windows 11 from Microsoft###############
echo.-------------------------------------------------------------------------------

:Stop
echo.
echo.===============================================================================
If %debug% NEQ 0 (
echo.
echo.-------------------------------------------------------------------------------
echo.####about to cleanup Source sub-directories ###############
echo.-------------------------------------------------------------------------------
pause

call  %CPS%\00.01_Cleanout_LastOS_Builder.cmd
)


pause

@REM endlocal

:: Returning to Quit
goto :Quit
::-------------------------------------------------------------------------------------------


:DownloadMS

@REM setlocal

cls
echo.===============================================================================
echo.   LastOS ToolKit - Download Windows from Microsoft
echo.===============================================================================
echo.



@REM call %MCTool%\MediaCreationTool.bat
call %CPS%\MediaCreationToolMain.cmd

@REM call :MediaCreation



echo.-------------------------------------------------------------------------------
echo.####Finished Downloading Windows from Microsoft###############
echo.-------------------------------------------------------------------------------

:Stop
echo.
echo.===============================================================================
echo.
pause

@REM endlocal

:: Returning to Quit
goto :Quit
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to check MediaCreation is running
::
::-------------------------------------------------------------------------------------------

:MediaCreation

@REM echo MCTool = %MCTool%
set "MCTool=%CP%\MCT"

@REM  ################# MediaCreationTool
@REM START /wait  "wd11" cmd /c %MCTool%\MediaCreationToolwin11.cmd

TIMEOUT /T 10

@REM Check if media is running
:LOOP
tasklist /fi "imagename eq Media*" |find ":" > nul 2>&1
echo ERRORLEVEL = %ERRORLEVEL%
@REM pause
IF ERRORLEVEL 1 (
  ECHO MediaCreationTool is still running
  TIMEOUT /T 5
@REM   loop if media still running
  GOTO LOOP
)
@REM ELSE (

    GOTO CONTINUE

:CONTINUE

echo end of MediaCreationTool for now

@REM  ################# MediaCreationTool


echo entering checkpidcmd
echo.
echo ##########################

@REM Check if cmd is running
 :checkpidcmd
@REM  set  "%%K="
 set "mypid="
for /F "tokens=2" %%K in ('
   tasklist /FI "ImageName eq cmd.exe" /FI "Status eq Running" /FO LIST ^| findstr /B "PID:"
') do (
	set "mypid=%%K"
   echo %%K
   TIMEOUT /T 5
   @REM loop if cmd is still running
   goto :checkpidcmd

   )

@REM echo ERRORLEVEL cmd = %ERRORLEVEL%

echo no check cmd running
TIMEOUT /T 5

IF /I %debug% == 1 (
TIMEOUT /T 5

pause
)
goto :eof

:: ############################################################################################
:: MSMG ToolKit DISM Functions
:: ############################################################################################

::-------------------------------------------------------------------------------------------
:: Function to get Image Index Count
:: Input Parameters [ %~1 : Image Filename ]
::-------------------------------------------------------------------------------------------
:GetImageCount

:: Finding total no of Indexes present in the Image.
for /f "tokens=2 delims=: " %%a in ('%DISM% /Get-ImageInfo /ImageFile:%~1 ^| findstr Index') do (set ImageCount=%%a)

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to display Image Information
::-------------------------------------------------------------------------------------------
:ShowImageInfo

set "ImageInfo=%Temp%\ImageInfo.txt"

call :RemoveFile "%ImageInfo%"

:: Get total no of Indexes present in the Image.
call :GetImageCount "%InstallWim%"

echo.
echo.Reading Image Information...
echo.
:: List all the Indexes in the Image.
echo.===============================================================================>>%ImageInfo%
echo.^| Index ^| Arch ^| Name>>%ImageInfo%
echo.===============================================================================>>%ImageInfo%
for /f "tokens=2 delims=: " %%a in ('%DISM% /Get-WimInfo /WimFile:%InstallWim% ^| findstr Index') do (
	for /f "tokens=2 delims=: " %%b in ('%DISM% /Get-WimInfo /WimFile:%InstallWim% /Index:%%a ^| findstr /i Architecture') do (
		for /f "tokens=2 delims=:" %%c in ('%DISM% /Get-WimInfo /WimFile:%InstallWim% /Index:%%a ^| findstr /i Name') do (
			if "%%b" neq "arm64" (
				if %%a leq 9 echo.^|   %%a   ^| %%b  ^|%%c>>%ImageInfo%
				if %%a gtr 9 if %%a lss 99 echo.^|   %%a  ^| %%b  ^|%%c>>%ImageInfo%
				if %%a gtr 99 echo.^|   %%a ^| %%b  ^|%%c>>%ImageInfo%
			)
			if "%%b" equ "arm64" (
				if %%a leq 9 echo.^|   %%a   ^| %%b^|%%c>>%ImageInfo%
				if %%a gtr 9 if %%a lss 99 echo.^|   %%a  ^| %%b^|%%c>>%ImageInfo%
				if %%a gtr 99 echo.^|   %%a ^| %%b^|%%c>>%ImageInfo%
			)
		)
	)
)

type "%ImageInfo%"
call :RemoveFile "%ImageInfo%"

echo.===============================================================================
echo.

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to get Image Index number to service
:: Input Parameters [ %~1 : Image Filename ]
::-------------------------------------------------------------------------------------------
:GetImageIndexNo

:: Display the list of avaialble Image Indexes.
call :ShowImageInfo

if "%ImageCount%" equ "1" (
	set /p ImageIndexNo=Enter the Image Index # ['Q'uit] :
) else set /p ImageIndexNo=Enter the Image Index # [Range : 1,...%ImageCount% or 'A'll 'Q'uit] :

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to get Image Index Architecture
:: Input Parameters [ %~1 : Image Filename, %~2 : Image Index No ]
::-------------------------------------------------------------------------------------------
:GetImageArchitecture

for /f "tokens=2 delims=: " %%a in ('%DISM% /Get-ImageInfo /ImageFile:"%~1" /Index:%~2 ^| findstr /i Architecture') do (set ImageArchitecture=%%a)

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to get Image Index Edition
:: Input Parameters [ %~1 : Image Filename, %~2 : Image Index No ]
::-------------------------------------------------------------------------------------------
:GetImageEdition

for /f "tokens=2 delims=: " %%f in ('%DISM% /Get-ImageInfo /ImageFile:"%~1" /Index:%~2 ^| findstr /i Edition') do (set ImageEdition=%%f)

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to get Image Index Information
:: Input Parameters [%~1 : Image Filename, %~2 : Image Index No]
::-------------------------------------------------------------------------------------------
:GetImageIndexInfo

for /f "tokens=2 delims=:" %%a in ('%DISM% /Get-ImageInfo /ImageFile:"%~1" /Index:%~2 ^| findstr /i Name') do (set ImageName=%%a)
for /f "tokens=2 delims=:" %%b in ('%DISM% /Get-ImageInfo /ImageFile:"%~1" /Index:%~2 ^| findstr /i Description') do (set ImageDescription=%%b)
for /f "tokens=2 delims=: " %%c in ('%DISM% /Get-ImageInfo /ImageFile:"%~1" /Index:%~2 ^| findstr /i Architecture') do (set ImageArchitecture=%%c)
for /f "tokens=2 delims=: " %%d in ('%DISM% /Get-ImageInfo /ImageFile:"%~1" /Index:%~2 ^| findstr /i Version') do (set ImageVersion=%%d)
for /f "tokens=2 delims=:" %%e in ('%DISM% /Get-ImageInfo /ImageFile:"%~1" /Index:%~2 ^| find "ServicePack Build"') do (set ImageServicePackBuild=%%e)
for /f "tokens=2 delims=:" %%f in ('%DISM% /Get-ImageInfo /ImageFile:"%~1" /Index:%~2 ^| find "ServicePack Level"') do (set ImageServicePackLevel=%%f)
for /f "tokens=2 delims=: " %%g in ('%DISM% /Get-ImageInfo /ImageFile:"%~1" /Index:%~2 ^| findstr /i Edition') do (set ImageEdition=%%g)
for /f "tokens=2 delims=:<> " %%h in ('%Imagex% /info "%~1" %~2 ^| findstr /i Flag') do (set ImageFlag=%%h)
for /f "tokens=2 delims=:" %%i in ('%DISM% /Get-ImageInfo /ImageFile:"%~1" /Index:%~2 ^| findstr /i Installation') do (set ImageInstallationType=%%i)
for /f "tokens=1 delims= " %%j in ('%DISM% /Get-ImageInfo /ImageFile:"%~1" /Index:%~2 ^| findstr /i "Default"') do (set "ImageDefaultLanguage=%%j")

set "ImageName=%ImageName:~1%"
set "ImageDescription=%ImageDescription:~1%"

if "%ImageVersion:~0,-6%" neq "10.0" if "%ImageVersion:~0,-6%" neq "11.0" set /A ImageBuild=%ImageVersion:~4,4%
if "%ImageVersion%" neq "6.1.7601" if "%ImageVersion%" neq "6.3.9600" set /A ImageBuild=%ImageVersion:~5,5%

set "ImageServicePackBuild=%ImageServicePackBuild:~1%"
set "ImageServicePackLevel=%ImageServicePackLevel:~1%"
set "ImageInstallationType=%ImageInstallationType:~1%"
set "ImageDefaultLanguage=!ImageDefaultLanguage:~1!"

if "%ImageFlag%" equ "" set "ImageFlag=%ImageEdition%"

if "%ImageInstallationType:~,6%" equ "Server" set "ImageDescription=%ImageDescription:(=[%"
if "%ImageInstallationType:~,6%" equ "Server" set "ImageDescription=%ImageDescription:)=]%"

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to get updated Image Index Information
::-------------------------------------------------------------------------------------------
:GetUpdatedImageInformation

for /l %%i in (1, 1, %ImageCount%) do (
	if exist "%InstallMount%\%%i" (
		call :MountImageRegistry "%InstallMount%\%%i"
		for /f "tokens=3 delims= " %%x in ('reg query "HKLM\TK_SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild" ^| find "REG_SZ"') do (set /a ImageBuild=%%x)
		set "ImageVersion=10.0.!ImageBuild!"
		for /f "tokens=3 delims= " %%y in ('reg query "HKLM\TK_SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "UBR" ^| find "REG_DWORD"') do (set /a ImageServicePackBuild=%%y)
		call :UnMountImageRegistry
	)
)

goto :EOF
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to Mount a Image
:: Input Parameters [ %~1 : Image Filename, %~2 : Image Index No, %~3 : Image Mount folder ]
::-------------------------------------------------------------------------------------------
:MountImage

%DISM% /Mount-Image /ImageFile:%~1 /Index:%~2 /MountDir:%~3
echo.

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to Un-Mount the Mounted Image
:: Input Parameters [ %~1 : Image Mount Folder, %~2 : Image Commit / Discard Option ]
::-------------------------------------------------------------------------------------------
:UnMountImage

%DISM% /Unmount-Image /MountDir:%~1 /%~2
echo.

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to delete a selected Image Index from a Image
:: Input Parameters [ %~1 : Image Filename, %~2 : Image Index No ]
::-------------------------------------------------------------------------------------------
:DeleteImage

%DISM% /Delete-Image /ImageFile:%~1 /Index:%~2
echo.

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to rename a selected Image Index Information
:: Input Parameters [ %~1 : Image Filename, %~2 : Image Index No, %~3 : Image Name, %~4 : Image Description ]
::-------------------------------------------------------------------------------------------
:RenameImage

%Imagex% /Info %~1 %~2 "%~3" "%~4"

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to split a Image
:: Input Parameters [ %~1 : Image Filename, %~2 : Image Split Filename, %~3 : Image Split Size in MB ]
::-------------------------------------------------------------------------------------------
:SplitImage

%DISM% /Split-Image /ImageFile:%~1 /SWMFile:%~2 /FileSize:%~3
echo.

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to merge a splitted Image
:: Input Parameters [ %~1 : Image Splitted Filename without Extension, %~2 : Image Filename ]
::-------------------------------------------------------------------------------------------
:MergeImage

%Imagex% /ref %~1*.swm /Check /Export %~1.swm * %~2

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to apply a Image to a drive or a folder
:: Input Parameters [ %~1 : Image Filename, %~2 : Image Index No, %~3 : Image Apply Drive or folder Name ]
::-------------------------------------------------------------------------------------------
:ApplyImage

%DISM% /Apply-Image /ImageFile:%~1 /Index:%~2 /ApplyDir:%~3\ /CheckIntegrity /Verify
echo.

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to capture a drive or a folder to a Image
:: Input Parameters [ %~1 : Image Filename, %~2 : Capture Drive or Folder Name,
::                    %~3 : Index Name,  %~4 : Index Description, %~5 : Bootable or Not Options ]
::-------------------------------------------------------------------------------------------
:CaptureImage

if "%~5" equ "Yes" %DISM% /Capture-Image /Imagefile:%~1 /CaptureDir:%~2 /Name:"%~3" /Description:"%~4" /ConfigFile:%WimConfigFile% /Bootable /Compress:Max /CheckIntegrity /Verify
if "%~5" equ "No" %DISM% /Capture-Image /Imagefile:%~1 /CaptureDir:%~2 /Name:"%~3" /Description:"%~4" /ConfigFile:%WimConfigFile% /Compress:Max /CheckIntegrity /Verify
echo.

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to append another Image to Image
:: Input Parameters [ %~1 : Image Filename, %~2 : Capture Drive or Folder Name,
::                    %~3 : Index Name,  %~4 : Index Description, %~5 : Bootable or Not Option ]
::-------------------------------------------------------------------------------------------
:AppendImage

if "%~5" equ "Yes" %DISM% /Append-Image /Imagefile:%~1 /CaptureDir:%~2 /Name:"%~3" /Description:"%~4" /ConfigFile:%WimConfigFile% /Bootable /CheckIntegrity /Verify
if "%~5" equ "No" %DISM% /Append-Image /Imagefile:%~1 /CaptureDir:%~2 /Name:"%~3" /Description:"%~4" /ConfigFile:%WimConfigFile% /CheckIntegrity /Verify
echo.

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to export a select Image Index with Maximum/Recovery compression
:: Input Parameters [ %~1 : Source Image Filename, %~2 : Source Image Index No,
::                    %~3 : Target Image Filename, %~4 : Image Format, %~5 : Bootable or Not Option ]
::-------------------------------------------------------------------------------------------
:ExportImageIndex

if "%~4" equ "WIM" if "%~5" equ "Yes" %DISM% /Export-Image /SourceImageFile:%~1 /SourceIndex:%~2 /DestinationImageFile:%~3 /CheckIntegrity /Compress:Max /Bootable
if "%~4" equ "WIM" if "%~5" equ "No" %DISM% /Export-Image /SourceImageFile:%~1 /SourceIndex:%~2 /DestinationImageFile:%~3 /CheckIntegrity /Compress:Max
if "%~4" equ "ESD" if "%~5" equ "Yes" %DISM% /Export-Image /SourceImageFile:%~1 /SourceIndex:%~2 /DestinationImageFile:%~3 /CheckIntegrity /Compress:Recovery /Bootable
if "%~4" equ "ESD" if "%~5" equ "No" %DISM% /Export-Image /SourceImageFile:%~1 /SourceIndex:%~2 /DestinationImageFile:%~3 /CheckIntegrity /Compress:Recovery
echo.

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to export all Image Indexes with Maximum/Recovery compression
:: Input Parameters [ %~1 : Source Image Filename, %~2 : Target Image Filename, %~3 : Image Format, %~4 : Bootable or Not Option ]
::-------------------------------------------------------------------------------------------
:ExportImage

if "%~3" equ "WIM" if "%~4" equ "Yes" %DISM% /Export-Image /SourceImageFile:%~1 /All /DestinationImageFile:%~2 /CheckIntegrity /Compress:Max /Bootable
if "%~3" equ "WIM" if "%~4" equ "No" %DISM% /Export-Image /SourceImageFile:%~1 /All /DestinationImageFile:%~2 /CheckIntegrity /Compress:Max
if "%~3" equ "ESD" if "%~4" equ "Yes" %DISM% /Export-Image /SourceImageFile:%~1 /All /DestinationImageFile:%~2 /CheckIntegrity /Compress:Recovery /Bootable
if "%~3" equ "ESD" if "%~4" equ "No" %DISM% /Export-Image /SourceImageFile:%~1 /All /DestinationImageFile:%~2 /CheckIntegrity /Compress:Recovery
echo.

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to cleanup a Image
:: Input Parameters [ %~1 : Image Mount Path, %~2 : Option  ]
::-------------------------------------------------------------------------------------------
:CleanupImage

setlocal

set "CleanupOption=%~2"

if "%CleanupOption%" equ "SPSupersededHideSP" (
	%DISM% /Image:%~1 /Cleanup-Image /SPSuperseded /HideSP
)

if "%CleanupOption%" equ "ComponentCleanupResetBase" (
	%DISM% /Image:%~1 /Cleanup-Image /StartComponentCleanup /ResetBase
)

if "%CleanupOption%" equ "CheckHealth" (
	%DISM% /Image:%~1 /Cleanup-Image /CheckHealth
)

if "%CleanupOption%" equ "ScanHealth" (
	%DISM% /Image:%~1 /Cleanup-Image /ScanHealth
)

echo.

endlocal

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to add driver packages to Image
:: Input Parameters [ %~1 : Image Mount Path, %~2 : Drivers Packages Path ]
::-------------------------------------------------------------------------------------------
:AddDriver

%DISM% /Image:%~1 /Add-Driver /Driver:%~2 /ForceUnsigned /Recurse
echo.

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to enable a feature inside a Image
:: Input Parameters [ %~1 : Image Mount Path, %~2 : Feature Name ]
::-------------------------------------------------------------------------------------------
:EnableFeature

%DISM% /Image:%~1 /Enable-Feature /FeatureName:%~2
echo.

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to disable a feature inside a Image
:: Input Parameters [ %~1 : Image Mount Path, %~2 : Feature Name ]
::-------------------------------------------------------------------------------------------
:DisableFeature

%DISM% /Image:%~1 /Disable-Feature /FeatureName:%~2
echo.

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to export a list of packages present inside a Image to a file
:: Input Parameters [ %~1 : Image Mount Path, %~2 : Filename ]
::-------------------------------------------------------------------------------------------
:GetPackages

%DISM% /Get-Packages /Image:%~1 > %Logs%\%~2

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to export the list of features present inside a Image to a file
:: Input Parameters [ %~1 : Image Mount Path, %~2 : Filename ]
::-------------------------------------------------------------------------------------------
:GetFeatures

%DISM% /Get-Features /Format:Table /Image:%~1 > %Logs%\%~2

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to add a Package to Image
:: Input Parameters [ %~1 : Image Mount Path, %~2 : Packages Path / Package Name ]
::-------------------------------------------------------------------------------------------
:AddPackage

%DISM% /Image:%~1 /Add-Package /PackagePath:%~2
echo.

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to remove a Package from a Image
:: Input Parameters [ %~1 : Image Mount Path, %~2 : Packages Path / Package Name ]
::-------------------------------------------------------------------------------------------
:RemovePackage

%DISM% /Image:%~1 /Remove-Package /PackageName:%~2
echo.

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to add a provisioned appx package to a Image
:: Input Parameters [ %~1 : Image Mount Path, %~2 : App Name, %~3 : App Package Path, %~4 : App Dependency Packages Path, %~5 : App License Path ]
::-------------------------------------------------------------------------------------------
:AddProvisionedAppxPackage

echo.-------------------------------------------------------------------------------
echo.Integrating %~2 Provisioned Appx Package...
echo.-------------------------------------------------------------------------------
%DISM% /Image:%~1 /Add-ProvisionedAppxPackage /PackagePath:%~3 %~4 %~5
echo.

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to remove provisioned appx package from the Image
:: Input Parameters [ %~1 : Image Mount Path, %~2 : App Name, %~3 : Package Name ]
::-------------------------------------------------------------------------------------------
:RemoveProvisionedAppxPackage

setlocal

set PackageName=

echo.-------------------------------------------------------------------------------
echo.Removing %~2 Provisioned Appx Package...
echo.-------------------------------------------------------------------------------

:: Getting Provisioned Appx Package list
for /f "tokens=2 delims=: " %%a in ('%DISM% /Image:%~1 /Get-ProvisionedAppxPackages ^| find /I "PackageName : %~3"') do (set PackageName=%%a)

if "%PackageName%" equ "" (
	echo.
	echo.The specified Provisioned Appx Package has already been removed...
) else (
	:: Removing Provisioned Appx Package from the Image
	%DISM% /Image:%~1 /Remove-ProvisionedAppxPackage /PackageName:%PackageName%
)

echo.

set PackageName=

endlocal

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to remove the default application associations from the Windows image
:: Input Parameters [ %~1 : Image Mount Path ]
::-------------------------------------------------------------------------------------------
:RemoveDefaultAppAssociations

%DISM% /Image:%~1 /Remove-DefaultAppAssociations

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to import a set of default application associations to a Windows image
:: Input Parameters [ %~1 : Image Mount Path, %~2 : App Association XML Filename ]
::-------------------------------------------------------------------------------------------
:ImportDefaultAppAssociations

%DISM% /Image:%~1 /Import-DefaultAppAssociations:%~2

goto :eof
::-------------------------------------------------------------------------------------------

:: ############################################################################################
:: MSMG ToolKit Misc Functions
:: ############################################################################################

::-------------------------------------------------------------------------------------------
:: Function to remove a Locked/Hidden Windows Package from the Image
:: Input Parameters [ %~1 : Image Mount Path, %~2 : Package Description, %~3 : Package Name ]
::-------------------------------------------------------------------------------------------
:RemoveLockedPackage

setlocal

set PackageName=

echo.-------------------------------------------------------------------------------
echo.Removing %~2 Package...
echo.-------------------------------------------------------------------------------

:: Making Locked/Hidden Windows Package visible
call :UnHidePackage "%~1", %~3

:: Getting Windows Package List
for /f "tokens=2 delims=:" %%a in ('%DISM% /Image:%~1 /Get-Packages ^| find /I "%~3"') do ( set PackageName=%%a )

if "%PackageName%" neq "" (
	if "%SelectedSourceOS%" equ "w7" (
		for /f "tokens=* delims= " %%a in ("%PackageName%") do set PackageName=%%a
		for /l %%a in (1,1,31) do if "!PackageName:~-1!" equ " " set PackageName=!PackageName:~0,-1!
	)
	if "%SelectedSourceOS%" neq "w7" set PackageName=%PackageName:~1,-1%
)

if "%PackageName%" equ "" (
	echo.
	echo.The specified package has already been removed...
	echo.
) else (
	:: Removing Windows Package from the Image
	%DISM% /Image:%~1 /Remove-Package /PackageName:%PackageName%
	echo.
)

set PackageName=

endlocal

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to mount Image Registry
:: Input Parameters [ %~1 : Image Mount Path ]
::-------------------------------------------------------------------------------------------
:MountImageRegistry

:: Mounting Image Registry for Offline Editing
reg load HKLM\TK_COMPONENTS "%~1\Windows\System32\config\COMPONENTS" >nul
reg load HKLM\TK_DEFAULT "%~1\Windows\System32\config\default" >nul
reg load HKLM\TK_NTUSER "%~1\Users\Default\ntuser.dat" >nul
reg load HKLM\TK_SOFTWARE "%~1\Windows\System32\config\SOFTWARE" >nul
reg load HKLM\TK_SYSTEM "%~1\Windows\System32\config\SYSTEM" >nul

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to unmount Image Registry
:: Input Parameters [ None ]
::-------------------------------------------------------------------------------------------
:UnMountImageRegistry

:: Un-Mounting Image Registry
for /f "tokens=* delims=" %%a in ('reg query "HKLM" ^| findstr "{"') do (
	reg unload "%%a" >nul 2>&1
)

reg unload HKLM\TK_COMPONENTS >nul 2>&1
reg unload HKLM\TK_DRIVERS >nul 2>&1
reg unload HKLM\TK_DEFAULT >nul 2>&1
reg unload HKLM\TK_NTUSER >nul 2>&1
reg unload HKLM\TK_SCHEMA >nul 2>&1
reg unload HKLM\TK_SOFTWARE >nul 2>&1
reg unload HKLM\TK_SYSTEM >nul 2>&1

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to import registry settings to Image Registry
:: Input Parameters [ %~1 : Import Registry file Name ]
::-------------------------------------------------------------------------------------------
:ImportRegistry2Image

:: Importing registry settings to Image Registry
reg import "%~1"

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to Create a Folder
:: Input Parameters [ %~1 : Foldername ]
::-------------------------------------------------------------------------------------------
:CreateFolder

if not exist "%~1" md "%~1" >nul

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to delete a file(s)
:: Input Parameters [ %~1 : Filename ]
::-------------------------------------------------------------------------------------------
:RemoveFile

if exist "%~1" del /f /q "%~1" >nul

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to delete a folder(s)
:: Input Parameters [ %~1 : Foldername ]
::-------------------------------------------------------------------------------------------
:RemoveFolder

if exist "%~1" rd /q /s "%~1" >nul

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Function to unhide a Windows Component Package
:: Input Parameters [ %~1 : Image Mount Path, %~2 : Package Name ]
::-------------------------------------------------------------------------------------------
:UnHidePackage

setlocal

set RegistryKey=

:: Mounting Image Registry
call :MountImageRegistry "%~1" >nul

:: Retrieving Package Registry Key Path
for /f "tokens=* delims=" %%a in ('reg query "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" /f "%~2" ^| find /I "%~2"') do ( set "RegistryKey=%%a" )

:: Making Windows Components Package visible
reg add "%RegistryKey%" /v Visibility /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%RegistryKey%" /v DefVis /t REG_DWORD /d 2 /f >nul 2>&1
reg delete "%RegistryKey%\Owners" /f >nul 2>&1

:: Un-Mounting Image Registry
call :UnMountImageRegistry

set RegistryKey=

endlocal

goto :eof
::-------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------
:: Cleanup MSMG Toolkit's temporary files and folders
::-------------------------------------------------------------------------------------------
:CleanUp

echo.Starting Cleaning Up...
echo.
echo.Cleaning Up Image Registry Mount Points...
call :UnMountImageRegistry

echo.
echo.Cleaning Up Image Mount Points...
Dism.exe /English /Quiet /Unmount-Wim /MountDir:"%BootMount%\1" /Discard >nul
Dism.exe /English /Quiet /Unmount-Wim /MountDir:"%BootMount%\2" /Discard >nul
Dism.exe /English /Unmount-Wim /MountDir:"%WinReMount%" /Discard >nul

for /l %%i in (1, 1, 100) do (
	if exist "%InstallMount%\%%i\Windows" Dism.exe /English /Unmount-Wim /MountDir:"%InstallMount%\%%i" /Discard >nul
)

:: Cleaning Up Images Mount Points Folders
call :RemoveFolder "%BootMount%"
call :CreateFolder "%BootMount%\1"
call :CreateFolder "%BootMount%\2"
call :RemoveFolder "%InstallMount%"
call :CreateFolder "%InstallMount%"
call :RemoveFolder "%WinReMount%"
call :CreateFolder "%WinReMount%"
echo.

:: Cleaning Up Logs Folders
echo.Cleaning Up Logs files...
call :RemoveFolder "%Logs%"
call :CreateFolder "%Logs%"
echo.

:: Cleaning Up Temporary files Folders
echo.Cleaning Up Temporary files...
call :RemoveFolder "%Temp%"
call :CreateFolder "%Temp%"

echo.
echo.Finished Cleaning Up...
echo.

goto :eof
::-------------------------------------------------------------------------------------------


:MainMenu

@REM =================================
:Quit
echo Bye
timeout 2 > NUL
@REM exit /b
@REM =================================
