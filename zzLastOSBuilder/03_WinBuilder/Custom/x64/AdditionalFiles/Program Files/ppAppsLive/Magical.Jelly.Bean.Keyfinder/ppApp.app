[SetupS]
Title=Magical Jelly Bean Keyfinder
Version=v2.0.10.13
Description=The Magical Jelly Bean Keyfinder is a freeware utility that retrieves your Product Key (cd key) used to install Windows from your registry. It also has a community-updated configuration file that retrieves product keys for many applications. Another feature is the ability to retrieve product keys from unbootable Windows installations.Magical Jelly Bean Keyfinder features:- An optional config file - this functionality lets you pull a key stored in the registry for any software. A sample config file is included in the zip and can be seen here: keyfinder.cfg- Command line options - /save <location> /savecsv <location> /close /hive <location> /file <filename>- Load Hive option - allows you to load the registry hive of another Windows installation. To use, put the hard drive in a working machine (must also be Windows 2000, XP, Vista or Windows 7) or use Windows PE (not tested, should work) and click Load Hive. Then point it to the dead Windows install. If you're using Windows Vista, Administrator rights are required for this feature. You may have to right click on the Keyfinder and run as Administrator.- Improved Save & Print! - save & print options will now include all keys. Save is also available in text or CSV.
URL=http://www.magicaljellybean.com/keyfinder
Category=Security
BuildType=ppApp
App-File Style=2 (INI)
AppPath=%ppApps%\Magical.Jelly.Bean.Keyfinder
StartMenuSourcePath=Magical Jelly Bean Keyfinder
Catalog=Security
StartMenuLegacyPrimary=- Security
StartMenuLegacySecondary=3 Security
Flags=KeepAll
App-File Version=v9.17.12.3.0
[Meta]
Tags=System|Keyfinder|Serial|Activation
Releaser=Glenn
ReleaseDate=2019-02-04
ReleaseVersion=2.0.10.13
InstalledSize=1007141
LicenseType=2 (gratis-only)
Publisher=The Magical Jelly Bean
[Magical Jelly Bean Keyfinder.lnk]
Target=keyfinder.exe
Comment=Utility that retrieves your Product Key used to install Windows from your registry. It also eatures a config file that retrieves product keys for many applications.
