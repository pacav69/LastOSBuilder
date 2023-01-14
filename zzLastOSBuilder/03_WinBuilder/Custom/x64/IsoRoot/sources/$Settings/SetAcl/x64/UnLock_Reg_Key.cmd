@echo off

REM ** The variable to use for the key, makes editing the cmd faster ;) of course use double quotes " " around ANY key or it may error ;)
set SetAclKey="HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.avi\UserChoice"

REM ** setacl will unlock any key you add in the below 2 calls
setacl -on %SetAclKey% -ot reg -actn setprot -op dacl:np
setacl -on %SetAclKey% -ot reg -actn clear -clr dacl,sacl


pause