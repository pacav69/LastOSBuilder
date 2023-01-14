[SetupS]
Title=RAMTester
Version=v1.1.0.1
Description=The RAMTester tool checks reliability of memory modules under MS Windows (x86 and x64), working with virtual addresses. It writes various bit patterns into memory cells and then reads them and compares with reference. Note that the check is qualitative, so you might want to use utilities working with real addresses under DOS to obtain more quantitative data.
Category=System
BuildType=ppApp
App-File Version=v9.17.12.3.0
App-File Style=2 (INI)
AppPath=%SourcePath%
StartMenuSourcePath=RAMTester
Catalog=System
StartMenuLegacyPrimary=- System
StartMenuLegacySecondary=4 System
Flags=KeepAll|AlwaysHide
[Meta]
ReleaseDate=2005-09-12
ReleaseVersion=1.1.0.1
LicenseType=2 (gratis-only)
[RAMTester.lnk]
Target=rt.exe
Comment=Test your memory for errors.
