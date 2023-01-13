#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Icon.ico
#AutoIt3Wrapper_Outfile=StartWait.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=Start Wait, Starts and Waits
#AutoIt3Wrapper_Res_Description=Start Wait
#AutoIt3Wrapper_Res_Fileversion=17.9.16.0
#AutoIt3Wrapper_Res_LegalCopyright=Team LastOS
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
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
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

; Copyright (c)2012, Team LastOS
; http://www.LastOS.org

#include <String.au3>
#include <Array.au3>
#include <File.au3>
#include <Constants.au3>

Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1) ; Hide default tray menu items
TraySetIcon()
TraySetClick(8) ;only show the menu when right clicking
$exititem = TrayCreateItem("Force Exit")
TraySetState(1)

HotKeySet("^{PAUSE}", "OnAutoItExit") ; Ctrl + Break will be global hotkey to exit ANY game forcably

;------------------------------------------------------ Debug & Testing -----------------------------------------------------------
Global $CLIparameters = $CMDLine ;because $CMDLine is a constant and cannot be changed

Global $RunItem = ""
Global $PID

Global $iWidth
Global $iHeight
Global $iBitsPP
Global $iRefreshRate

Global $Shift

Global $WinCount = 0
Global $WinTitle[1024]
Global $WinHandle[1024]
Global $WinPosX[1024]
Global $WinPosY[1024]
Global $WinPosW[1024]
Global $WinPosH[1024]

$iWidth = @DesktopWidth
$iHeight = @DesktopHeight
$iBitsPP = @DesktopDepth
$iRefreshRate = @DesktopRefresh

Local $width, $height, $bpp, $freq

$var = WinList()

For $i = 1 To $var[0][0]
	; Only display visble windows that have a title
	If $var[$i][0] <> "" Then ;And IsVisible($var[$i][1]) Then
		; Check if window is minimized
		;$state = WinGetState($var[$i][0], "")
		;; Is the "minimized" value NOT set?
		;If Not BitAND($state, 16) Then
		$WinCount = $WinCount + 1
		$WinHandle[$WinCount] = $var[$i][1]
		$WinTitle[$WinCount] = $var[$i][0]
		$size = WinGetPos($var[$i][0])
		If IsArray($size) Then
			$WinPosX[$WinCount] = $size[0]
			$WinPosY[$WinCount] = $size[1]
			$WinPosW[$WinCount] = $size[2]
			$WinPosH[$WinCount] = $size[3]
		Else
			$WinPosX[$WinCount] = -2
			$WinPosY[$WinCount] = -2
			$WinPosW[$WinCount] = -2
			$WinPosH[$WinCount] = -2
		EndIf
	EndIf
Next

$Shift = False
$InstallMode = False
; Get the Source Path
If $CLIparameters[0] > 0 Then ; At this point anything left "in" the command line is the SourcePath
	For $i = 1 To $CLIparameters[0]
		;MsgBox(0, "Part", $CLIparameters[$i])
		If StringInStr($CLIparameters[$i], "/shift") Then
			$CLIparameters[$i] = StringReplace($CLIparameters[$i], "/shift", "")
			$Shift = True
		EndIf
		If StringInStr($CLIparameters[$i], "/installmode") Then
			$CLIparameters[$i] = StringReplace($CLIparameters[$i], "/installmode", "")
			$InstallMode = True
		EndIf
		;If $InstallMode = True Then
		;	$RunItem = $RunItem & " " & $CLIparameters[$i] ;StringReplace($CLIparameters[$i], "*", "&")
		;Else
		$RunItem = $RunItem & " " & StringReplace($CLIparameters[$i], "*", "&")
		;EndIf
	Next

	;Run('cmd.exe /start /wait /c"echo ' & $RunItem & ' >C:\Test.ini')
	$RunItem = StringStripWS($RunItem, 3)

	;This Section fixes some Linux games, but not all, can stop some working also.
	;If FileExists("Z:\bin") Then
	;	DisplayChangeRes("640", "480", $iBitsPP, $iRefreshRate)
	;EndIf
	If $Shift = False Or (Not FileExists($RunItem)) Then ;The Or Not is required due to the alternative shell method fails if passing perameters anyway  (required to show UAC) so best try something.
		;;;MsgBox(0, "Herte", @WorkingDir & " <> " & $RunItem)
		If StringInStr($RunItem, ".cmd") >= 1 Then ;Hide any cmd's it runs
			$PID = Run($RunItem, @WorkingDir, @SW_HIDE)
		Else
			$PID = Run($RunItem, @WorkingDir, @SW_SHOWNORMAL)
		EndIf

		While ProcessExists($PID)
			Sleep(73)
			Switch TrayGetMsg()
				Case $exititem
					TraySetState(2)
					OnAutoItExit()
					Exit
			EndSwitch
		WEnd
	Else
		;If FileExists($RunItem) Then MsgBox(0, "Herte", @WorkingDir & " <> " & $RunItem)
		ShellExecuteWait($RunItem)
	EndIf
	;Test Mode here
