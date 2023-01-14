'*----------------------------------------------------------------------------*
'* UnlockRegistry.vbs                                                         *
'*                                                                            *
'* By: Daniel E. Patterson                                                    *
'*                                                                            *
'* Description:                                                               *
'* Used with SetACL.exe (available at http://setacl.sourceforge.net/) to      *
'* unlock the Windows XP registry, allowing installation of software.         *
'*                                                                            *
'* Usage:                                                                     *
'* If CSCRIPT //H:CScript has been issued to default scripting to             *
'* command-line actions, then:                                                *
'*   UnlockRegistry.vbs                                                       *
'* Otherwise:                                                                 *
'*   CSCRIPT UnlockRegistry.vbs                                               *
'*                                                                            *
'* Background:                                                                *
'* In recent experiences, we have documented several rampant viruses that,    *
'* while detected by one of the five major AV applications, were not detected *
'* by others, and even though all of the brands will be sure to eventually    *
'* include defs from this current period in history, it does not do any of us *
'* any good at the present time - while being hammered by new and as of yet   *
'* unrecognized variants. At this point, we are going to assert the position  *
'* that it is better not to assume we are protected at all unless we can      *
'* force our system to be secure without the aid of AV software. As a benefit *
'* of this approach, we are also expecting to see a huge increase in general  *
'* PC performance, since AV software is the biggest common drain on resources.*
'*                                                                            *
'* While the first-run condition of a worm or virus exploits a long-running   *
'* security hole in Microsoft Internet Explorer, they all need to create      *
'* entries in the registry to run again the next time your PC starts. Most    *
'* variants will either place random entries in the xxx\Runxxx nodes of the   *
'* machine or current user, while other more sophisticated families make use  *
'* of Browser Helper Objects (BHOs) that run when Windows Explorer starts.    *
'* While notable portions of the registry are locked, however, those          *
'* applications can not be fully registered, and as a result, will fail to    *
'* load as desired by the author. Using this form of protection, then, you    *
'* may experience virus-related glitches when visiting an infected site, but  *
'* in the worst possible case, you will only need to reboot your computer to  *
'* get back to normal operation - since the virus will not be able to start   *
'* again after the PC has been shut down.                                     *
'*                                                                            *
'* Notes:                                                                     *
'* This script assumes that SetACL.exe is located in your path.               *
'* After installing applications, use LockRegistry.vbs to re-lock the         *
'* registry.                                                                  *
'*----------------------------------------------------------------------------*
dim wshShell        'Shell Access.

  set wshShell = WScript.CreateObject("WScript.Shell")
 
  UnSecure "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.avi\UserChoice"
  
  WScript.Echo "Registry Unlocked..."
 
 
'*----------------------------------------------------------------------------*
sub UnSecure(key)
' Set Inheritence on - clear non-inherited ACEs
  WScript.Echo "UnSecuring " & key & "..."
  wshShell.Run "setacl -on """ & key & """ -ot reg -actn setprot -op dacl:np", 0, true
  wshShell.Run "setacl -on """ & key & """ -ot reg -actn clear -clr dacl,sacl", 0, true
end sub
'*----------------------------------------------------------------------------*