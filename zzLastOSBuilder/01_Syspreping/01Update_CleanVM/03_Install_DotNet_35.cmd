@echo off
title %~nx0
echo.
echo ~ Applying DotNet 3.5 ~
echo.


cd /D %~dp003_DotNet_35

DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:%~dp003_DotNet_35

IF [%1]==[] pause