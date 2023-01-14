@echo off
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%

cd /D c:\windows\system32\sysprep
c:\windows\system32\sysprep\sysprep.exe /oobe /generalize /shutdown