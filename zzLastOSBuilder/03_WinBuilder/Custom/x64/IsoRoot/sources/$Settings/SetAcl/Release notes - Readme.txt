SetACL by Helge Klein

Homepage:        http://helgeklein.com/
Version:         2.2.1.0
Copyright:       Helge Klein
License:         LGPL

-V-E-R-S-I-O-N--2.2.1.0-----------------------------------------------------------------------

a) New features:

-  WMI: WMI permission setting/listing now also works on remote computers.

-  Specific file and registry permissions can now be specified using their API names in
   addition to the names SetACL uses. This facilitates setting permissions as listed by
   SetACL.

   Example:

   The permission FILE_ADD_FILE was listed as such, but had to be added as 'add_file'.
   Now it can be added as 'FILE_ADD_FILE' as well. This is case-insensitive, by the way.

-  WMI: Added missing specific permissions WBEM_METHOD_EXECUTE, WBEM_FULL_WRITE_REP,
   WBEM_PARTIAL_WRITE_REP, WBEM_WRITE_PROVIDER, WBEM_REMOTE_ACCESS, WBEM_RIGHT_SUBSCRIBE
   and WBEM_RIGHT_PUBLISH.
	
-  COM version: Added method 'GetLastListOutput' which retrieves the output from the last
   permission listing

-  COM version: Added method 'Reset' which resets a SetACL object to its initial state

-  COM version: Added method 'SetListOptions2' which adds the option to request a cleaned-up
   output where well-known and alias qualifiers (NT AUTHORITY, PREDEFINED, ...) are removed.

b) Changed features:

-  WMI permission 'remote_access' now does not include WBEM_WRITE_PROVIDER any more.

-  Switched from Visual Studio 2008 to 2010. This accounts for the 4x size increase of the
   executables.

b) Bugfixes:

-  COM version: Methods would accept only VARIANT_BOOL (-1) for boolean parameters. 
   Now everything except VARIANT_FALSE is accepted.
	
-  COM version: Fixed incorrect implementation of GetLastAPIError()

-  COM version: WMI permissions can now be listed from managed code (.NET)

-  COM version: PowerShell did not show seven methods. Added a hack to make the missing seven 
   methods show up in PowerShell, too. Other programming languages were not affected by this.

-  When setting permissions access denied errors were logged, but the return code always
   indicated success.

-V-E-R-S-I-O-N--2.2.0.0-----------------------------------------------------------------------

a) New features:

-	Experimental support for setting and listing WMI permissions (recursion not supported yet).

-  More concise messages when privileges cannot be enabled.

b) Bugfixes:

-  OCX version: If no action was specified SetACL logged a message, but without the actual
   error text.

-V-E-R-S-I-O-N--2.1.3.0-----------------------------------------------------------------------

a) New features:

-  List functionality / tabular format: Earlier, when an ACL did not have any explicit (non-
   inherited) permissions, it was not listed at all. Now the ACL protection flags are always
   listed, also the text "[no implicit permissions]".

   Example:

   \\?\c:\Users\helge\appdata

   DACL(not_protected):
   [no implicit permissions]

b) Bugfixes:

-  List functionality: SetACL would always list the DACL in addition to the what was speci-
   fied (SACL, owner, primary group). This has been fixed. Now the DACL is only listed if
   requested.

-  List functionality: When listing DACL and SACL and the DACL was protected from inheritance,
   SetACL would ignore the protection flag and flag ACEs as pseudo-inherited (and conse-
   quently not list those).
	
-  Fixed bug 3123740: permissions from junctions and symbolic links were not read correctly.
   Instead of reading the security descriptor with its ACLs from the junction/link, it was
   read from the junction/link target. This may have caused confusion because permissions
   were never set on the target, but on the junction/link directly.
   Now SetACL always reads from and writes to the junction/link, never the target.

-V-E-R-S-I-O-N--2.1.2.0-----------------------------------------------------------------------

a) Changed features:

