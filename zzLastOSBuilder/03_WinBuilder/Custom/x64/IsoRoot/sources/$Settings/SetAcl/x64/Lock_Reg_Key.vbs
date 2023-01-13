'*----------------------------------------------------------------------------*
'* LockRegistry.vbs                                                           *
'*                                                                            *
'* By: Daniel E. Patterson                                                    *
'*                                                                            *
'* Description:                                                               *
'* Used with SetACL.exe (available at http://setacl.sourceforge.net/) to      *
'* lock down the Windows XP registry, rendering anti-virus applications       *
'* obsolete.                                                                  *
'*                                                                            *
'* Usage:                                                                     *
'* If CSCRIPT //H:CScript has been issued to default scripting to             *
'* command-line actions, then:                                                *
'*   LockRegistry.vbs                                                         *
'* Otherwise:                                                                 *
'*   CSCRIPT LockRegistry.vbs                                                 *
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
'* To install applications, use UnlockRegistry.vbs. Remember to lock the      *
'* registry again after installing new applications.                          *
'*----------------------------------------------------------------------------*
dim machineName     'NetBIOS Name of the Machine.
dim wshNetwork      'Network Scripting Object.
dim wshShell        'Shell Access.

  set wshNetwork = WScript.CreateObject("WScript.Network")
  set wshShell = WScript.CreateObject("WScript.Shell")

  machineName = wshNetwork.ComputerName

  Secure "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.avi\UserChoice"

  WScript.Echo "Registry Locked..."

'*----------------------------------------------------------------------------*
sub Secure(key)
'Access only for Administrators (Read + Set), and Everyone (Read) - not inherited.
  WScript.Echo "Securing " & key & "..."
  wshShell.Run "setacl -on """ & key & """ -ot reg -actn ace -ace ""n:" & machineName & "\Administrators;p:query_val,enum_subkeys,notify,write_dacl,write_owner,read_access""", 0, true
  wshShell.Run "setacl -on """ & key & """ -ot reg -actn ace -ace ""n:Everyone;p:query_val,enum_subkeys,notify,read_access""", 0, true
  wshShell.Run "setacl -on """ & key & """ -ot reg -actn setprot -op dacl:p_nc", 0, true
end sub
'*----------------------------------------------------------------------------*