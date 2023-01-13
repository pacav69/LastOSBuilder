
~---------~+~---------~
~- Last10 Image Info -~
~---------~+~---------~

This Last10 image will install Windows 10 Enterprise LTSC 2019 x64. The install is unattended and takes you straight to desktop with the LastOS tweaks applied. Various runtimes (Visual C++ 2005-2019, Visual Studio, older runtimes), dotNET 3.5, as well as DirectX 9c are pre-installed by means of sysprep. 


~-------~+~-------~
~-   Password    -~
~-------~+~-------~

This image installs in an automated/unattended way and automatically creates a user account with administrative rights that logs in automatically (autologon). The password used for this user account is "123" by default (as set in the autounattend.xml file); you can change this from the accounts control panel/setting after install (or edit the 'autounattend.xml' in the root of the image before installing). In Windows 10 the default setting is to force the user to change his/her password after a period of time; this Last10 image runs a script during install that will override this password change requirement so when you install from this Last10 image you will not be prompted to change your user account password.


~--------------~+~--------------~
~-   Important LastOS Tools    -~
~--------------~+~--------------~

->> ssWPI - An automated, serial installer that allows you to select a list of applications (and tweaks). Just mark the checkboxes in front of the applications you want to install and click "Start" and ssWPI will install all the selected applications in one run.

There's lots you can do in ssWPI's app menu screen but the main thing you need to know is the difference between "ssApp" apps and "ppApp" apps. The main difference is that ssApps are installed onto your machine in the standard (but silent) way; i.e., the programs are usually installed into your Program Files folder (c:\program files) and you should be able to see the app in the list of apps that are possible to remove/uninstall. The installation of a ssApp happens without you having to do anything, of course, as they are Silent. ppApps are best thought of as portable apps ('pp' stands for 'Permanent Portable') that are designed in such a way as to make life much easier with regard to your favorite apps -- you can keep ppApps on a partition or drive that is not your system drive, and you can keep them there even when you reinstall your PC. The information stored in the ppApp.app files of these apps allow for these apps to be all "re-installed" in one action -- shortcuts and settings and all -- by running the "ppApps Regenerator" (included with Setups). To put it a different way, ppApps are OS-independent (unlike ssApps) and can be kept on a PC even when the OS is reinstalled on it. 

ssApps are coloured white in the list of apps, and they appear first in alphabetical order. The ppApps are coloured yellow and are next. There is a special type of ppApp that is designed to be used on Live OS discs and they live in a folder called 'ppAppsLive'. These can also be used on a machine with a standard OS and so they are also listed in the Apps menu. The difference between the normal ppApps and the ones designed to be used on a LivePE are minimal, although some sorting locations will be different to the standard and some of these may use a SFX (Self Extracting Archive) to extract and then run from the temp folder of your PC.

->> Last10 Settings tool - This tool (Settings.exe) allows fast access to Computer Management utilities as well as setting certain options for your installed OS, such as being able to move all your Documents, Pictures, Music, Videos and Favorites on to another drive (so the next time you have to re-install you pick the same drive again and they will all still be there ready to access from your freshly installed OS). It also allows you to enter your name and a PC name, and it lets you choose on which drive or partition you would like to install your ppApps, and more. 

->> Last10 Menu - This utility (Menu.exe) is included in the root of the DVD/USB install media to allow quick access to the tools above as well as other tools you might need.

->> SetupS - A central part of the Last10 experience is to be able to install applications in an easy, sorted, and silent way. "SendTo SetupS" will install your applications without requiring you to run the ssWPI to do so. SetupS allows you to install the ppApps and ssApps (portable and installer type apps) that install silently and produce start menu shortcuts. 


~--------~+~--------~
~-  Known Issues   -~
~--------~+~--------~

- Some start menu shorcuts and/or folders may remain in the start menu after applying sorting via SetupS Control Panel (for example, using 'LastOS' sorting method).

- Setup is fully automated to create a local user account, and since this build is based on Windows 10 Enterprise LTSC there are no modern apps present, nor can one create or log into an online Microsoft account.

- This OS install may get stuck on the WiFi selection screen (and not go straight to desktop) if your hardware has wireless enabled during install as the password won't be provided in the autounattend.xml by default.*

* This problem should be addressed by the autounattend.xml now so that no updates or drivers should be downloaded during setup phase.
