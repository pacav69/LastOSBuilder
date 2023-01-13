WizFile Quick Start Guide
(c) 2018 Antibody Software Limited
www.antibody-software.com

WHAT IS WIZFILE?
WizFile is a very fast file search utility that can find files on your hard drive almost instantly.

HOW TO SEARCH:
Just start typing and search results will appear. While WizFile is active is will monitor your hard drives for file changes. Any changes that affect the current search results will update on screen as they occur.

Double click an item in the 'path' column to open Windows Explorer at that location. 
Double click an item in the 'path' column while holding the ALT key to open a commpand prompt at that location. 
Double clicking an item in any other column will cause Window to open the selected file using the default method.

WILDCARDS:

Use a * (asterisk) to match and one or more characters. Use a ? (question mark) to match any single character.
For example to search for all files that start with the letters "da", type in:
da*

To find all files starting with the letter a with "d" as the 3rd letter, type in:
a?d*

To file all files with a particular extension, e.g. all mp3 files:
*.mp3

MULTIPLE SEARCH ITEMS (AND / OR):

Separate multiple search terms with a space. The space acts like an "AND" operator

For example to seach for files of type ".mp3" that also contain the word "dance", type in:
*.mp3 dance

If you search term has a space in it use double quotes around it, e.g.:
*.mp3 "dance hits"

Use the vertical pipe (|) symbol as an "OR" operator for multiple search items. E.g. to find all .mp3 and .wav files:
*.mp3|*.wav

To find all .mp3 and .wav files that contain the word "dance":
*.mp3|*.wav dance

MATCH FILE NAME ONLY:
If this option is selected the search will only be applied to the file name (the path is not searched)

MATCH ENTIRE PATH:
If this option is selected the search will be applied to the entire path. If the search term contains a "\" (backslash) then the search will be performed on the entire path regardless of the current "match" setting. This is slower than a file name only search. 

CLOSING WIZFILE
The "close" and "minimize" buttons at the top right of the WizFile window will minimize WizFile to the system tray where it will remain active. Double click on the WizFile tray icon to restore WizFile.

To close and exit use the "File->Exit" menu option or press Alt+F4. You can also right click on the tray icon and select "exit".

START WITH WINDOWS
Enabled this option to have WizFile start automatically when you log into windows. It will start minimized to the system tray. This option is on by default in the non-portable version. If you're using the portable version and you enable this option please remember to disable it once you're done.

DONATIONS
WizFile is DONATIONWARE. It's completely free but if you find it useful please make a donation by clicking on the "Donate" button at the top right of the screen. We will send you a "supporter code" that you can use to hide the donate button as thanks.