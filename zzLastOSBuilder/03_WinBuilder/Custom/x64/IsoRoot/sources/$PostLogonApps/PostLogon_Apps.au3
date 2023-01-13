#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


#NoTrayIcon
TraySetState(2)

#include <String.au3>
#include <Array.au3>
#include <File.au3>

Local $FileList = _FileListToArray(@ScriptDir & "\", "*.exe", 1) ;1 = Files only

If @error = 1 Then
	;MsgBox(0, "", "No Folders Found.")
	;Exit
EndIf
If @error = 4 Then
	;MsgBox(0, "", "No Files Found.")
	;Exit
EndIf
Local $EXEFiles = UBound($FileList) - 1
If @error = 1 Then ;Not an Array
	$EXEFiles = -1
	;Exit
EndIf

If $EXEFiles >= 1 Then
	For $F = 1 To $EXEFiles
		$EXEName = $FileList[$F]
		;If StringLower(StringRight($EXEName, 4)) = ".exe" Then ;Not Required as all files in array are .exe
		If StringLower($EXEName) = StringLower(@ScriptName) Then
			;MsgBox (0, "GOTCHA", $EXEName)
		Else
			;MsgBox (0, "Here", $EXEName)
			RunWait(@ScriptDir&"\"&$EXEName)
		EndIf
		;EndIf

	Next
EndIf