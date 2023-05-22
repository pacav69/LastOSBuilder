[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | out-null

$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.initialDirectory = "D:\gitrepoprojects\LastOSBuilder\zzLastOSBuilder\scripts\"
$OpenFileDialog.filter = "Text (*.txt)|*.txt|All files (*.*)|*.*"
$OpenFileDialog.ShowDialog()
$OpenFileDialog.filename