@echo off
FindDrive Boot\bcd
REM HDD C-Z
If %ERRORLEVEL%==0 set HDD=C:
If %ERRORLEVEL%==25 set HDD=Z:
If %ERRORLEVEL%==24 set HDD=Y:
If %ERRORLEVEL%==23 set HDD=X:
If %ERRORLEVEL%==22 set HDD=W:
If %ERRORLEVEL%==21 set HDD=V:
If %ERRORLEVEL%==20 set HDD=U:
If %ERRORLEVEL%==19 set HDD=T:
If %ERRORLEVEL%==18 set HDD=S:
If %ERRORLEVEL%==17 set HDD=R:
If %ERRORLEVEL%==16 set HDD=Q:
If %ERRORLEVEL%==15 set HDD=P:
If %ERRORLEVEL%==14 set HDD=O:
If %ERRORLEVEL%==13 set HDD=N:
If %ERRORLEVEL%==12 set HDD=M:
If %ERRORLEVEL%==11 set HDD=L:
If %ERRORLEVEL%==10 set HDD=K:
If %ERRORLEVEL%==9 set HDD=J:
If %ERRORLEVEL%==8 set HDD=I:
If %ERRORLEVEL%==7 set HDD=H:
If %ERRORLEVEL%==6 set HDD=G:
If %ERRORLEVEL%==5 set HDD=F:
If %ERRORLEVEL%==4 set HDD=E:
If %ERRORLEVEL%==3 set HDD=D:
If %ERRORLEVEL%==2 set HDD=C:
rem %HDD%

FindDrive sources\boot.wim
REM CDROM C-Z
If %ERRORLEVEL%==0 set CDROM=C:
If %ERRORLEVEL%==25 set CDROM=Z:
If %ERRORLEVEL%==24 set CDROM=Y:
If %ERRORLEVEL%==23 set CDROM=X:
If %ERRORLEVEL%==22 set CDROM=W:
If %ERRORLEVEL%==21 set CDROM=V:
If %ERRORLEVEL%==20 set CDROM=U:
If %ERRORLEVEL%==19 set CDROM=T:
If %ERRORLEVEL%==18 set CDROM=S:
If %ERRORLEVEL%==17 set CDROM=R:
If %ERRORLEVEL%==16 set CDROM=Q:
If %ERRORLEVEL%==15 set CDROM=P:
If %ERRORLEVEL%==14 set CDROM=O:
If %ERRORLEVEL%==13 set CDROM=N:
If %ERRORLEVEL%==12 set CDROM=M:
If %ERRORLEVEL%==11 set CDROM=L:
If %ERRORLEVEL%==10 set CDROM=K:
If %ERRORLEVEL%==9 set CDROM=J:
If %ERRORLEVEL%==8 set CDROM=I:
If %ERRORLEVEL%==7 set CDROM=H:
If %ERRORLEVEL%==6 set CDROM=G:
If %ERRORLEVEL%==5 set CDROM=F:
If %ERRORLEVEL%==4 set CDROM=E:
If %ERRORLEVEL%==3 set CDROM=D:
If %ERRORLEVEL%==2 set CDROM=C:
rem  %CDROM%

rem Setlocal

rem below line sets to current drive if finddrive fails.
If "%CDROM%"=="" set CDROM=%~d0



::Set path to bcdedit.exe (e.g. C:\Windows\System32\bcdedit.exe)
Set BCDEDIT=%~dp0bcdedit.exe

::Set path to BCD Store (e.g. C:\boot\BCD)
Set STORE=%HDD%\boot\bcd

cls
echo Press a key to add LivePE to the HDD and BCD, or close the window.
pause

rem copy needed files
echo f | XCOPY /Y /E /I /Q "%CDROM%\sources\boot.wim" "%HDD%\boot\boot.wim"
echo f | XCOPY /Y /E /I /Q /H "%~dp0boot.sdi" "%HDD%\boot\boot.sdi"

echo Exporting the system BCD store to BcdTemp
%BCDEDIT% /export %systemdrive%\Windows\BcdTemp
if errorlevel 1 echo Error - we need to have admin privileges.
if errorlevel 1 goto Endit

rem Set the name of the Winpe .wim file
set WimNm=boot.wim
rem Set the name of the WinPE .sdi file
set SdiNm=boot.sdi
rem Set the drive where the two WinPE boot files are located ( x: with no \ )
set WPDrv=%HDD%
rem Set the folder path to the WinPE boot files ( no drive letter, no trailing \ )
set WPPth=\boot
rem Description that shows up in the boot menu
set WPNam=LivePE
set WPDes="%WPNam%"
rem Create the osloader and device options entries in the bcd store.
rem Get the randomly created GUID numbers that uniquely identify our two entries.

if exist enum.txt (del /q /f enum.txt)
bcdedit.exe /enum >enum.txt
for /f "delims=" %%i in (enum.txt) do (
if "%%i"=="description             %WPNam%" (
echo.
echo %%i
if exist enum.txt (del /q /f enum.txt)
goto found
)
)
if exist enum.txt (del /q /f enum.txt)


For /F "tokens=3 delims= " %%1 in ('%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /create /application OSLOADER /d %WPDes%') do set guid1=%%1
echo Osloader entry id is %guid1%

For /F "tokens=3 delims= " %%1 in ('%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /create /device /d %WPDes%') do set guid2=%%1
echo Device options entry id is %guid2%

echo Setting items in the osloader entry

%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /set %guid1% device ramdisk=[%WPDrv%]%WPPth%\%WimNm%,%guid2%
%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /set %guid1% osdevice ramdisk=[%WPDrv%]%WPPth%\%WimNm%,%guid2%
%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /set %guid1% path \windows\system32\boot\winload.exe
%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /set %guid1% locale en-US
%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /set %guid1% inherit {bootloadersettings}
%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /set %guid1% systemroot \windows
%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /set %guid1% detecthal Yes
%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /set %guid1% winpe Yes
%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /set %guid1% ems No


echo Setting items in the device options entry
%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /set %guid2% ramdisksdidevice partition=%WPDrv%
%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /set %guid2% ramdisksdipath %WPPth%\%SdiNm%

echo Setting bootmgr to include the WinPE entry in the boot display list
%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /set {bootmgr} displayorder %guid1% /addlast

%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /set {bootmgr} timeout 3


echo Display bootmgr and the two new entries
%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /enum {bootmgr}
%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /enum %guid1%
%BCDEDIT% /store %systemdrive%\Windows\BcdTemp /enum %guid2%
echo.

If errorlevel 1 echo Error - something went awry. Not importing the temporary store.
If errorlevel 1 goto Endit

echo Ready to import the temporary store into bcd system store...

echo Importing BcdTemp into the system BCD store.
%BCDEDIT% /import %systemdrive%\Windows\BcdTemp

:EndIt

pause
exit

:found
echo.
echo * Already exists in BCD Menu, aborting menu changes *
echo.
pause
exit