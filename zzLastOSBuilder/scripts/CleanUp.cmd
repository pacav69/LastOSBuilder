@REM CleanUp.cmd



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

