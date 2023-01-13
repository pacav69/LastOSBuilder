[SetupS]
Title=TeraByte Image
Version=v3.0.37
Description=Image for Windows is a reliable drive image backup and restore solution that provides an easy and convenient way to completely backup all your hard drive is data and operating systems. Your backups can be saved directly to external USB and FireWire drives, to internal or network drives, and even directly to CD or DVD. The Image for Windows package includes an easy-to-use MakeDisk wizard for creating a recovery boot disk. To restore your data and operating systems back to the way they were when the backup was created, simply boot the recovery disk and restore the partition(s) or drive(s) you need to recover. It is that easy.
URL=http://www.terabyteunlimited.com/image-for-windows.htm
Category=System
BuildType=ppApp
App-File Version=v9.17.12.3.0
App-File Style=2 (INI)
AppPath=%SourcePath%
StartMenuSourcePath=TeraByte Image
Catalog=Disk|System
StartMenuLegacyPrimary=- Disk|- System
StartMenuLegacySecondary=0 Disk|4 System
Flags=KeepInFolder|KeepAll|NotMetroFriendly|AlwaysHide
[Meta]
ReleaseDate=2020-01-23
ReleaseVersion=3.0.37
LicenseType=1 (non-gratis)
[TeraByte Image Backup.lnk]
Target=imagew64.exe
Comment=TeraByte Image is a complete and reliable drive image backup and restore solution.
[TBI-View.lnk]
Target=tbiview64.exe
Comment=TBIView allows you to view the contents of image files that have been created by TeraByte Image for Windows.
[TBI-Mount.lnk]
Target=tbimount64.exe
Comment=Mount a TeraByte Image file as a read-only drive letter in Windows.
