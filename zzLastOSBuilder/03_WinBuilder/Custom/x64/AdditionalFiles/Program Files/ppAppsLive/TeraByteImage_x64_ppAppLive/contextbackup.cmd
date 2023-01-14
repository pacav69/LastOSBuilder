@echo off & cls & setlocal enableextensions enabledelayedexpansion

:: Last edited: Aug 29, 2008

:: Parameters are
::   1=IFW Program EXE path (can be overridden below)
::   2=Target file path and name (can be overridden below)
::   3=Drive path with trialing backslash (D:\) 
:: 
:: Note that the drive path can have a special $DL$ entry which will be replace
:: with the drive letter.
::

:: Program Path
set IFWPath=%1

:: Target File Path
set IFWFilePath=%2

:: IFW Parameters
set IFWParms=/f:%IFWFilePath% /vb

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Do not make routine changes below this line.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Check existence of the IFW program.

if not exist %IFWPath% (
   cls
   echo.
   echo The path %IFWPath% was not found. Exiting.
   echo.
   pause
   goto :EOF )

:: Make sure a drive letter was passed in.

set Drive=%3
if not defined Drive (
   cls
   echo.
   echo No drive letter was supplied. Exiting.
   echo.
   pause
   goto :EOF )

:: Strip trailing backslash and colon from drive path (C:\ -> C).

set Drive=%Drive:~0,1%

:: Replace static "$DL$" text in the IFWParms variable with the actual drive letter.

set IFWParms=!IFWParms:$DL$=%Drive%!

:RunIFW

start "" %IFWPath% /b /d:?%Drive% %IFWParms%

:: End of script
