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
    $fileBrowser.InitialDirectory = [Environment]::GetFolderPath('MyDocuments')
    }$FileBrowser.Filter = 'ISO (*.iso)|*.iso|All Files (*.*)|*.*'

[void]$FileBrowser.ShowDialog()
$FileBrowser.FileName

}

$file = Open-FileDialog D:\gitrepoprojects\LastOSBuilder\zzLastOSBuilder\ISO\
# Set-Variable $myfile=$file
# Write-Host $file
# Write-Host "this myfile is " $myfile
Write-Host "this ISO is " $file
# $content = Get-Content $file
# $content