-  Backup/restore: The SDDL list function used for backing up and restoring security descrip-
   tors now includes DACL and SACL protection flags if a DACL or SACL listing was requested.

   Example: setacl -on c:\temp\test1 -ot file -actn list -lst f:sddl

   Previously the result would be: "\\?\c:\temp\test1",1,
   Now the result is:              "\\?\c:\temp\test1",1,"D:AI"

   When restoring, an empty DACL is written, wiping out any explicit permissions, and inheri-
   tance is enabled, causing propagation of inheritable permissions. Previous verions of
   SetACL would not change the DACL at all, thus potentially leaving it in protected state.

   The net result of this change is a better reproduction of the original ACL.

b) Bugfixes:

-  Fixed bug 3095862: When listing SACLs, unprotected SACLs were not marked as such. Instead,
   the object's DACL was marked as "not_protected".
	
-  Fixed bug 3061241: When listing ACLs SetACL would mark some ACLs as pseudo-protected also
   inheritance was applied correctly.

-  Improved error handling: In ignore error mode, (access denied) errors were not ignored
   during folder recursion.

-V-E-R-S-I-O-N--2.1.1.0-----------------------------------------------------------------------

a) New features:

-  Pseudo-inheritance: SetACL fixes pseudo-inherited ACEs by converting them to correctly
   inherited ACEs whenever writing a security descriptor. This fixes bug 3076759, too.

b) Bugfixes:

-  Fixed bug 3076759: The API function SetNamedSecurityInfo used by SetACL has the tendency
   to duplicate pseudo-inherited ACEs by creating a correctly inherited twin of each ACE.

-  Fixed bug 3087683: If a trustee had multiple standard permissions, only one of them was
   listed. Example: User1 has read and write permissions on some file. Only read is listed.

-  Improved error handling: In ignore error mode, SetEntriesInAcl errors were not ignored.

-V-E-R-S-I-O-N--2.1.0.0-----------------------------------------------------------------------

a) New features:

-  List functionality: Check for pseudo-inherited ACEs

   Pseudo-inherited ACEs are access control entries that are effectively inherited from their 
   parent object but not marked as such in the child with the flag INHERITED_ACE. In theory 
   this should not happen, but in reality pseudo-inherited ACEs are common. This is 
   unfortunate since it has the potential of breaking the inheritance concept.
   Similar to Windows Explorer's ACL Editor SetACL now detects such pseudo-inherited ACEs. 
   If inherited ACEs are not to be displayed (the default), pseudo-inherited ACEs are now 
   omitted, too. On the other hand, if inherited ACEs are to be displayed, SetACL marks 
   pseudo-inherited ACEs with the tag "pseudo_inherited".

-  List functionality: Check for pseudo-protected ACLs

   Pseudo-protected ACLs are access control lists that do not have the inheritance protection
   flags (SE_DACL_PROTECTED or SE_SACL_PROTECTED) set, but nevertheless are missing 
   inheritable permissions from their parent object. As with pseudo-inherited ACEs this 
   should not happen in theory, but frequently does in practice. Again, this is unfortunate 
   since it has the potential of breaking the inheritance concept.
   Similar to Windows Explorer's ACL Editor SetACL now detects such pseudo-protected 
   ACLs. SetACL marks pseudo-protected ACLs with the tag "pseudo_protected".
   
-  List/backup/restore functionality: Inherited ACEs are not backup up by default

   When listing in SDDL format, (pseudo-) inherited ACEs are now omitted by default, just 
   like with tabular and CSV formats. This has the great advantage that when restoring,
   only those ACEs are written, that are not auto-propagated by inheritance anyway. It
   is also more consistent with the tab and CSV modes.
   If you prefer the old behavior, simply specify "-lst i:y" to include inherited ACEs.

-  List functionality: Better use of parameter "-ignoreerr". If it is set, all available 
   information is displayed for an object, including error messages where listing failed.

-  List functionality: If an ACL is empty, it is now included in the listing an marked as 
   such. Note: empty ACLs grant no access to anyone.

-  List functionality: If an ACL is NULL (not present), it is now included in the listing 
   an marked as such. Note: this is often the case with the SACL.

-  Added some messages that better indicate what is wrong if an incorrect command line 
   was specified.

-  The attempt to set a SACL on a file share is now blocked (shares cannot have SACLs).

b) Bugfixes:

