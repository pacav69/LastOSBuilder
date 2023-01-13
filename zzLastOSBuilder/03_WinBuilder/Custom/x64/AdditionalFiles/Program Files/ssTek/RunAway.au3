#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <String.au3>

TraySetState(2)
;Run (@ProgramFilesDir & "\ssTek\RunDelay.exe -wait",@WindowsDir,@SW_HIDE) ;Removed Wait
Run (@ProgramFilesDir & "\ssTek\RunDelay.exe",@WindowsDir,@SW_HIDE)