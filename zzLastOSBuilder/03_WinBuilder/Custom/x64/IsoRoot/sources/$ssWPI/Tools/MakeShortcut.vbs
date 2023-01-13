set WshShell = WScript.CreateObject("WScript.Shell" )
set oShellLink = WshShell.CreateShortcut(Wscript.Arguments.Named("shortcut") & ".lnk")
oShellLink.TargetPath = Wscript.Arguments.Named("target")
oShellLink.WorkingDirectory = Wscript.Arguments.Named("startin")
oShellLink.Arguments = Wscript.Arguments.Named("args")
oShellLink.WindowStyle = 1
oShellLink.Save