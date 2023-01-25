@echo off
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)
echo 12hour time %mydate%_%mytime%

pause

@REM If you prefer the time in 24 hour/military format, you can replace the second FOR line with this:

@REM For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
@REM C:> .\date.bat
@REM 2008-10-14_0642

@echo off
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
@REM For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
echo 24hour time %mydate%_%mytime%
pause

@REM If you want the date independently of the region day/month order, you can use "WMIC os GET LocalDateTime" as a source, since it's in ISO order:

@echo off
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2% %ldt:~8,2%:%ldt:~10,2%:%ldt:~12,6%
echo Local date is [%ldt%]
pause 

@REM C:>test.cmd
@REM Local date is [2012-06-19 10:23:47.048]

