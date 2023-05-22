
<#
.SYNOPSIS
    Show an Open File Dialog and return the file selected by the user.
.DESCRIPTION
    Long description
.EXAMPLE
    $filePath = Read-OpenFileDialog -WindowTitle "Select Text File Example" -InitialDirectory 'C:\' -Filter "Text files (*.txt)|*.txt"
    if (![string]::IsNullOrEmpty($filePath)) { Write-Host "You selected the file: $filePath" }
    else { "You did not select a file." }
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Read-OpenFileDialog() {
    param(
        [string]$WindowTitle,
        [string]$InitialDirectory,
        [string]$Filter = "All files (*.*)|*.*",
        [switch]$AllowMultiSelect
    )
    Add-Type -AssemblyName System.Windows.Forms
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Title = $WindowTitle
    if (![string]::IsNullOrWhiteSpace($InitialDirectory)) { $openFileDialog.InitialDirectory = $InitialDirectory }
    $openFileDialog.Filter = $Filter
    if ($AllowMultiSelect) { $openFileDialog.MultiSelect = $true }
    $openFileDialog.ShowHelp = $true    # Without this line the ShowDialog() function may hang depending on system configuration and running from console vs. ISE.
    $openFileDialog.ShowDialog() > $null
    if ($AllowMultiSelect) { return $openFileDialog.Filenames } else { return $openFileDialog.Filename }
}
