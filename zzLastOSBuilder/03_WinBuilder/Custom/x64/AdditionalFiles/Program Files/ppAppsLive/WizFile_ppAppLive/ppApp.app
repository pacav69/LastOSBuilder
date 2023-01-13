[SetupS]
Title=WizFile
Version=v2.06
Description=What is WizFile?WizFile is a very fast file search utility that can find files on your hard drive almost instantly. The entire file system can be quickly sorted by name, size or date. WizFile currently only supports NTFS formatted hard drives but support for other hard drive types is planned.What makes WizFile so fast?When scanning NTFS formatted hard drives (most modern hard drives use this format), WizFile reads the hard drive's Master File Table (MFT) directly from the disk. The MFT is a special hidden file used by the NTFS file system to keep track of all files and folders on a hard drive. Scanning for files this way completely bypasses the operating system (Windows) and provides a huge performance boost.Features:- Find files by name on your hard drives almost instantly- VERY Fast scanning! WizFile reads the master file table (MFT) directly from NTFS formatted hard drives so it's ready for use very quickly after start up.- Search by file name or full path name- Multiple search terms supported- Wild card file search (* and ? wild cards supported)- Monitors for file changes while active - your visible file search results will always be up to date- Keeps track of folder sizes - any changes made to the file system will automatically update the folder sizes- Does not require a separate database file - all file data is kept in memoryHow to Search:Just start typing and search results will appear. While WizFile is active is will monitor your hard drives for file changes. Any changes that affect the current search results will update on screen as they occur.Wildcards:Use a * (asterisk) to match and one or more characters. Use a ? (question mark) to match any single character. For example, to search for all files that start with the letters "da", type in:da*To find all files starting with the letter a with "d" as the 3rd letter, type in:a?d*To file all files with a particular extension, e.g. all mp3 files:*.mp3Multiple Search Items (AND/OR):Separate multiple search terms with a space. The space acts like an "AND" operator. For example to seach for files of type ".mp3" that also contain the word "dance", type in:*.mp3 danceIf your search term has a space in it use double quotes around it, e.g.:*.mp3 "dance hits"Use the vertical pipe (|) symbol as an "OR" operator for multiple search items. E.g. to find all .mp3 and .wav files:*.mp3|*.wavTo find all .mp3 and .wav files that contain the word "dance":*.mp3|*.wav danceMatch File Name Only:If this option is selected the search will only be applied to the file name (the path is not searched)Match Entire Path:If this option is selected the search will be applied to the entire path. If the search term contains a "\" (backslash) then the search will be performed on the entire path regardless of the current "match" setting. This is slower than a file name only search. 
URL=https://antibody-software.com/web/software/software/wizfile-finds-your-files-fast/
Category=Disk
BuildType=ppApp
App-File Style=2 (INI)
AppPath=%ppApps%\WizFile
StartMenuSourcePath=WizFile
Catalog=Disk
StartMenuLegacyPrimary=- Disk
StartMenuLegacySecondary=0 Disk
Flags=KeepAll|TaskbarPin|NotMetroFriendly
App-File Version=v9.17.12.3.0
[Meta]
Tags=File Utility|Directory|Disk
Publisher=Antibody Software
ReleaseDate=2018-11
ReleaseVersion=2.06
InstalledSize=18120430
LicenseType=2 (gratis-only)
[WizFile.lnk]
Target=WizFile64.exe
Comment=Analyzes and visualizes disk-space usage and lets you manage it.
