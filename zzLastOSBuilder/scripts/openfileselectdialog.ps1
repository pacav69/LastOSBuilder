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
    called by "powershell.exe -file openfileselectdialog.ps1 [InitialDirectory] "
   $file = Open-FileDialog [InitialDirectory] eg c:\
.OUTPUTS
    $file = filepath and filename from Open-FileDialog
    The value of $file is stored into variable tmp
    that can be read by the calling batch file
    $file | Out-File -Encoding "ASCII" tmp
#>

# Thomas Rayner is awesome. Everyone should be like Thomas. Mostly ganked from here: https://thomasrayner.ca/open-file-dialog-box-in-powershell/

$param1=$args[0]
# $param2=$args[1]

# write-host param1value = $param1
# write-host param2value = $param2

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
        # $param1 is the first argument from the command line
        $FileBrowser.InitialDirectory = $param1
    }
    else{
        $fileBrowser.InitialDirectory = [Environment]::GetFolderPath('Documents')
    }
    $FileBrowser.Filter = 'ISO Files (*.iso)|*.iso|All Files (*.*)|*.*'
    if ($Title) { $FileBrowser.Title = $Title }


[void]$FileBrowser.ShowDialog()
$FileBrowser.FileName
}

$file = Open-FileDialog $param1
# Write-Host "the ISO is " $file
$file | Out-File -Encoding "ASCII"  tmp.txt
