#filename: openfileselectdialog.ps1
<#
.VERSION
    v1.0
.Author
    PCMan

.SYNOPSIS
    Show an Open File Dialog and return the file selected by the user.
.DESCRIPTION
    Long description
.EXAMPLE
    $file = Open-FileDialog c:\
.INPUTS
   $file = Open-FileDialog [InitialDirectory] eg c:\
.OUTPUTS
    $file = filepath and filename from Open-FileDialog
.NOTES
    General notes

#>

# Thomas Rayner is awesome. Everyone should be like Thomas. Mostly ganked from here: https://thomasrayner.ca/open-file-dialog-box-in-powershell/
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
Write-Host "this ISO is " $file
