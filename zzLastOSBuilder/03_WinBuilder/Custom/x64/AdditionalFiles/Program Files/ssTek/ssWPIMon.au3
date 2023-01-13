#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
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
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

; Copyright (c)2013, Team LastOS
; http://www.LastOS.org



#include <String.au3>
TraySetState(2)
While 1
	Sleep(1000)
	$Test = Asc("A")
	For $Tem = 2 To 25
		$TMP = Chr($Test + $Tem) & ":"
		;SetErrorMode(SEM_FAILCRITICALERRORS);
		DllCall("kernel32.dll", "dword", "SetErrorMode", "dword", 1) ; SEM_FAILCRITICALERRORS
		RegWrite ( "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Windows" ,"ErrorMode", "REG_DWORD", "2" )
		If FileExists($TMP & "\WinPEpge.sys") Then
			If FileExists($TMP & "\Windows\regedit.exe") Then
				FileCopy("X:\SortMenu.ini", $TMP & "\", 1)
				FileCopy("X:\KeepMenu.ini", $TMP & "\", 1)
				FileCopy("X:\RebootPC.ini", $TMP & "\", 1)
				FileCopy("X:\ppAppDrive.ini", $TMP & "\Windows\", 1)
				FileCopy("X:\ppGameDrive.ini", $TMP & "\Windows\", 1)
				FileCopy("X:\ssTekSetupSMenu.ini", $TMP & "\Windows\", 1)

				FileCopy("X:\SetupSMenu.ini", $TMP & "\Windows\", 1)
				FileCopy("X:\ssTekSetupSMenu.ini", $TMP & "\", 1)

				FileCopy("X:\LastXPSetupSMenu.ini", $TMP & "\Windows\", 1)
				FileCopy("X:\LastOSSetupSMenu.ini", $TMP & "\Windows\", 1)
				FileCopy("X:\KazzSetupSMenu.ini", $TMP & "\Windows\", 1)
				If FileExists($TMP & "\ssWPI_Install_List.ini") = True Then Exit
				If FileExists($TMP & "\ssWPI_Install_List.ini") = True Then ExitLoop
				If FileExists($TMP & "\ssWPI.ini") = True Then Exit
				If FileExists($TMP & "\ssWPI.ini") = True Then ExitLoop
				;Moved below to here so it will copy twice before the app ends
				FileCopy("X:\ssWPI.ini", $TMP & "\", 1)
				FileCopy("X:\ssWPI_Install_List.ini", $TMP & "\", 1)
			EndIf
		EndIf
		;Turn Error Protection Back on
		DllCall("kernel32.dll", "dword", "SetErrorMode", "dword", 0) ; SEM_FAILCRITICALERRORS
		RegWrite ( "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Windows" ,"ErrorMode", "REG_DWORD", "0" )
	Next
WEnd
Exit