@echo off

rem "%VBM%" modifyvm "%VMName%" --firmware efi

rem System Set Variables:
for %%f in ("c:\Program Files\Oracle\VirtualBox") do set VBP=%%~sf
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
  
echo(Version=%vers% 
rem ******* 
rem Version 7 of vbox is required for TPM 2.0 used by Win11 install
rem if Version is less then 7 (minver) then display error message
IF %vers% LSS %minver%  (echo Windows 11 secure guest support is available starting from version 7.0 release)  ELSE (echo Good to go)
IF %vers% LSS %minver% (set "light=red") ELSE (set "light=green")
echo %light% 
goto :projectstart
:notexistvbm
echo( ***** File not found: Virtual box is not installed use Virtual box version 7.0 or later release)
 exit /b
 
endlocal
rem pause
    
:projectstart    
 exit /b
    
    
    
rem  Ref: https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vboxmanage-modifyvm.html
rem ref https://docs.oracle.com/en/virtualization/virtualbox/7.0/user/vboxmanage.html#idm46760444264320
rem echo *** Check/Configure VirtualBox ***
rem "%VBM%" createvm --name "%VMName%" --register --basefolder "%VMP%"
rem "%VBM%" modifyvm "%VMName%" --memory %VirtMem% --acpi on --boot1 dvd
rem "%VBM%" modifyvm "%VMName%" --nic1 nat --nictype1 82540EM --cableconnected1 on
rem "%VBM%" modifyvm "%VMName%" --ostype Windows11_64
"%VBM%" modifyvm "%VMName%" --ostype Windows10_64
          
rem "%VBM%" modifyvm "%VMName%" --vram 128 --accelerate3d on
rem "%VBM%" modifyvm "%VMName%" --cpus 4
rem "%VBM%" modifyvm "%VMName%" --audio dsound --audiocontroller hda
rem "%VBM%" modifyvm "%VMName%" --clipboard bidirectional --draganddrop bidirectional
rem "%VBM%" modifyvm "%VMName%" --mouse usbtablet --ioapic on
--graphicscontroller none|vboxvga|vmsvga|vboxsvga
rem "%VBM%" modifyvm "%VMName%" --graphicscontroller vboxsvga
--tpm-type=none | 1.2 | 2.0 | host | swtpm
rem "%VBM%" modifyvm "%VMName%" --tpm-type=2.0
rem "%VBM%" modifyvm "%VMName%" --firmware efi

