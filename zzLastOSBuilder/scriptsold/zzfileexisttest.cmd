@REM rem You can use IF EXIST to check for a file:

@REM IF EXIST "filename" (
@REM   REM Do one thing
@REM ) ELSE (
@REM   REM Do another thing
@REM )
@REM If you do not need an "else", you can do something like this:

@REM set __myVariable=
@REM IF EXIST "C:\folder with space\myfile.txt" set __myVariable=C:\folder with space\myfile.txt
@REM IF EXIST "C:\some other folder with space\myfile.txt" set __myVariable=C:\some other folder with space\myfile.txt
@REM set __myVariable=

@REM Here's a working example of searching for a file or a folder:

@echo off
REM setup
@REM set "testfile=readme.txt"
set "testfile=*.iso"

rem echo "some text" > filename
rem mkdir "testfolder"

REM finds file    

IF EXIST "00_Source\%testfile%" (
  ECHO file %testfile% exists
) ELSE (
  ECHO file %testfile% does not exist
)
pause

REM does not find file

@REM IF EXIST "filename2.txt" (
@REM   ECHO file filename2.txt exists
@REM ) ELSE (
@REM   ECHO file filename2.txt does not exist
@REM )

@REM REM folders must have a trailing backslash    

@REM REM finds folder

@REM IF EXIST "foldername\" (
@REM   ECHO folder foldername exists
@REM ) ELSE (
@REM   ECHO folder foldername does not exist
@REM )

@REM REM does not find folder

@REM IF EXIST "filename\" (
@REM   ECHO folder filename exists
@REM ) ELSE (
@REM   ECHO folder filename does not exist
@REM )
@REM pause