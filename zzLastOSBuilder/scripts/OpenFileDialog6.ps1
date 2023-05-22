function Show-OpenFileDialog
{
<#
    .SYNOPSIS
    Shows up an open file dialog.
    .EXAMPLE
    Show-OpenFileDialog
    #>
    [CmdletBinding()]

    # var Result = string.Empty
    # $Result
    param
    (
    [Parameter(Mandatory=$false, Position=0)]
    [System.String]
    $Title ='Windows PowerShell',

    [Parameter(Mandatory=$false, Position=1)]
    [Object]
    # $InitialDirectory ="$Home\Documents",
    $InitialDirectory ="D:\gitrepoprojects\LastOSBuilder\zzLastOSBuilder\ISO\",


    [Parameter(Mandatory=$false, Position=2)]
    [System.String]
    $Filter ='ISO|*.ISO|Everything|*.*'
    )
    Add-Type -AssemblyName PresentationFramework

    $dialog = New-Object -TypeName Microsoft.Win32.OpenFileDialog
    $dialog.Title =$Title
    $dialog.InitialDirectory =$InitialDirectory
    $dialog.Filter =$Filter
    if ($dialog.ShowDialog())
    {
       $dialog.FileName

    }
    else
    {
        Throw'Nothing selected.'
    }
}

#Executing
Show-OpenFileDialog
# $result = $form.ShowDialog()
# return FileName
# set  FileName=$dialog.FileName
# echo FileName = %FileName%
# messagebox.sh
# MessageBox.Show(fileContent, "File Content at path: " + filePath, MessageBoxButtons.OK);
# MessageBox.Show(fileContent, "File Content at path: " + $Result, MessageBoxButtons.OK);

#Write-Host $Result