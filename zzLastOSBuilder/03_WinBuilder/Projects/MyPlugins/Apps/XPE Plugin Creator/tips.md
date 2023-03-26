tips

ref https://theoven.org/viewtopic.php?f=14&t=7&start=80


tip1
Re: Win10XPE Project
Post by MaloK » Mon 05 Jul, 2021 7:14 pm

I would need to have your power iso script to show your where and what to modify.

In the CPU-Z example, it is at line #56

Replace your packed application with your SFX in the File container. (open folder edit and set level=5, Then with Winbuilder Refresh and edit, go to Attachment)

After that edit plugin to extract the Program instead of the Setup file. And remove the line that unpack the setup file for building.

From:


ExtractFile,%FileContainer%,Folder,%SetupFile%,%GTemp%\%ProgramFolder%
ShellExecute,Hide,%GTools%\7z.exe,"x #$q%GTemp%\%ProgramFolder%\%SetupFile%#$q -y -o#$q%GTemp%\%ProgramFolder%\%ProgramFolder%#$q"
to:


ExtractFile,%FileContainer%,Folder,%ProgramExe,%GTemp%\%ProgramFolder%

tip2

 Malok Today i tried as you guide me regarding SFX file. I made good SFX working file. But following error comes now
DirCopy - Failed to copy directory [%BaseDir%\Temp\PowerISO_x64\PowerISO_x64] to: [%BaseDir%\ISO\Programs]: Unknown error

[Main]
Title=PowerISO
Type=XPEPlugin
Description=(v7.9.0.0) The PowerISO Program Files Will Be Added To Build
Author=Life
Date=2021.07.06
Credits=TheOven.org Forum
Contact=
Version=001
Level=5
Download_Level=2
Selected=True
Mandatory=False
NoWarning=False
History001=Life Initial XPE Packed Application Created 2021.07.06
History002=

[Interface]
Shortcut_Bevel=Shortcut_Bevel,1,12,4,6,133,121
Desktop_CheckBox="Desktop Shortcut",1,3,10,10,122,18,True,"__Add Desktop Shortcut"
StartMenu_CheckBox="Start Menu Shortcut",1,3,10,28,122,18,True,"__Add Start Menu Shortcut"
TaskBpin_CheckBox="Pin To TaskBar",1,3,10,46,122,18,False,"__Add Pin To Taskbar Shortcut"
StartMpin_CheckBox="Pin To StartMenu",1,3,10,64,122,18,False,"__Add Pin To StartMenu Shortcut"
StartMenuFolder_TextBox="Start Menu Folder:",1,0,10,100,121,18,cdvd,"__Start Menu Folder Name"
RunFromWhere_ScrollBox="Run From USB",1,4,145,6,104,21,"Run From USB","Run From RAM"
Image_Software=PowerISO4848.ico,1,5,145,35,48,48
Button_Launch_Program=Launch,1,8,10,142,119,25,Launch_Program,Launch.bmp,False,"__Click Here To Launch Program"
HomePage_WebLabel="Home Page",1,10,338,6,55,18,http://theoven.org/index.php?board=39.0
Update_Container_Button=U,0,8,540,4,14,14,Update_Container,0,False,"__Update-Encode File Container"

[Variables]
%ProgramTitle%=PowerISO
%ProgramExe%=PowerISO.exe
%ProgramExex64%=PowerISO.exe
%ProgramFolder%=PowerISO
%ProgramFolderx64%=PowerISO_x64
%SetupFile%=PowerISO.exe
%SetupFilex64%=PowerISO.exe
%SetupURL%=
%SetupURLx64%=
%ProvideFiles%=%ProgCache%\%ProgramFolder%
%FileContainer%=%ScriptDir%\PowerISO_XPE_File.Script

[Process]
Echo,"Processing %ScriptTitle%..."
If,Not,ExistFile,%FileContainer%,Exit,"%FileContainer% File Container Not Found"
//If,%Architecture%%WoW64Support%,Equal,x64False,EchoExtended,"You Need To Enable WoW64 Basic To Run %ProgramTitle% In A 64-Bit Build",,,Message,2,Exit
If,%Architecture%,Equal,x86,Exit,"This %ProgramTitle% x64 Only Plugin Does Not Support x86 Build - You Need To Enable A 64-Bit Build"
If,%RunFromWhere_ScrollBox%,Equal,"Run From RAM",RunFromRAM
If,%Architecture%,Equal,x64,Run,%ScriptFile%,PluginSetx64
//--
//--Used To Enable (TargetAppDataLocal-TargetAppDataRoaming-TargetProgramData) Variables
//AddVariables,%ProjectDir%\script.project,TargetBasePath
//--
Run,%ScriptFile%,Extract
//--
If,ExistDir,%Target_Prog%\%ProgramFolder%,DirDeleteQ,%Target_Prog%\%ProgramFolder%
If,Not,ExistDir,%Target_Prog%,DirMake,%Target_Prog%
DirCopy,%GTemp%\%ProgramFolder%\%ProgramFolder%,%Target_Prog%
//--
Run,%ScriptFile%,Add_Shortcuts
//--
// Delete or Comment AddFiles And(Or) AddFiles6432 and Sections If no Dependencies Required
ExtractSectionFiles,%ScriptFile%,AddFiles
//If,%Architecture%,Equal,x64,ExtractSectionFiles,%ScriptFile%,AddFiles6432
//--
Run,%ScriptFile%,Add_Registry
//--
Run,%ScriptFile%,Add_Associations

