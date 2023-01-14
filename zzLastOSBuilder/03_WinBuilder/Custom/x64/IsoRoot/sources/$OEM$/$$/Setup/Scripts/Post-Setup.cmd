wmic path Win32_UserAccount set PasswordExpires=False
wmic UserAccount set PasswordExpires=False

REM Make Update Service Enabled
sc config UsoSvc start=demand

regedit /s c:\windows\Setup\$RegTweaks\zRe-Tweak.reg
rd /q/s c:\windows\setup\scripts