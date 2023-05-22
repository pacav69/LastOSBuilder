<!-- : starting html comment

:: FileSelector.bat
@echo off
for /f "tokens=* delims=" %%p in ('mshta.exe "%~f0"') do (
    set "file=%%~fp"
)
echo/
if not "%file%" == "" (
    echo selected  file is : %file%
)
echo/
exit /b
-->
<Title>== FILE SELECTOR==</Title>
<body>
    <script language='javascript'>
    function pipeFile() {

         var file=document.getElementById('file').value;
         var fso= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
         close(fso.Write(file));

    }
    </script>
<input type='file' name='file' size='30'>
</input><hr><button onclick='pipeFile()'>Submit</button>
</body>
1.1 - without submit form proposed by rojo (see comments):

<!-- : starting html comment

:: FileSelector.bat
@echo off
for /f "tokens=* delims=" %%p in ('mshta.exe "%~f0"') do (
    set "file=%%~fp"
)
echo/
if not "%file%" == "" (
    echo selected  file is : "%file%"
)
echo/
exit /b
-->
<Title>== FILE SELECTOR==</Title>
<body>
    <script language='javascript'>
    function pipeFile() {

         var file=document.getElementById('file').value;
         var fso= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
         close(fso.Write(file));

    }
    </script>
<input id='file' type='file' name='file' size='30' onchange='pipeFile()' >
</input>
<hr>
<button onclick='pipeFile()'>Submit</button>
<script>document.getElementById('file').click();</script>
</body>
2.As you already using powershell/net you can create selfcompiled jscript.net hybrid.It will not require temp cs file for compilation and will directly use the built-in jscrript.net compiler.There's no need of powershell too and the code is far more readable:

@if (@X)==(@Y) @end /* JScript comment
@echo off

:: FolderSelectorJS.bat
setlocal

for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)

if not exist "%~n0.exe" (
    "%jsc%" /nologo /out:"%~n0.exe" "%~dpsfnx0"
)

for /f "tokens=* delims=" %%p in ('"%~n0.exe"') do (
    set "folder=%%p"
)
if not "%folder%" == "" (
    echo selected folder  is %folder%
)

endlocal & exit /b %errorlevel%

*/

import System;
import System.Windows.Forms;

var  f=new FolderBrowserDialog();
f.SelectedPath=System.Environment.CurrentDirectory;
f.Description="Please choose a folder.";
f.ShowNewFolderButton=true;
if( f.ShowDialog() == DialogResult.OK ){
    Console.Write(f.SelectedPath);