Else
	$RunItem = "D:\ppGames\Insaniquarium\Insaniquarium.exe"
	$PID = Run($RunItem, @WorkingDir, @SW_SHOWNORMAL)
	While ProcessExists($PID)
		Sleep(73)
		Switch TrayGetMsg()
			Case $exititem
				TraySetState(2)
				OnAutoItExit()
				Exit
		EndSwitch
	WEnd
EndIf
If $InstallMode = False Then
	If FileExists("Z:\bin") Then
		DisplayChangeRes($iWidth, $iHeight, $iBitsPP, $iRefreshRate)
		Sleep(400)
	Else
		If @DesktopWidth <> $iWidth Then
			DisplayChangeRes($iWidth, $iHeight, $iBitsPP, $iRefreshRate)
			Sleep(500)
		EndIf
	EndIf
	Sleep(100)
	For $i = 1 To $WinCount
		If $WinTitle[$i] = "Start" Then
		Else
			If $WinTitle[$i] = "Program Manager" Then
			Else
				If $WinTitle[$i] = "VIA HD Audio CPL" Then
				Else
					If $WinTitle[$i] = "Default IME" Then
					Else
						;MsgBox(0, "Here", $WinTitle[$i]) ;This is to test Windows that make ppGames not exit
						If $WinPosX[$i] <> -2 Then
							WinMove($WinHandle[$i], "", $WinPosX[$i], $WinPosY[$i], $WinPosW[$i], $WinPosH[$i])
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	Next
EndIf
ControlShow('[CLASS:Shell_TrayWnd]', '', '')
FileDelete(@TempDir & "\SetupSIn.ini")
FileDelete(@TempDir & "\Launcher.ini")
FileDelete(@AppDataDir & "\Local\Temp\SetupSIn.ini")
FileDelete(@AppDataDir & "\Local\Temp\Launcher.ini")
Exit