[AddFilesInfo]
//- Extract files or folders from Install.wim image. Script Commands are not allowed
//- Each path must be specified as an absolute path starting from the root.
//- Wildcard char ’?’ and ’*’ are allowed. A comment begins with ;; (semicolon). ;;Example Comment
//- Use AddFiles6432 for 32Bit Only Apps On x64 Build with WoW64 Basic Enabled in Build Core

[AddFiles]
\Windows\System32\xxx.dll
\Windows\System32\??-??\xxx.dll.mui

[AddFiles6432]
\Windows\SysWOW64\xxx.dll
\Windows\SysWOW64\??-??\xxx.dll.mui

[Add_Registry]
Echo,"Writing %ScriptTitle% Registry Settings..."
//- Add Registry Values <-- Use RegCPE

[Add_Associations]
//- Associate,Ext <-- Three Letter File Extension

[Add_Shortcuts]
If,%Desktop_CheckBox%,Equal,True,AddShortcut,Desktop
If,%StartMenu_CheckBox%,Equal,True,AddShortcut,StartMenu,%StartMenuFolder_TextBox%
If,%StartMpin_CheckBox%,Equal,True,AddPin,StartMenu
If,%TaskBpin_CheckBox%,Equal,True,AddPin,TaskBar

[Extract]
Set,%SetupContainerSize%,""
IniRead,%FileContainer%,Folder,%SetupFile%,%SetupContainerSize%
If,%SetupContainerSize%-,Equal,-,Run,%ScriptFile%,Update_Container
//--
Echo,"Extracting %ScriptTitle% Setup File..."
If,ExistDir,%GTemp%\%ProgramFolder%,DirDeleteQ,%GTemp%\%ProgramFolder%
DirMake,%GTemp%\%ProgramFolder%
ExtractFile,%FileContainer%,Folder,%ProgramExe%,%GTemp%\%ProgramFolder%
//ShellExecute,Hide,%GTools%\7z.exe,"x #$q%GTemp%\%ProgramFolder%\%SetupFile%#$q -y -aou -o#$q%GTemp%\%ProgramFolder%\%ProgramFolder%#$q"
//ShellExecute,Hide,%GTools%\7z.exe,"x #$q%GTemp%\%ProgramFolder%\%SetupFile%#$q -y -o#$q%GTemp%\%ProgramFolder%\%ProgramFolder%#$q"

[PluginSetx64]
Set,%ProgramExe%,%ProgramExex64%
Set,%ProgramFolder%,%ProgramFolderx64%
Set,%SetupFile%,%SetupFilex64%
Set,%SetupURL%,%SetupURLx64%

[Launch_Program]
If,%HostOSArch%,Equal,x64,Run,%ScriptFile%,PluginSetx64
Run,%ScriptFile%,Extract
OpenDir,%GTemp%\%ProgramFolder%\%ProgramFolder%
//Start,,%ProgramExe%,,%GTemp%\%ProgramFolder%\%ProgramFolder%

[Update_Container]
Echo,"The File Containers Is Being Updated... Please Wait.."
If,ExistDir,%ProvideFiles%,DirDeleteQ,%ProvideFiles%
If,Not,ExistDir,%ProvideFiles%,DirMake,%ProvideFiles%
//If,%Architecture%,Equal,x64,Run,%ScriptFile%,PluginSetx64
Download,%ProvideFiles%\%SetupFile%,%SetupURL%,NoExitOnError
If,Not,ExistFile,%ProvideFiles%\%SetupFile%,EchoExtended,"Error: %SetupFile% has not been downloaded.",Warn,,Message,5,Exit
Encode,%Filecontainer%,Folder,%ProvideFiles%\%SetupFile%
DirDeleteQ,%ProvideFiles%

[AuthorEncoded]
PowerISO4848.ico=4499,5999
Logo=PowerISO4848.ico

tip 3

Where i being mistaken , kindly check and revert me .. and also i check shortcut desktop and i hope this SFX app poweriso.exe shortcut should also appear on my desktop . Thanks

MaloK
Code Baker
Posts: 169
Joined: Sun 06 Jun, 2021 4:12 pm
Location: Canada
Re: Win10XPE Project
Post by MaloK » Tue 06 Jul, 2021 2:49 pm

Hi Lifeline,

You are doing well, just a little error :smile:

if you extract to...:
Line #106
CODE: SELECT ALL

ExtractFile,%FileContainer%,Folder,%ProgramExe%,%GTemp%\%ProgramFolder%
Then you must copy from ???:
Line #59
CODE: SELECT ALL

DirCopy,%GTemp%\%ProgramFolder%\%ProgramFolder%,%Target_Prog%
See, you have one too many %ProgramFolder% in your DirCopy command.
CODE: SELECT ALL

DirCopy,%GTemp%\%ProgramFolder%,%Target_Prog%
The trick is to name your SFX the same name as the EXE in your program and shortcuts will work no problems.


Hi lifeline
Regkeys is stored in this file

HKEY_LOCAL_MACHINE \SYSTEM : \system32\config\system
HKEY_LOCAL_MACHINE \SAM :\system32\config\sam
HKEY_LOCAL_MACHINE \SECURITY : \system32\config\security
HKEY_LOCAL_MACHINE \SOFTWARE : \system32\config\software
HKEY_USERS.DEFAULT :\system32\config\default

if you load any config file and add something to one file in win pe use regedit you have this in good HKEY .
I modify registry file use regedit and load good win pe config file

tip
Hi Lifeline,

Basic build is to create rapidly a "Basic Build" of the Project with the option to add a small set of Plugins.

The additions plugin is there to help add system files and registry entries without having to create a plugin for that purpose.

https://drive.google.com/drive/folders/13IMHgupLMPg-IxZn-nwyAB7vLN_qRnJf?form=MY01SV&OCID=MY01SV


n