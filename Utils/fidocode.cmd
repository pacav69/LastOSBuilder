[Interface]
btn_GetISOFido="Download Source ISO",1,8,5,5,140,25,DownloadWithFido,VistalcoDownload_16.png,False,"__Download Official Windows ISO Images with FIDO"


[#DownloadWithFido#]
// ===============================================================================================================================
// Name...........: DownloadWithFido
// Description....: Download and launch the FIDO powershell script in order to allow the user to choose a Win10 ISO to download.
// Syntax.........:
// Parameters.....:
// Return values..:
// Author.........: Homes32
// Remarks........:
// Related........: btn_DownloadWithFido
// ===============================================================================================================================
[DownloadWithFido]
Echo,"Launching Fido..."
Set,%FidoURL%,"https://github.com/pbatard/Fido/releases/latest/download/Fido.ps1.lzma"
If,QUESTION,"You are about to download and run the open source Fido powershell script. This will allow you to choose which Windows ISO image to download from Microsoft's servers.#$x#$xFor more info please visit [https://github.com/pbatard/Fido].#$x#$xAre you ready to continue?",Begin
  WebGet,%FidoURL%,"%ProjectTemp%\Fido.ps1.lzma"
  7z,"x -y #$q%ProjectTemp%\Fido.ps1.lzma#$q -o#$q%ProjectTemp%#$q"
  ShellExecuteEx,Open,"powershell.exe","-noexit –ExecutionPolicy Bypass & #$q%ProjectTemp%\Fido.ps1#$q"
End