-  Recursion and junction points / symbolic links

   SetACL now recognized junction points and symblic links in the file system and does not 
   try to recurse across them which may result in endless loops. It is now possible, for 
   example, to recurse across the entire C: partition of a Windows 7 installation, which 
   previously would have given the following error:
   
   SetACL finished with error(s):
   SetACL error message: FindFile reported an error
   Operating system error message: The name of the file cannot be resolved by the system.

-  Fixed small memory and handle leaks

-  Fixed bug 3010702: SetACL reported successful execution even with missing -ACTN command 
   line option. Now, if SetACL has nothing to do, it will tell you.

-  Fixed bug 3016237: SetACL did not work correctly if a file system path only consisted of
   dots, e.g. "." or "..".
   
-  Fixed incorrect generic mapping of registry keys: GENERIC_READ was mapped to 0x120019 
   instead of 0x20019. This may have affected how registry permissions were listed.
   
-  Fixed bug 1601809: name to SID resolution did not work correctly in pure DNS environment
   with NETBIOS disabled.
   
-  Fixed bug 1590903: Registry access was not performed according to principle of least
   permissions which could cause unnecessary access denied errors.
   
-  Fixed bug 1534596: Added a typedef PROPAGATION to the ActiveX control's type library.

-  Fixed bug 1436612: Specifying inheritance flags when setting "manage documents" permissions
   on printers would cause SetACL to set set incorrect permissions. SetACL now ignores 
   inheritance flags if man_docs permissions are to be set and issues a warning message.
   
-  Fixed bug 3034321: When calling SetOwner or SetPrimaryGroup with an empty string as trustee
   name, SetACL crashes in the destructor because it tries to free already freed memory.
   
-  Fixed bug 938614: Memory leak when passing message strings as events from the ActiveX
   control to a caller (scripts or other programs).
   
-  Fixed FAQ issue #5: If there was no access for the current user and the user was not
   the owner either, setting the owner remotely (over UNC path or mapped network drive) 
   failed with access denied on all but the top-level folder. The same command worked locally.
   
-V-E-R-S-I-O-N--2.0.3.0-----------------------------------------------------------------------

a) New features:

-  SetACL is now available in both 32- and 64-bit versions.

b) Bugfixes:

-  Fixed bug 1491054: recursion of UNC paths beginning at the share level failed with the 
   message "FindFile reported an error". This has been corrected. An example for this is:
   
   setacl -on \\server\share -ot file -actn list -rec cont
   
-  The handling of NULL security descriptors had bugs. NULL security descriptors (SDs) grant
   full control to everyone and are used rarely. One example of where they are used are
   network shares created with 'net share'.
   
-  Using relative paths did not work. The following error message was shown:

   SetACL finished with error(s):
   SetACL error message: The call to GetNamedSecurityInfo () failed
   Operating system error message: The system cannot find the file specified.
   
   This has been corrected. Relative paths work now.

-V-E-R-S-I-O-N--2.0.2.0-----------------------------------------------------------------------

a) New features:

-  Added a parameter "-ignoreerr" which causes SetACL to ignore errors when reading/setting
   the security descriptor of an object. This can be useful when recursively working with
   large directory trees, but please use this feature only after thorough consideration.
   
-  The list function now displays control information from the security descriptor in CSV
   and TAB formats, too. Specifically, the auto_inherited and protected flags are displayed
   for DACL and SACL.
   
-  SetACL now supports very long paths, specifically paths longer than MAX_PATH which is 260
   characters. This is done by prepending the following to the path:
   
   -  "\\?\"      for local paths
   -  "\\?\UNC\"  for UNC paths
   
   This can be seen when listing permissions.
   
-  SetACL now always disticts correctly between "c:" and "c:\". The former is called a
   "local file system root" while the latter is the directory "\" on drive c:. List
   permissions for both and you will see the difference. The latter corresponds to what you
   get when you right click on c: in Explorer and select Properties -> Security. I am not
   too sure what the former actually represents, but the documentation states that 
   permissions set on such a local file system root are discarded upon the next reboot.

b) Changed features:

-  The log function (invoked with the parameter -log) now checks whether the log file already
   exists. If yes, SetACL appends to the log instead of replacing it. This makes it easier
   to use SetACL in a loop or batch file.
   
-  Restore: When a file or directory does not exist any more, SetACL logs this and continues
   with the next file/dir.
   
