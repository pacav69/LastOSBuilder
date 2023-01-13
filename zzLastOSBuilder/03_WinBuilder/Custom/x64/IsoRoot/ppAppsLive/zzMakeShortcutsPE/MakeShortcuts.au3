#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <String.au3>
#include <Array.au3>
#include <File.au3>

Global $SystemRoot = EnvGet("systemroot")
Global $SystemDrive = EnvGet("systemdrive")
Global $CDDRIVE = ""
Global $CDDRIVE2 = ""
Global $Setup=""

Global $Tem = 0
Global $Test = 0

Global $UserProfile = @UserProfileDir

;Get CDDrive Varible

;SetErrorMode(SEM_FAILCRITICALERRORS);
DllCall("kernel32.dll", "dword", "SetErrorMode", "dword", 1) ; SEM_FAILCRITICALERRORS
RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Windows", "ErrorMode", "REG_DWORD", "2")

$Test = Asc("A")
For $Tem = 2 To 25
	If FileExists(Chr($Test + $Tem) & ":\sources\$Scripts") Then
		$CDDRIVE2 = Chr($Test + $Tem) & ":"
		If FileExists(Chr($Test + $Tem) & ":\sources\install.wim") Then
			$CDDRIVE = Chr($Test + $Tem) & ":"
			ExitLoop
		ElseIf FileExists(Chr($Test + $Tem) & ":\sources\install.esd") Then
			$CDDRIVE = Chr($Test + $Tem) & ":"
			ExitLoop
		EndIf
	EndIf
Next
If $CDDRIVE = "" Then $CDDRIVE = $CDDRIVE2
If $CDDRIVE = "" Then
	For $Tem = 2 To 25
		If FileExists(Chr($Test + $Tem) & ":\sources\install.wim") Then
			$CDDRIVE = Chr($Test + $Tem) & ":"
			ExitLoop
		ElseIf FileExists(Chr($Test + $Tem) & ":\sources\install.esd") Then
			$CDDRIVE = Chr($Test + $Tem) & ":"
			ExitLoop
		EndIf
	Next
EndIf

If FileExists($CDDRIVE&"\sources\Setup.exe") Then
	$Setup = $CDDRIVE&"\sources\Setup.exe"
ElseIf FileExists("X:\sources\Setup.exe") Then
	$Setup = "X:\sources\Setup.exe"
ElseIf FileExists("X:\Setup.exe") Then
	$Setup = "X:\Setup.exe"
EndIf

If $CDDRIVE = "" Then $CDDRIVE = $SystemDrive

;Turn Error Protection Back on
DllCall("kernel32.dll", "dword", "SetErrorMode", "dword", 0) ; SEM_FAILCRITICALERRORS
RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Windows", "ErrorMode", "REG_DWORD", "0")

;this sets the varible to use for the shortcut calls - UnRemark for WinPE_SE if fails 2020
;;;;;$User = @UserProfileDir & "\Desktop\"
$User = @DesktopCommonDir

