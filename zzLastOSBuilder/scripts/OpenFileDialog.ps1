#Thomas Rayner is awesome. Everyone should be like Thomas. Mostly ganked from here: https://thomasrayner.ca/open-file-dialog-box-in-powershell/
function Open-FileDialog {
        [cmdletBinding()]
        param(
            [Parameter()]
            [ValidateScript({Test-Path $_})]
            [String]
            $InitialDirectory
        )
    Add-Type -AssemblyName System.Windows.Forms
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog
    if($InitialDirectory){
        $FileBrowser.InitialDirectory = $InitialDirectory
    }

    else{
    $fileBrowser.InitialDirectory = [Environment]::GetFolderPath('desktop')
    }$FileBrowser.Filter = 'Text (*.txt)|*.txt|CSV (*.txt)|*.txt|All Files (*.*)|*.*'

[void]$FileBrowser.ShowDialog()
$FileBrowser.FileName

}

$file = Open-FileDialog C:\
$content = Get-Content $file
$content