-  The list function now only lists a directory name, if there is something to see. Before,
   the typical large directory tree with permissions set only on a few dirs would amount to
   a large listing only showing dirs without any permissions. Now these dirs are not shown
   any more and the listing is much easier to read.

c) Bugfixes:

-  NULL SDs are now handled correctly:

   According to MS's documentation NULL security descriptors (meaning there is no security on
   the object) _should_ not exist on W2k and newer, except for the admin shares (ie. c$).
   One way of creating an object without a SD is to use tools that use the old low-end
   security API, like "net share". This creates a share with a NULL SD. SetACL now handles
   these cases in the following way:
   
   -  When listing permissions, a line like the following is displayed (SetACL continues 
      after that:

      ERROR reading SD from <\\server\c$>: The object has a NULL security descriptor

   -  When setting permissions, above error message is displayed, too, but SetACL creates a
      new empty SD and proceeds as specified.

-  Fixed bug 867350: The actions 'trustee' and 'domain' now only read the SACL if SACL 
   processing has been implicitly specified. This means that the privilege SE_SECURITY_NAME is
   only needed when you want the SACL to be processed. Previously the SACL was always read 
   (even if no processing was necessary) resulting in the need for abovementioned privilege.
   
-V-E-R-S-I-O-N--2.0.1.0-----------------------------------------------------------------------

a) Bugfixes:

-  Fixed bug 794820: If a trustee did not exist in the domain specified, but in a trusted
   domain, the account from the trusted domain was used. Now, only accounts from the domain
   or computer specified are used.
   
-  Fixed bug 800866: Listing admin shares (e.g. c$) caused an access violation. This
   was probably due to the fact that these shares have no security descriptor. SetACL does 
   not crash any more, but accessing admin shares still is not possible.
   
-  Fixed bug 801189: Access violation with nonexistent user and logging enabled.

-  Fixed bug 805067: Object paths only one character long were not supported.
   
b) New features:

-  Added an action 'domain' similar to 'trustee': With it you can copy permissions from one
   domain to another, replace permissions from domainA by permissions from domainB, or
   remove all permissions from a certain domain. This should make domain migrations a lot
   easier.
   
c) User interface:

-  Two new default values for action 'ace': You do not have to specify the mode (set, grant,
   ...) or whether to apply to DACL or SACL any more, if you simply want to set permissions
   in the DACL. Thus simple ACE strings can now be shortened from:
   
   -ace "n:domain\user;p:read;m:set;w:dacl"
   
   to
   
   -ace "n:domain\user;p:read"

-V-E-R-S-I-O-N--2.0.0.6-----------------------------------------------------------------------

a) Bugfixes:

-  Fixed bug 783703: Compiler warning with VC++ 7.1 due to signed/unsigned mismatch.

-  Fixed bug 787612: SetACL could crash under certain circumstances (for example, when setting
   the owner) due to incorrect pointer handling / freeing memory.

-V-E-R-S-I-O-N--2.0.0.5-----------------------------------------------------------------------

a) Bugfixes:

-  Fixed a bug with action "reset children" which was introduced in 2.0.0.3: the object itself
   was also reset, not only it's children.
   
-  Fixed bug 776277: when using one of the three trustee actions (remove/replace/copy trustee)
   with more than one trustee (ie. remove all ACEs belonging to two different trustees) it
   could happen that too many ACEs were affected by the operation.
   
-  Fixed bug 778943: When using a command like: 'SetACL -on c:\test -ot file -actn ace -ace 
   "n:everyone;p:read;m:set;w:dacl" -rec cont_obj' SetACL correctly walked down the tree and
   displayed the objects it should be processing, but permissions were applied to the base
   object only.
   
-  Fixed bug 780246: This is related to bug #778943. Due to recursion not working correctly
   resetting child objects took very (!) long and did not process all child objects.
   Additionally the parameter "-rst <Where> was partly ignored.

-V-E-R-S-I-O-N--2.0.0.4-----------------------------------------------------------------------

a) Setting permissions:

