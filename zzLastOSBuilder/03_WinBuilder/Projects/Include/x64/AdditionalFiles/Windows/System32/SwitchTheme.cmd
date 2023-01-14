@Echo Off
For /f "tokens=2*" %%a in ('Reg Query HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme') Do Set "Theme=%%b"
If %Theme%==0x1 ( 
  Echo Switch to Explorer Dark Theme...
  Echo.
  Reg Add HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 0 /f
) Else ( 
  Echo Switch to Explorer Light Theme...
  Echo.
  Reg Add HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 1 /f
)
Pecmd.exe KILL explorer.exe