#filename: openfileselectdialog.ps1
<#
.NOTES
  Version         : 1.0
  Author          : PCMan
  Creation Date   : 22May2023
  Purpose/Change  : Initial development

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
#>

# Thomas Rayner is awesome. Everyone should be like Thomas. Mostly ganked from here: https://thomasrayner.ca/open-file-dialog-box-in-powershell/
# $w = $args[0]
$param1=$args[0]
$param2=$args[1]

write-host param1value = $param1
write-host param2value = $param2

function Open-FileDialog{
        [cmdletBinding()]
        param(
            [Parameter()]
            [ValidateScript({Test-Path $_})]
            [String]
            $InitialDirectory,
            [string]
            $Title = "Select ISO File",
            [parameter(Mandatory=$false)]
            [string]
            $NamedParam1
        )
    Add-Type -AssemblyName System.Windows.Forms
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog
    if($InitialDirectory){
        # $FileBrowser.InitialDirectory = $InitialDirectory
        $FileBrowser.InitialDirectory = $param1
    }
    else{
    $fileBrowser.InitialDirectory = [Environment]::GetFolderPath('Desktop')
    }
    $FileBrowser.Filter = 'ISO (*.iso)|*.iso|All Files (*.*)|*.*'
    if ($Title) { $FileBrowser.Title = $Title }


[void]$FileBrowser.ShowDialog()
$FileBrowser.FileName


}

# $file = Open-FileDialog $Environment
Write-Host "the param is" $NamedParam1
$InitialDirectory = "D:\gitrepoprojects\LastOSBuilder\zzLastOSBuilder\ISO\"
# D:\gitrepoprojects\LastOSBuilder\zzLastOSBuilder\ISO\
$file = Open-FileDialog $param1
Write-Host "the ISO is " $file
$file | Out-File -Encoding "ASCII" tmp
