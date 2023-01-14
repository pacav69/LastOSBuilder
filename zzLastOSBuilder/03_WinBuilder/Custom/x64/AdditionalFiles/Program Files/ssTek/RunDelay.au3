#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.

; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http:;www.gnu.org/licenses/>.

; Modified by Ghost 4-21-2012
; Copyright (c)2012 ssTEKies
; http:;www.ssTEK.com

#include <String.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

TraySetState(2)

#Region ### START Koda GUI section ### Form=C:\Users\Administrator\Desktop\Main.kxf
#EndRegion ### END Koda GUI section ###


Dim $Width
Dim $Y
$Width = 340
$Y = 280

;Always Wait for PENetwork (While using LivePE)
;ProcessWait ("PENetwork.exe", 10)

; wait for things to get done before continuing on ...
;If StringInStr($CmdLineRaw, "-wait", 0) >0 Then
;	While ProcessExists ("PENetwork.exe" ) ;Remove to allow working with PENetwork staying open in Tray.
;	Wend
;	ProcessWait ("explorer.exe", 120)
;EndIf

Sleep (300)


;; fix the white out ( dead ) shortcuts/icon's issue in PE if usin a DVD
;For $i = 1 To 10
;	Local $var = RegEnumKey("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\CD Burning\Drives", $i)
;	If @error = 0 Then
;		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\CD Burning\Drives\" & $var & "\Current Media", "Live FS", "REG_DWORD", "1")
;	EndIf
;	ExitLoop
;Next

;; run the HDAudio detection tool, so this runs until the drivers are loaded ( the .exe in program files\realtek\audio\hda\RtHDVCpl.exe in PE :)
;Run (@ProgramFilesDir & "\ssTek\RunHDAudio.exe",@WindowsDir)


;GUISetState(@SW_SHOW)

; just a simple box to let the user know its doin sumtin usefull, SetupS is the horse, that code is further down ;) ..
SplashTextOn("Generate Shorcuts", " SetupS - Generating shortcuts, Please wait ....", $Width, 42, -1, $Y, 52, "Arial", 10)


;Run (@ProgramFilesDir & "\ssTek\ppAppsGenPE.exe",@WindowsDir)
_CreateFileAssociation("apz", "apz" & "SetupS", "SetupS.SendTo", @ProgramFilesDir & "\SetupS.SendTo\SetupS.exe")
_CreateFileAssociation("app", "app" & "SetupS", "SetupS.SendTo", @ProgramFilesDir & "\SetupS.SendTo\SetupS.exe")

; create a shortcut on the start menu so if user needs to -Regen they can
FileCreateShortcut(@ProgramFilesDir & "\ssTek\RunDelay.exe",@ProgramsDir & "\SetupS Generator.lnk",@ProgramFilesDir & "\ssTek","", "Run this to initalize ppAppsLive shorcuts again", "", "", "", @SW_SHOWNORMAL)

;; run the ssWPIMon.exe, so when install starts it can copy over the .ini files to the new C:\ drive
;Run (@ProgramFilesDir & "\ssTek\ssWPIMon.exe",@ProgramFilesDir&"\ssTek")
;
;Another delay to see if you have a slow USB disk in or not
Sleep (500)


; variables to make the functions work, set 1 to true, and 1 to false, but its not used, so I left it as is .. update it more later
Global $CountDown = 9
Global $ScanppAppsLive = True
Global $ScanppApps = False


$file = FileOpen("X:\Windows\ppAppDrive.ini", 2)
; Check if file opened for writing OK
If $file = -1 Then
Else
	FileWrite($file, "X:")
	FileClose($file)
EndIf

	$Test = Asc("A") ; here is SetupS call to generate shortcuts and all that stuff ...
	For $Tem = 2 To 25
		;SetErrorMode(SEM_FAILCRITICALERRORS);
		DllCall("kernel32.dll", "dword", "SetErrorMode", "dword", 1) ; SEM_FAILCRITICALERRORS
		RegWrite ( "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Windows" ,"ErrorMode", "REG_DWORD", "2" )

		If $ScanppAppsLive = True And FileExists(Chr($Test + $Tem) & ":\ppAppsLive") Then
			;Turn Error Protection Back on
			DllCall("kernel32.dll", "dword", "SetErrorMode", "dword", 0) ; SEM_FAILCRITICALERRORS
			RegWrite ( "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Windows" ,"ErrorMode", "REG_DWORD", "0" )

			RunWait (@ProgramFilesDir & "\SetupS.SendTo\SetupS.exe " & Chr($Test + $Tem) & ":\ppAppsLive" & " -Regen", @ProgramFilesDir & "\SetupS.SendTo")
		EndIf
		;Turn Error Protection Back on
		DllCall("kernel32.dll", "dword", "SetErrorMode", "dword", 0) ; SEM_FAILCRITICALERRORS
		RegWrite ( "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Windows" ,"ErrorMode", "REG_DWORD", "0" )

	Next
	RunWait (@ProgramFilesDir & "\SetupS.SendTo\SetupS.exe " &  @ProgramFilesDir & "\ppAppsLive" & " -Regen", @ProgramFilesDir & "\SetupS.SendTo")

; another box to let user know SetupS shortcut gen is done ( yea hope the timming is right ), yep seems to be :)
SplashTextOn("Generate Shorcuts", " SetupS - Shortcut Generation done!", $Width, 42, -1, $Y, 52, "Arial", 5)
Sleep (3000) ; 4 seconds and it closes
SplashOff () ; box disappears .. desktop ready to use ..

	Exit
; create file association for SetupS in PE, so things are a little smoother for the SetupS users in PE ..
Func _CreateFileAssociation($Extension, $ClassName, $Description, $ExeProgram)
	Local $S, $E2, $S2
	If StringLeft($Extension, 1) <> "." Then $Extension = "." & $Extension
	$S = RegRead("HKEY_CLASSES_ROOT", $Extension)
	If $S <> "" Then ;we have an association already
		If StringLen($S) > 6 Then ;min length
			If StringRight($S, 6) = "SetupS" Then
				Return 50 ;done already, quit (assume backup is OK too)
			EndIf
		EndIf
		;Backup OLD value, its possible for another app to steal association
		;in which case we just restore our association without doing a backup of the stolem ass.
		$E2 = "SetupS.Bak"
		$S2 = RegRead("HKEY_CLASSES_ROOT\" & $Extension, $E2) ;check its not already backed up
		If $S2 = "" Or $S2 = "Error; Bad Value Type" Then ;we haven't already have backed up this key in the past
			RegWrite("HCEY_CLASSES_ROOT\" & $Extension, $E2, "REG_SZ", $S) ;old value backed up
		EndIf
	EndIf
	;procede if not already a SetupS association
	RegWrite("HKEY_CLASSES_ROOT\" & $Extension, "", "REG_SZ", $ClassName) ; create a value for this key that contains the classname
	RegWrite("HKEY_CLASSES_ROOT\" & $ClassName & "\Shell\Open\Command", "", "REG_SZ", $ExeProgram & " " & Chr(34) & "%1" & Chr(34)) ; set its value to the command line
	RegWrite("HKEY_CLASSES_ROOT\" & $ClassName & "\defaulticon", "", "REG_SZ", $ExeProgram & ",0")
	DllCall("shell32.dll", "int", "SHChangeNotify", "long", 0x8000000, "long", 0, "long", 0, "long", 0)
EndFunc   ;==>_CreateFileAssociation

;SetupS x:\ppAppsLive -Regen