@echo off
Fonts.exe
Copy /Y *.dll %SystemRoot%\System32
oalinst.exe /s
xnafx40_redist.msi /qb
xnafx31_redist.msi /qb
xliveredist.msi /qb
gfwlclient.msi /qb
