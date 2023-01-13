@echo off
echo Processing Idle Tasks:
Rundll32.exe advapi32.dll,ProcessIdleTasks
echo Defrag Boot Files:
defrag -b %SystemDrive%