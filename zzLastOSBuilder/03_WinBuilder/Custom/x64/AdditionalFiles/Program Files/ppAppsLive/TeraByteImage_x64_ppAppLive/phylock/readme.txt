PHYLock(TM) Version 2
~~~~~~~~~~~~~~~~~~~~~
PHYLock is an add-on software component for Windows NT based OSes that
enables Image for Windows to maintain a consistent backup of an unlocked
partition or volume.

It should be noted that the consistency is based on a point in time.
Although there is an attempt to pick a "clean" point in time, there is no
guarantee that all software programs, internal caches, and the like are
in a clean state at that point.  This is true of ALL backup software that
is backing up a volume that is in use.

License
~~~~~~~
See the license.txt file which is included with this package.

Version 2 Compatibility
~~~~~~~~~~~~~~~~~~~~~~~
2.00 (2) Requires Image for Windows 1.60 or later.
2.01 (3) New features supported by Image for Windows 1.61 or later.
2.04 (4) New features supported by Image for Windows 2.00 or later.
2.05 (5) Supports 64-bit LBA for Image for Windows 2.50 or later.


Installation
~~~~~~~~~~~~
1) Extract the files in the zip to a folder.
2) Run setup from that folder.


Uninstallation
~~~~~~~~~~~~~~
1) Run the setup program again.


Tips
~~~~
* Use setup /i for silent installation.

* Use setup /u for silent uninstallation.

* If you don't have a use for the Last Access timestamp placed on files
  and you're using NTFS then you can disable that updating by browsing
  to HKLM\SYSTEM\CurrentControlSet\Control\FileSystem and setting
  the DWORD value "NtfsDisableLastAccessUpdate" to 1.

* When setting up a batch file to start IFW you may find the net
  command helpful in controlling services.  In particular, "net stop",
  "net start", "net pause", and "net continue".  Many services use
  "net pause" as a signal to flush data to the disk, although you'd have
  to check with the maker of the software to know for sure.  IFW V2
  offers services.ins to control services at a finer granularity.

* If you have a problems with the cache size not being big enough in
  RAM mode then you may which to turn off the byte-for-byte validation
  option.  When the option is not used, the cache will be cleared of any
  data that has already been backed up.

  In particular, if you're saving the image to the same NTFS volume being
  backed up (or backing up an NTFS volume in general) then it may be
  log file that is causing the cache size problem.  You can reduce
  the log file to something like 4MB if that volume doesn't routinely
  have lots of activity/updating.  There is a slight delay when the
  log file fills up and rolls over - adjust accordingly.  To see the
  current size of the log file you use chkdsk [volume] /l and to adjust
  the size you use chkdsk [volume] /l:kbsize (i.e. chkdsk d: /l:4096)


Windows NT Issues
~~~~~~~~~~~~~~~~~

Problem Booting after Installation
----------------------------------
If for some reason you have a problem booting the operating system
the first time after installing PHYLock then:

When booting NT press the space bar when the message that reads:
"Press spacebar NOW to invoke Hardware Profile/Last Known Good menu"
is displayed.


Windows 2K/XP/etc.. Issues
~~~~~~~~~~~~~~~~~~~~~~~~~~

Problem Booting after Installation
----------------------------------
If for some reason you have a problem booting the operating system
the first time after installing PHYLock then:

If you get the "Please select the operating system to start" screen
press F8 from that screen.  Otherwise, press F8 as soon as the OS
begins to boot.

From the "Advanced Options Menu" select the "Last Known Good Configuration"
item and press enter.

Networking Problems after Installation
---------------------------------------
While highly unlikely, if you happen to experience problems trying to 
access or serve network shares after installation then:

Adjust the IRPStackSize registry value.  View this MSKB article for 
details: http://support.microsoft.com/?kbid=285089


General Problems
~~~~~~~~~~~~~~~~

Problem:
--------
PhyLock is installed but IFW still says it can't obtain a lock.

Solution:
---------
1) Ensure you're using WinNT/2K/XP/2K3/Vista/W7 (NT based OS)

2) Check that PHYLock is enabled under IFW settings.

3) Uninstall any third party software/drivers that also provide
   snapshot or disk protection services.  Many of them are ill behaved
   and will block requests intended for PHYLock.
