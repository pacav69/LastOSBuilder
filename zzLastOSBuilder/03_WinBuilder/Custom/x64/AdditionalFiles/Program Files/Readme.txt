Win11 text
Text Version=0.0.1"

You can add portable applications here in the following directory:

\Custom\x64(x86)\AdditionalFiles\Program Files 

Without creating plugins, it is an easy solution for portable Apps.

However No shortcuts are created in this case,
to create them, you can add a shortcut in pecmd.ini file in this structure

INK %Desktop%\[program name text]|%Programs%\[executable.exe] 

where [program name text] is the shortcut text
and the [executable.exe] is the path and file name to executable

eg

LINK %Desktop%\Command Prompt,%WinDir%\System32\cmd.exe