Local $FileList = _FileListToArray($CDDRIVE & "\", "*.xml", 1) ;1 = Files only

Local $Hasx64 = False
Local $Hasx86 = False

Local $Icon = ""
Local $ssWPIIcon = ""

;;Local $FileList = _FileListToArray("F:\ssOSModder_v0.7.0.10_CosmOS_v7.3\99Output\CosmOS\", "*.xml", 1) ;1 = Files only

;Run ssWPIMon.exe
If FileExists("X:\Program Files\ssTek\ssWPIMon.exe") Then Run ("X:\Program Files\ssTek\ssWPIMon.exe")

If @error = 1 Then
	MsgBox(0, "", "No Folders Found.")
	;Exit
EndIf
If @error = 4 Then
	MsgBox(0, "", "No Files Found.")
	;Exit
EndIf
Local $XMLFiles = UBound($FileList) - 1
If @error = 1 Then ;Not an Array
	$XMLFiles = -1
	;Exit
EndIf
Local $ImageName = ""
Local $MadeLinks = False
If $XMLFiles >= 0 Then
	For $F = 0 To $XMLFiles
		$ImageName = StringLeft($FileList[$F], StringLen($FileList[$F]) - 4) ;Remove .xml
		$Under = StringInStr($ImageName, "_") + 1
		If $Under > 1 Then ;Don't do names without underscores
			$ImageName = StringMid($ImageName, $Under, StringLen($ImageName) - $Under + 1)
			If $ImageName <> "x86" And $ImageName <> "x64" Then ;Ignore these if they exist too
				If StringInStr($ImageName, "x86") >= 1 Then $Hasx86 = True
				If StringInStr($ImageName, "x64") >= 1 Then $Hasx64 = True
				If FileExists($CDDRIVE & "\Icon_" & $ImageName & ".ico") Then
					FileCreateShortcut($Setup, $User & "\Install " & $ImageName & ".lnk", $CDDRIVE&"\sources", "/unattend:" & Chr(34) & $CDDRIVE & "\" & $FileList[$F] & Chr(34), "Install " & $ImageName, $CDDRIVE & "\Icon_" & $ImageName & ".ico", "", 0, @SW_SHOWNORMAL)
					$MadeLinks = True
				ElseIf FileExists($CDDRIVE & "\Icon.ico") Then
					FileCreateShortcut($Setup, $User & "\Install " & $ImageName & ".lnk", $CDDRIVE&"\sources", "/unattend:" & Chr(34) & $CDDRIVE & "\" & $FileList[$F] & Chr(34), "Install " & $ImageName, $CDDRIVE & "\Icon.ico", "", 0, @SW_SHOWNORMAL)
					$MadeLinks = True
				Else
					FileCreateShortcut($Setup, $User & "\Install " & $ImageName & ".lnk", $CDDRIVE&"\sources", "/unattend:" & Chr(34) & $CDDRIVE & "\" & $FileList[$F] & Chr(34), "Install " & $ImageName, "", "", 0, @SW_SHOWNORMAL)
					$MadeLinks = True
				EndIf
			EndIf
		EndIf
	Next
EndIf

If FileExists($CDDRIVE & "\Autounattend.xml") Then ;If using Single AutoUnattend.xml we'll add that and both ssWPI versions
	If FileExists($CDDRIVE & "\Icon.ico") Then $Icon = $CDDRIVE & "\Icon.ico"
	FileCreateShortcut($Setup, $User & "\Install Windows.lnk", $CDDRIVE&"sources", "/unattend:" & Chr(34) & $CDDRIVE & "\Autounattend.xml" & Chr(34), "Install Windows", $Icon, "", 0, @SW_SHOWNORMAL)
	$MadeLinks = True
	$Hasx86 = True
	$Hasx64 = True
EndIf

If $MadeLinks = False Then
	FileCreateShortcut($Setup, $User & "\Install Windows.lnk", $CDDRIVE&"\sources", "", "Install Windows", $CDDRIVE & "", "", 0, @SW_SHOWNORMAL)
EndIf

;Set ssWPI_Icon.ico supported
If FileExists($CDDRIVE & "\ssWPI_Icon.ico") Then
	$ssWPIIcon = $CDDRIVE & "\ssWPI_Icon.ico"
Else
	$ssWPIIcon = ""
EndIf

If FileExists($CDDRIVE & "\sources\$ssWPI\ssWPI.exe") Then
	If FileExists($CDDRIVE & "\sources\$ssWPI\x64Disabled.ini") Then
		FileCreateShortcut($CDDRIVE & "\sources\$ssWPI\ssWPI.exe", $User & "\ssWPI.lnk", $CDDRIVE & "\sources\$ssWPI", "-NewSetup", "Select the Applications for the Installing OS", $ssWPIIcon, "", 0, @SW_SHOWNORMAL)
	Else ;Show both x86 and x64
		;Makes ssWPI Links if the Image Titles had Arch's provided, else it'll show both
		If $Hasx86 = True Then FileCreateShortcut($CDDRIVE & "\sources\$ssWPI\ssWPI.exe", $User & "\ssWPI (x86).lnk", $CDDRIVE & "\sources\$ssWPI", "-NewSetup -x86", "Select the Applications for the Installing x86 OS", $ssWPIIcon, "", 0, @SW_SHOWNORMAL)
		If $Hasx64 = True Then FileCreateShortcut($CDDRIVE & "\sources\$ssWPI\ssWPI.exe", $User & "\ssWPI (x64).lnk", $CDDRIVE & "\sources\$ssWPI", "-NewSetup -x64", "Select the Applications for the Installing x64 OS", $ssWPIIcon, "", 0, @SW_SHOWNORMAL)

		If $Hasx86 = False And $Hasx64 = False Then ;Show both if both were false
			FileCreateShortcut($CDDRIVE & "\sources\$ssWPI\ssWPI.exe", $User & "\ssWPI (x86).lnk", $CDDRIVE & "\sources\$ssWPI", "-NewSetup -x86", "Select the Applications for the Installing x86 OS", $ssWPIIcon, "", 0, @SW_SHOWNORMAL)
			FileCreateShortcut($CDDRIVE & "\sources\$ssWPI\ssWPI.exe", $User & "\ssWPI (x64).lnk", $CDDRIVE & "\sources\$ssWPI", "-NewSetup -x64", "Select the Applications for the Installing x64 OS", $ssWPIIcon, "", 0, @SW_SHOWNORMAL)
		EndIf
	EndIf
EndIf

;Refresh Explorer
Send("{F5}")

ControlSend('Program Manager', '', '', '{F5}')

$Hwnd = WinGetHandle("classname=Progman")
DllCall("user32.dll", "long", "SendMessage", "hwnd", $hWnd, "int", 0x111, "int", 28931, "int", 0)

Const $WM_SETTINGCHANGE = 0x001A
Const $HWNDBROADCAST = 0xFFFF
Const $szParam = "Environment"

DllCall("user32.dll", "int", "SendMessage", "hwnd", $HWNDBROADCAST, "int", $WM_SETTINGCHANGE, "int", 0, "int", $szParam)
Run("rundll32 user32.dll,UpdatePerUserSystemParameters")
