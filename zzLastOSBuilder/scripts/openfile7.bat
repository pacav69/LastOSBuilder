@echo off
:loop
set "tempfile=%temp%\file-%random%"
if exist "%tempfile%" goto :loop

call :getfile "c:\"

for /f "delims=" %%a in ('powershell "%tempfile%.ps1" ') do (
   set "filepath=%%~dpa"
   set "filename=%%~nxa"
)
del "%tempfile%.ps1"

echo  path is: "%filepath%"
echo  file is: "%filename%"
pause
goto :EOF

:getfile
(
echo $initialDirectory = "%~1"
echo [System.Reflection.Assembly]::LoadWithPartialName^("System.windows.forms"^) ^| Out-Null
echo $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
echo $OpenFileDialog.initialDirectory = $initialDirectory
echo $OpenFileDialog.filter = "All files (*.*)| *.*"
echo $OpenFileDialog.ShowDialog^(^) ^| Out-Null
echo $OpenFileDialog.filename
) > "%tempfile%.ps1"
goto :EOF