-  Disabled a new "feature" I introduced in version 2.0.0.3 regarding the use of restore
   privileges:

   All read/write operations from/to the ACL/security descriptor were moved to the new class
   CSD in 2.0.0.3. The function CSD::SetSD () is now the single spot where write operations to
   the SD are performed. In SetSD () I first tried to set the SD via SetKernelObjectSecurity()
   which can write the SD without performing access checks, i.e. you could set permissions
   on objects you have no access to and do not own. The BIG disadvantage of
   SetKernelObjectSecurity() is that it is a low-level security API function and therefore does
   not handle inheritance at all: permissions are not propagated to sub-objects, and the
   "inherited" flag of the object's ACEs is not set/cleared as necessary. Since SetACL does
   not do this either, this normally results in incorrect ACLs.
   
   SetKernelObjectSecurity () is not used any more; SDs are set the way they were before
   version 2.0.0.3.

b) Bugfixes:

-  Fixed Bug 773933: The exception handling in Split () was incompatible with Visual C++ 7.1.
   This has been corrected.
   
-  Fixed a bug: the security descriptor is now only written to the object if there have been
   actual changes. Before, it could happen that by writing to the SD the SD's control bits
   were cleared, resulting in the deletion of the "auto inherited" bit. This was a minor bug
   which had no severe consequences and occured only under special circumstances. An example
   that invoked the bug follows here:
   
   SetACL.exe -on c:\temp\test1 -ot file -actn setprot -op "dacl:nc"

-V-E-R-S-I-O-N--2.0--f-i-n-a-l-(2-0-0-3)------------------------------------------------------

a) Listing permissions

-  Use of privileges: permissions are displayed even if access is denied to the object in
   question. This works in the (local and remote) file system and in the local registry.
   The privilege "SeBackupPrivilege" is needed for this.
   
-  If access to an object is denied and the "SeBackupPrivilege" is not held, the object in
   question is ignored and SetACL proceeds with the next object.

b) Setting permissions

-  Use of privileges: permissions are set even if access is denied to the object in
   question. This works in the (local and remote) file system and in the local registry.
   The privilege "SeRestorePrivilege" is needed for this.
   
-  If access to an object is denied and the "SeRestorePrivilege" is not held, the object in
   question is ignored and SetACL proceeds with the next object.

c) Various changes

-  Fixed bug 738227: A missing section ("Where") on the help page (printed when 
   "setacl -help" is typed) has been added.

-  Fixed bug 745861: The SYNCHRONIZE flag was set on auditing ACEs, too, which resulted in
   all kinds of access being audited, not only the type specified.
   
-  Fixed bug 739013: If enabling the backup and restore privileges failed, the program would
   exit with an error. This effectively limited the use of SetACL to administrators.
   Now, if these privileges cannot be enabled, only an info message is displayed.
   
-  Fixed a bug: When resetting permissions using action -rstchldrn the parameter "-rst Where"
   was ignored.
   
-  Fixed bug 761666: When setting "man_docs" or "full" permissions on printers a third,
   unnecessary ACE (which had no effect) was generated.
   
-  If SetACL is run on an unsupported OS version an error message is displayed and the program
   exits cleanly.

-V-E-R-S-I-O-N--2.0--B-e-t-a--2---------------------------------------------------------------

a) Listing permissions

-  The listing is written to the screen, too, if not in silent mode.
-  If a backup file is specified, a listing in UNICODE format will be written there. If not,
   the listing is written to the screen only. In other words, the parameter '-bckp' is
   optional.
-  List options need only be set if the default values (csv format, list only DACL, do not
   list inherited permissions) are not suitable. In other words, the parameter '-lst' is
   optional.
-  Inherited permissions are listed only if explicitly specified in the list options (e.g.:
   -lst "f:own;w:d;i:y").
-  Owner and primary group are now listed in own format, too, if requested.
-  The "own" list format has been renamed to "csv".
-  A third, tabular, list format has been added: "tab".
-  Trustees can now be listed using their names, SIDs, or both.
   
b) Various changes

-  Several unnecessary newlines removed from output.
-  Standard permission "list_folder" (file system) was not implemented correctly. Now it works
   as expected. This bug with the ID 737212 has been fixed.

-V-E-R-S-I-O-N--2.0--B-e-t-a--1---------------------------------------------------------------

This is the first public beta version of SetACL version 2. Please visit the program's homepage
for information, bug reports, feature requests, and general discussion.