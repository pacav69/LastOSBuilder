
https://rufus.ie/en/#

https://rufus.ie/downloads/

Download file rufus-3.22p.exe and put in ...\Projects\Tools folder

and in CreateISO.script change Variable to %RufusExe%=%GTools%\rufus-3.22p.exe

Changelog

Version 3.22 (2023.03.25)
Add SHA-1 and SHA-256 x86 acceleration on CPUs that support it (courtesy of Jeffrey Walton)
Add an option to disable BitLocker device encryption in the Windows User Experience dialog
Add a cheat mode (Ctrl-P) to preserve the log between sessions
Fix potential media creation errors by forcing the unmount of stale WIM images
Fix potential access errors in ISO → ESP mode by forcing Large FAT32 formatting
Fix user-specified label not being preserved on error/cancel
Fix some large SSD devices being listed by default
Fix processing of Rock Ridge CE fields
Work around the use of Rock Ridge symbolic links for Linux firmware packages (Debian)
Remove the ISO download feature on Windows 7
Note: This is the last version of Rufus that can run on Windows 7