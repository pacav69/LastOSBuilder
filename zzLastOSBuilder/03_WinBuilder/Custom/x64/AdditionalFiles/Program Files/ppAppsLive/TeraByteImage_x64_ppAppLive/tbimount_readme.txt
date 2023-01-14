TBIMount
~~~~~~~~~
TBIMount is a free utility that allows you to mount .TBI files that have
been created by TeraByte Unlimited's Image for DOS, Image for Linux, 
Image for Windows applications on Windows NT based OSes.

If the partition in the image being mounted is recognized by Windows then
you'll be able to access individual files or folders within the image via
a standard windows read-only drive letter.

As of this writing, TBIMount supports Windows NT4 through Windows 7.


License
~~~~~~~
See the license.txt file which is included with this package.


Installation:
~~~~~~~~~~~~~

1.  Extract the files in the ZIP archive to a new folder.

2.  Run SETUP.EXE from that folder. 

    Note: SETUP only installs the TBIMount driver.  

    Tip: Use SETUP /i for silent installation.
    

Use:
~~~~

1.  Run TBIMOUNT.EXE from the same folder you extracted the ZIP archive.

    Tip: Full command line options are available.


Uninstallation:
~~~~~~~~~~~~~~~

1.  Run the SETUP.EXE program again.

    Note: SETUP only uninstalls the TBIMount driver.  

    Tip: Use SETUP /u for silent uninstallation.

2.  If you don't need any other files in the folder you extracted the
    ZIP archive to during installation then you can delete that folder.


Notes:
~~~~~~
You can only mount image files where all the associated files are 
always available.  In other words, you can't mount image files that
spans across removable media and expect it to work properly.


Windows NT and Windows 2000 do not support mounting of NTFS partitions
from Read-Only media.  Since the image files are mounted read-only, this
means you will not be able to access NTFS partitions on those Operating 
Systems.  FAT type partitions will still be accessible and TBIView can
be used to access NTFS partitions on those platforms.


Under Vista and later, the mounted drive will only be visible to the user 
who mounted it.


Because windows is natively accessing the file system, all user 
permissions remain in effect.  This means a normal user can't access 
other users folders.  To get access to all normal files you can run
TBIMount as an administrator (right click the shortcut and choose
run as administrator).  The drive letter you mount as administrator will
also only be visible to the elevated administrator.  This means that any 
other application that needs access to the drive letter will also need to 
be run as administrator in the same way.  Windows explorer is different 
because it may continue to run as a normal user even when it acts like 
it's going to elevate. To prevent this you need to make a change to the 
Windows Explorer options:  Open Windows explorer; from the
menu bar choose Tools/Folder Options; choose the view tab and enable 
the "Launch folder windows in a separate process" option located in the 
Advanced Settings box.  Now even though you have that enabled, if you have
any explorer windows open (anything like my computer/viewing a folder/etc)
as a normal user then it will still only launch as the normal user.  To 
prevent this, close all open windows explorer based windows.  Once you do 
that and use right-click, run as administrator you'll actually be running 
as administrator.  Note that any other window you open will also be running 
as administrator until all windows explorer windows are closed.  If you're 
still having problems getting it to elevate properly, you may have a hidden 
explorer.exe process running.  To fix this, bring up the windows task 
manager and end all the explorer.exe processes.  one of them will make your 
desktop go blank, but don't worry about that.  Once you end all processes 
choose the menu option File / New Task (Run..) and type explorer then click
ok (that starts up your desktop again).


You can setup a custom file manager for TBIMount to launch by setting up
a registry string value named FileManager under the
HKLM\Software\TeraByte Unlimited\TBIMount key.  You must supply the .exe
extension and the paramter passed to the launched application is the
root path of the newly mounted drive.


Under Vista if you attempt to mount an unmountable partition such as a 
blank partition it will give you the option to format or refuse to open.
If you then unmount all existing TBIMounted drives (stops TBIMount Serivce)
and attempt to mount again (or start TBIMount driver) it will fail with 
  System error 2 has occured. 
  The system cannot find the file specified.  
While we haven't done extensive diagnosing of why, using the a debug version 
of the driver shows that TBIMount (DriverEntry) isn't even called.  To fix 
this situation you have to close all explorer.exe processes then launch 
explorer.exe (from task manager under File / New Task (Run..) and wait
about 10 seconds and TBIMount will be able to start again.


Direct burned CD/DVD/BD discs may result with "Error 3 while reading 
meta data from TBI file.".  This is because the last disc of a direct
burned disc has file sizes that include unused areas of the disc.  This
cause windows read-ahead feature to report any reads that would extend
beyond the used space to be reported as a read failure with zero bytes
read.  The reason Image creates discs with the full disc allocated as
files and doesn't burn extra sessions for the last disc is because it
tries to use all the disc rather than using some arbitrary number of
reserved sectors for session closing at the end.  When media was 
expensive there was a desire to not push a a small amount of data to 
another disc when it would actually fit and there is no reliable
method to determine the number of sectors a drive/media will require
to close an existing session and open/close a new one.  The work around
is to use TBICD2HD to copy the files off the CD/DVD/BD then use those
files or burn another disc using BINGBURN.  The new disc will not have
the Error 3 issue.

By default there can be a maximum of 4 tbi files mounted.  To change
this value setup a DWORD value named MaxMount under the registry key:
\HKLM\System\CurrentControlSet\Services\TBIMount\Parameters.  
The valid range for the value is 1 to 20.

You can adjust the internal indexes used by TBIMount by adjusting
a value named Markers under the registry key:
\HKLM\System\CurrentControlSet\Services\TBIMount\Parameters.  
The valid range for the value is 20 to 500, the default is 100.
Larger values may be slower on systems with a slow CPU, but may
be faster when the file is on a slow IO device.  Lower values
may speed up access on systems with a slow CPU, but may slow down
access on a slower IO device.
