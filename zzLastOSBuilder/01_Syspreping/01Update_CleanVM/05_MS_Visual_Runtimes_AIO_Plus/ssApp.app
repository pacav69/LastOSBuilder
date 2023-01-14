[SetupS]
Title=MS Visual Runtimes AIO (Plus)
Version=2020.01.23
Description=This ssApp will install the 2005, 2008, 2010, 2012, 2013, and 2019 packages of the Visual C++ runtimes, as well as the F# and J# runtimes. A collection of additional Visual Basic, older Visual C runtimes, and additional runtimes (contained in the 'extra.exe' installer) will be installed for maximum compatiblity. Also, Visual Studio runtime for Office (VSTOR) will be installed.On 32-bit OS only the 32-bit runtimes will be installed, whereas on a 64-bit OS both the 32-bit and 64-bit runtimes will be installed (with the exception of the J# runtime and VSTOR runtimes, which are arch-exclusive).If you don't require the F#, J#, and/or VSTOR (Visual Studio for Office) runtimes, you can instead install the "MS.Visual.Runtimes.AIO.Lite" version of this ssApp.This ssApp contains the following Visual Runtime versions:- VC++ 2005 x86: 8.0.61187- VC++ 2005 x64: 8.0.61186- VC++ 2008 x86: 9.0.30729.7523- VC++ 2008 x64: 9.0.30729.7523- VC++ 2010 x86: 10.0.40219.473- VC++ 2010 x64: 10.0.40219.473- VC++ 2012 x86: 11.0.61135- VC++ 2012 x64: 11.0.61135- VC++ 2013 x86: 12.0.40664- VC++ 2013 x64: 12.0.40664- VC++ 2019 x86: 14.25.28508- VC++ 2019 x64: 14.25.28508- J# x64: 2.0.50728- J# x86: 2.0.50728- F# 2.0: 10.0.40219- VSTOR x64: 10.0.60833- VSTOR x86: 10.0.60833[Always make sure to have all VC Runtimes installed on your computer because many programs depend on these to function. Many program installers have runtime installers included, which is why installing these runtimes is especially important when using ppApps, as these won't always come with included runtimes.]
URL=http://www.microsoft.com|https://rebrand.ly/vcredist
Category=System
BuildType=ssApp
App-File Style=2 (INI)
AppPath=%ProgramFiles%\MS.Visual.Runtimes.AIO.Plus
Assembly=extra.exe /VERYSILENT /NORESTARTfsharp.exevcredist_x86_2005.exevcredist_x86_2008.exevcredist_x86_2010.exevcredist_x86_2012.exevcredist_x86_2013.exevcredist_x86_2019.exe#Is_x86# jsharp_x86.exe#Is_x64# vcredist_x64_2005.exe#Is_x64# vcredist_x64_2008.exe#Is_x64# vcredist_x64_2010.exe#Is_x64# vcredist_x64_2012.exe#Is_x64# vcredist_x64_2013.exe#Is_x64# vcredist_x64_2019.exe#Is_x64# jsharp_x64.exe#Is_x64# vstor_x64.exe#Is_x64# vstor_x86.exe
Catalog=System
StartMenuSourcePath=MS Visual Runtimes AIO (Plus)
StartMenuLegacyPrimary=- System
StartMenuLegacySecondary=4 System
App-File Version=v9.17.12.3.0
[Meta]
Tags=Runtime|Microsoft
Publisher=Microsoft
LicenseType=2 (gratis-only)
ReleaseVersion=Visual Runtimes AIO (Plus)
ReleaseDate=2020-01-23