Func DisplayChangeRes($width, $height, $bpp, $freq)
	$DM_PELSWIDTH = 0x00080000
	$DM_PELSHEIGHT = 0x00100000
	$DM_BITSPERPEL = 0x00040000
	$DM_DISPLAYFREQUENCY = 0x00400000
	$CDS_TEST = 0x00000002
	$CDS_UPDATEREGISTRY = 0x00000001
	$DISP_CHANGE_RESTART = 1
	$DISP_CHANGE_SUCCESSFUL = 0
	$HWND_BROADCAST = 0xffff
	$WM_DISPLAYCHANGE = 0x007E
	$DEVMODE = DllStructCreate("byte[32];int[10];byte[32];int[6]")
	$b = DllCall("user32.dll", "int", "EnumDisplaySettings", "ptr", 0, "long", 0, "ptr", DllStructGetPtr($DEVMODE))
	If @error Then
		$b = 0
	Else
		$b = $b[0]
	EndIf
	If $b <> 0 Then
		DllStructSetData($DEVMODE, 2, BitOR($DM_PELSWIDTH, $DM_PELSHEIGHT, $DM_BITSPERPEL, $DM_DISPLAYFREQUENCY), 5)
		DllStructSetData($DEVMODE, 4, $width, 2)
		DllStructSetData($DEVMODE, 4, $height, 3)
		DllStructSetData($DEVMODE, 4, $bpp, 1)
		If $freq <> "-1" Then DllStructSetData($DEVMODE, 4, $freq, 5)
		$b = DllCall("user32.dll", "int", "ChangeDisplaySettings", "ptr", DllStructGetPtr($DEVMODE), "int", $CDS_TEST)
		If @error Then
			$b = -1
		Else
			$b = $b[0]
		EndIf
		Select
			Case $b = $DISP_CHANGE_RESTART
				$DEVMODE = ""
				Return 2
			Case $b = $DISP_CHANGE_SUCCESSFUL
				DllCall("user32.dll", "int", "ChangeDisplaySettings", "ptr", DllStructGetPtr($DEVMODE), "int", $CDS_UPDATEREGISTRY)
				DllCall("user32.dll", "int", "SendMessage", "hwnd", $HWND_BROADCAST, "int", $WM_DISPLAYCHANGE, _
						"int", $bpp, "int", $height * 2 ^ 16 + $width)
				$DEVMODE = ""
				Return 1
			Case Else
				$DEVMODE = ""
				Return $b
		EndSelect
	EndIf

	ControlShow('[CLASS:Shell_TrayWnd]', '', '')
EndFunc   ;==>DisplayChangeRes

Func IsVisible($handle)
	If BitAND(WinGetState($handle), 2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>IsVisible

Func OnAutoItExit()
	$EXEName = StringRight($RunItem, StringLen($RunItem) - StringInStr($RunItem, "\", 1, -1))
	If ProcessExists($PID) Then ProcessClose($PID)
	$PID = ProcessExists($EXEName)
	If ProcessExists($PID) Then ProcessClose($PID)
	If $InstallMode = False Then
		If FileExists("Z:\bin") Then
			DisplayChangeRes($iWidth, $iHeight, $iBitsPP, $iRefreshRate)
			Sleep(500)
		Else
			If @DesktopWidth <> $iWidth Then
				DisplayChangeRes($iWidth, $iHeight, $iBitsPP, $iRefreshRate)
				Sleep(500)
			EndIf
		EndIf
		Sleep(100)
		For $i = 1 To $WinCount
			If $WinTitle[$i] = "Start" Then
			Else
				If $WinTitle[$i] = "Program Manager" Then
				Else
					If $WinTitle[$i] = "VIA HD Audio CPL" Then
					Else
						If $WinTitle[$i] = "Default IME" Then
						Else
							WinMove($WinHandle[$i], "", $WinPosX[$i], $WinPosY[$i], $WinPosW[$i], $WinPosH[$i])
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	EndIf
	ControlShow('[CLASS:Shell_TrayWnd]', '', '')
	FileDelete(@TempDir & "\SetupSIn.ini")
	FileDelete(@TempDir & "\Launcher.ini")
	FileDelete(@AppDataDir & "\Local\Temp\SetupSIn.ini")
	FileDelete(@AppDataDir & "\Local\Temp\Launcher.ini")
EndFunc   ;==>OnAutoItExit

Func _GetHwndFromPID($PID)
	$hWnd = 0
	$stPID = DllStructCreate("int")
	Do
		$winlist2 = WinList()
		For $i = 1 To $winlist2[0][0]
			If $winlist2[$i][0] <> "" Then
				DllCall("user32.dll", "int", "GetWindowThreadProcessId", "hwnd", $winlist2[$i][1], "ptr", DllStructGetPtr($stPID))
				If DllStructGetData($stPID, 1) = $PID Then
					$hWnd = $winlist2[$i][1]
					ExitLoop
				EndIf
			EndIf
		Next
		Sleep(100)
	Until $hWnd <> 0
	Return $hWnd
EndFunc   ;==>_GetHwndFromPID
