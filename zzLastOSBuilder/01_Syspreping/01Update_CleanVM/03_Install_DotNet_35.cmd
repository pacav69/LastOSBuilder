@echo off
rem Win11 script
set "scriptver=0.0.1"
title %~nx0  v%scriptver%
echo.
echo ~ Applying DotNet 3.5 ~
echo.


cd /D %~dp003_DotNet_35

DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:%~dp003_DotNet_35

IF [%1]==[] pause