@echo off

REM ** The variable to use for the key, makes editing the cmd faster ;) of course use double quotes " " around ANY key or it may error ;)
set SetAclKey="HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.avi\UserChoice"

REM ** setacl will unlock any key you add in the below 2 calls
setacl -on %SetAclKey% -ot reg -actn ace -ace "n:Administrators;p:query_val,enum_subkeys,notify,write_dacl,write_owner,read_access"
setacl -on %SetAclKey% -ot reg -actn ace -ace "n:Everyone;p:query_val,enum_subkeys,notify,read_access"
setacl -on %SetAclKey% -ot reg -actn setprot -op dacl:p_nc

pause