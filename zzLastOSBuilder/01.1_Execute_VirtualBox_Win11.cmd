@echo off
rem Win11 script
set "scriptver=1.0"
title %~nx0  v%scriptver%

call :isAdmin

if %errorlevel% == 0 (
goto :run
) else (
echo Requesting administrative privileges...
goto :UACPrompt
)

exit /b

:isAdmin
fsutil dirty query %systemdrive% >nul
exit /b

:run
rem This first for routine will give the current path without a trailing \
%~d0
cd "%~dp0"
cd %~dps0
for %%f in ("%CD%") do set CP=%%~sf

rem User Set Variables:
set /p ProjectName=<%CP%\Settings\ProjectName.txt
set /p Arch=<%CP%\Settings\Arch.txt
set /p WinVersion=<%CP%\Settings\WinVersion.txt
set /p VMName=<%CP%\Settings\VMName.txt
set /p VMPath=<%CP%\Settings\VMPath.txt
set /p MountISO=<%CP%\Settings\MountISO.txt
set /p VHDSize=<%CP%\Settings\VHDSize_Win11.txt
set /p VirtMem=<%CP%\Settings\VirtMem_Win11.txt
set /p VHDFile=<%CP%\Settings\VHDFile.txt
set /p VirtDrive=<%CP%\Settings\VirtDrive.txt
set /p WIMName=<%CP%\Settings\WIMName.txt
set /p ESDName=<%CP%\Settings\ESDName.txt
set /p WindowsOriginalPath=<%CP%\Settings\WindowsOriginalPath.txt
set /p SysPrepISOPath=<%CP%\Settings\SysPrepISOPath.txt
set /p NTLiteISOPath=<%CP%\Settings\NTLiteISOPath.txt

rem System Set Variables:
for %%f in ("C:\Program Files\Oracle\VirtualBox") do set VBP=%%~sf
set VBM=%VBP%\VBoxManage.exe
set VMP=%CP%\%VMPath%
set ToolsPath=%CP%\Tools

rem *******
rem added in VirtualBox file check to ensure that 
rem VirtualBox exists before proceeding

setlocal enableextensions

rem if not defined VBM goto :eof
if not exist "%VBM%" goto :notexistvbm
rem *******   
rem check version of VirtualBox

set "vers="
FOR /F "tokens=2 delims==" %%a in ('
        wmic datafile where name^="%VBM:\=\\%" get Version /value 
    ') do set "vers=%%a"
    
set "light="
set "minver=7.0.0.0"
rem echo(%VBM%=%vers%
rem current version installed = 7.0.2.4219
  
rem echo(Version=%vers% 
rem ******* 
rem Version 7 of vbox is required for TPM 2.0 used by Win11 install
rem if Version is less then 7 (minver) then display error message
IF %vers% LSS %minver%  (echo Windows 11 secure guest support is available starting from version 7.0 release)  ELSE (echo Good to go)
rem IF %vers% LSS %minver% (set "light=red") ELSE (set "light=green")
rem echo %light% 

goto :projectstart

:notexistvbm
echo( ***** File not found: Virtual box is not installed use Virtual box version 7.0 or later release)
 exit /b
 
endlocal
rem pause
    
:projectstart 

echo *** Project %ProjectName% ***
echo All Folders Are Short Folder Names:
echo.
echo   Script version: v%scriptver%
echo     Current (CP): %CP%
echo VirtualBox (VBP): %VBP%
echo    Virtual Drive: %VirtDrive%
echo.
rem pause

md Temp
rem Ref: https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vboxmanage-modifyvm.html
rem ref https://docs.oracle.com/en/virtualization/virtualbox/7.0/user/vboxmanage.html#idm46760444264320
echo *** Check/Configure VirtualBox ***
"%VBM%" createvm --name "%VMName%" --register --basefolder "%VMP%"
"%VBM%" modifyvm "%VMName%" --memory %VirtMem% --acpi on --boot1 dvd
"%VBM%" modifyvm "%VMName%" --nic1 nat --nictype1 82540EM --cableconnected1 on
"%VBM%" modifyvm "%VMName%" --ostype Windows11_64
rem "%VBM%" modifyvm "%VMName%" --ostype Windows10_64
          
"%VBM%" modifyvm "%VMName%" --vram 128 --accelerate3d on
"%VBM%" modifyvm "%VMName%" --cpus 4
"%VBM%" modifyvm "%VMName%" --audio dsound --audiocontroller hda
"%VBM%" modifyvm "%VMName%" --clipboard bidirectional --draganddrop bidirectional
"%VBM%" modifyvm "%VMName%" --mouse usbtablet --ioapic on

rem --graphicscontroller none|vboxvga|vmsvga|vboxsvga
"%VBM%" modifyvm "%VMName%" --graphicscontroller vboxsvga

rem --tpm-type=none | 1.2 | 2.0 | host | swtpm
"%VBM%" modifyvm "%VMName%" --tpm-type=2.0

rem "%VBM%" modifyvm "%VMName%" --firmware efi
rem VBoxManage modifyvm "VM name" --firmware efi

rem "%VBM%" modifyvm "%VMName%" --description=Project %ProjectName%

    
       
echo *** Make HDD ***
If EXIST %VMP%\%VHDFile% set Format=FALSE
rem I use this instead of diskpart now it's faster:
"%VBM%" createmedium --filename "%VMP%\%VHDFile%" --size %VHDSize% --format VHD

echo *** Make Attach and Detach Scripts ***
echo select vdisk file="%VMP%\%VHDFile%">Temp\attach-script.txt
echo attach vdisk>>Temp\attach-script.txt
(echo SELECT PART 1)>>Temp\attach-script.txt
echo assign letter=%VirtDrive%>>Temp\attach-script.txt

echo select vdisk file="%VMP%\%VHDFile%">Temp\detach-script.txt
echo detach vdisk>>Temp\detach-script.txt

If [%Format%]==[] (
rem echo Format (created File Above)
rem echo create vdisk file="%VMP%\%VHDFile%" maximum=%VHDSize% type=fixed>Temp\create-script.txt
echo select vdisk file="%VMP%\%VHDFile%">Temp\create-script.txt
echo attach vdisk>>Temp\create-script.txt
echo create partition primary>>Temp\create-script.txt
echo active>>Temp\create-script.txt
echo assign letter=%VirtDrive%>>Temp\create-script.txt
echo format quick fs=ntfs label=%ProjectName%>>Temp\create-script.txt
echo detach vdisk>>Temp\create-script.txt

diskpart /s Temp\create-script.txt
)

echo  *** Attach HDD ***
"%VBM%" storagectl "%VMName%" --name "SATA Controller" --add sata --controller IntelAHCI
        
echo *** Set to 2 SATA ports (defaults to 30, which crashes VM) ***
"%VBM%" storagectl "%VMName%" --name "SATA Controller" --portcount 2
        
"%VBM%" storageattach "%VMName%" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "%VMP%\%VHDFile%"
        
echo *** Attach DVD Image in SATA mode ***    
"%VBM%" storageattach "%VMName%" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium "%CP%\00_Source\%MountISO%"
        
echo *** Set Custom Boot Logo ***
"%VBM%" modifyvm "%VMName%" --bioslogoimagepath "%ToolsPath%\ssOSModderLogo.bmp"

echo *** Run VirtualBox Here ***    
"%VBM%" startvm "%VMName%
echo.
echo Done!
pause
exit /b

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %~1", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B`