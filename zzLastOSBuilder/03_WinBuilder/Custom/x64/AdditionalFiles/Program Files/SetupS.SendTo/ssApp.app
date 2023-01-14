[SetupS]
Title=SetupS SendTo Suite
Version=v20.02.13.0
Description=ssTek is a name derived from "SetupS Technologies" and all the tools using that technology. These tools are collectively called a package management system -- a collection of software tools that automates the process of installing, upgrading, configuring, and removing applications and games for a Windows operating system in a consistent manner.SetupS, meaning "Setup Silently", is the central tool responsible for managing the install and setup of certain deployment packages. These deployment packages have file extensions that SetupS automatically recognizes and can be installed simply by double clicking on those deployment package files. One can also use the context-menu "Sendto" option to install these packages or to install an entire folder of them.Although SetupS is not an installer itself but rather a "manager" for other installers, the main feature and advantage of SetupS is its advanced ability to customize an install for nearly any application or game and to do that install without user interaction. This is sometimes also called an unattended or silent install.Another ssTek tool is ssWPI -- a highly modded (W)indows (P)ost (I)nstaller that works in conjunction with SetupS; and hence the name. ssWPI presents the user with a list of available deployment packages each with their own descriptions and screenshot/previews. The user can then select from any number of these items to install... all in one sitting... all without requiring any further interaction from the user.Included with the SetupS suite is another application called "SetupS Editor", or ssEditor, that can create these deployment packages for ssWPI or SetupS. The ssEditor can also be used to edit existing deployment packages or simply to view them.ssTek has several types of deployment packages available:ssApp: installer based apps, installed silently or unattended.ppApp: a portable and permanent application.ppGame: a portable and permanent game.An advantage of ppApps or ppGames is that they can be located anywhere on any drive (i.e., portable) -- for example, "D:\ppApps" or "D:\ppGames". Another is that as long as they remain on a different drive than the operating system (OS) then even after a new OS is re-installed, these apps or games can then be "brought back to life" and reused exactly as they were before (i.e., they're also permanent). This recovery can be accomplished by means of another ssTek tool called ssRegenerator.With ssTek a user can also opt for an advanced startmenu structure that allows SetupS to automatically sort these apps or games while it is installing them or while they are being "regenerated". Of course the user can also opt for the standard startmenu structure if that is preferred. The ssTek tool that does this is called the ssControlPanel. And for cleaning dud shortcuts from the advanced startmenus is ssCleaner, which can be accessed via the ssControlPanel.Each ss/ppApp contains a file with an .app extension (or .ppg for ppGames). It is a text-file which contains all the essential install information, startmenu sorting, and shortcut options, etc. This SetupS-file basically tells SetupS how to install the app or game. It can also contain many other bits of information pertaining to the app or game.There are also many other SetupS-recognized files a typical ssTek deployment package might use. Installers (in the case of ssApps), or archives (in the case of ppApps); and various graphics files not essential to the apps' installations, but are added to provide other fun things ssTek tools can do. For example, screenshots of the apps or games when used with ssWPI.Best of all, SetupS works with all the popular "NT-based" Windows, such as Windows 10, 8.x, 7, Vista, XP, & 2K.ssTek tools are licensed under the open-source GNU General Public License v3. For details, please see http://www.gnu.org/licenses/. This Suite includes the following tools:* "ssRegenerator", a shortcut generator for all your SetupS-installed apps and games.* "ssControlPanel", use to select an Advanced StartMenu/Sorting Style, SetupS preferences, Fadertainer settings, ppDrives, etc. Also has "ssCleaner" built-in for StartMenu cleaning.* "ssEditor", an application that can view, edit, or create the deployment packages used by SetupS.
URL=http://sstek.vergitek.com|http://www.lastos.org|http://dl.bintray.com/sstek
Category=Addon
BuildType=ssApp
App-File Format=v9.15.12.7.7
App-File Style=2 (INI)
AppPath=%ProgramFiles%\SetupS.SendTo
Assembly=ssPreinstaller.exe -StartMenuOnly -TrayOnly #Is_x86#ssPreinstaller_x64.exe -StartMenuOnly -TrayOnly #Is_x64#
StartMenuSourcePath=SetupS SendTo
Catalog=System Installing
StartMenuLegacyPrimary=- System\- Add, Install, & Setup
StartMenuLegacySecondary=4 System\0 Installers & Setups
ShortCutNamesKeep=SetupS Editor|SetupS Control Panel
Flags=KeepInFolder|KeepAll|SendTo|NotMetroFriendly
[Meta]
Publisher=Vergitek Solutions
ReleaseDate=2020-02-13
Rating=5
LicenseType=3 (libre)
Tags=Addon|Installing|Software Management|Setup & Installing|Start Menu
ReleaseVersion=20.02.13.0
[SetupS Editor.lnk]
Target=ssEditor\ssEditor.exe
StartIn=ssEditor
[SetupS Control Panel.lnk]
Target=ssControlPanel.exe
Comment=Applet to select an Advanced StartMenu/Sorting Style, ppDrives, etc.
[Regenerator\All SetupS-tech Regenerator.lnk]
Target=ssRegenerator.exe
Arguments=-AllDrives=no
Comment=Create StartMenu Shortcuts for all your ssApps, ppApps, & ppGames
[Regenerator\ppApps Regenerator.lnk]
Target=ssRegenerator.exe
Arguments=-ppApps -AllDrives=no
Comment=Create StartMenu Shortcuts for all your ppApps
[Regenerator\ppGames Regenerator.lnk]
Target=ssRegenerator.exe
Arguments=-ppGames -AllDrives=no
Comment=Create StartMenu Shortcuts for all your ppGames
[Regenerator\ssApps Regenerator.lnk]
Target=ssRegenerator.exe
Arguments=-ssApps
Comment=Create StartMenu Shortcuts for all your SetupS/ssApps
[Regenerator\All Drives\All SetupS-tech Regenerator (all drives).lnk]
Target=ssRegenerator.exe
Arguments=-AllDrives=yes
Comment=Create StartMenu Shortcuts for all your ssApps, ppApps, & ppGames on all your drives
[Regenerator\All Drives\ppApps Regenerator (all drives).lnk]
Target=ssRegenerator.exe
Arguments=-ppApps -AllDrives=yes
Comment=Create StartMenu Shortcuts for all your ppApps on all your drives
[Regenerator\All Drives\ppGames Regenerator (all drives).lnk]
Target=ssRegenerator.exe
Arguments=-ppGames -AllDrives=yes
Comment=Create StartMenu Shortcuts for all your ppGames on all your drives
[StartMenu Resorting\Kazz.lnk]
Target=ssControlPanel.exe
Arguments=-Kazz
Comment=Installs and resorts to the Kazz Advanced StartMenu sorting-structure.
[StartMenu Resorting\LastOS.lnk]
Target=ssControlPanel.exe
Arguments=-LastOS
Comment=Installs and resorts to the LastOS Advanced StartMenu sorting-structure.
[StartMenu Resorting\Resort.lnk]
Target=ssControlPanel.exe
Arguments=-Resort
Comment=Resorts to the current StartMenu sorting-structure.
[StartMenu Resorting\Standard.lnk]
Target=ssControlPanel.exe
Arguments=-Standard
Comment=Installs and resorts to the Standard StartMenu sorting-structure.
[ssCleaner\Clean StartMenu only.lnk]
Target=ssControlPanel.exe
Arguments=-ssClean=StartMenuOnly
Comment=Clean dud shortcuts (Startmenu only).
[ssCleaner\Clean ALL dud Shortcuts.lnk]
Target=ssControlPanel.exe
Arguments=-ssClean=AllShortcuts
Comment=Clean dud shortcuts (All shortcut locations).
[ssTek Help.lnk]
Target=ssTek.chm
Comment=General help-file for ssTek Tools.
