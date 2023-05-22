@echo off
set cmd=Add-Type -AssemblyName System.Windows.Forms;$f=new-object Windows.Forms.OpenFileDialog;$f.InitialDirectory='D:\gitrepoprojects\LastOSBuilder\zzLastOSBuilder\scripts\';$f.Filter='Text Files(*.txt)^|*.txt^|All Files(*.*)^|*.*';$f.Multiselect=$true;[void]$f.ShowDialog();if($f.Multiselect){$f.FileNames}else{$f.FileName}
@REM set cmd=Add-Type -AssemblyName System.Windows.Forms;$f=new-object Windows.Forms.OpenFileDialog;$f.InitialDirectory=[environment]::GetFolderPath('D:\gitrepoprojects\LastOSBuilder\zzLastOSBuilder\scripts\');$f.Filter='Text Files(*.txt)^|*.txt^|All Files(*.*)^|*.*';$f.Multiselect=$true;[void]$f.ShowDialog();if($f.Multiselect) {$f.FileNames}else{$f.FileName}
set pwshcmd=powershell -noprofile -command "&{%cmd%}"
for /f "tokens=* delims=" %%I in ('%pwshcmd%') do call :sum "%%I" ret
echo =========
echo --%ret%--
@REM echo FileName = %FileName%
pause
exit /B
:sum [mud] [ret]
echo "%~1"
set FileName=%FileName% "%~1"
set ret=%FileName%
exit /B