ssControlPanel -path=add

:Create Folder Icon for Tools
cd Tools
attrib . +s
attrib desktop.ini -h -s >nul:
echo [.ShellClassInfo] >desktop.ini
echo ConfirmFileOp=0 >>desktop.ini
echo IconFile=.\Tools.ico >>desktop.ini
echo IconIndex=0 >>desktop.ini
attrib desktop.ini +h +s
cd ..

:Create Folder Icon for Licenses
cd Licenses
attrib . +s
attrib desktop.ini -h -s >nul:
echo [.ShellClassInfo] >desktop.ini
echo ConfirmFileOp=0 >>desktop.ini
echo IconFile=.\OSI.ico >>desktop.ini
echo IconIndex=0 >>desktop.ini
attrib desktop.ini +h +s
cd ..

:Create Folder Icon for ssEditor
cd ssEditor
attrib . +s
attrib desktop.ini -h -s >nul:
echo [.ShellClassInfo] >desktop.ini
echo ConfirmFileOp=0 >>desktop.ini
echo IconFile=.\ssEditor.ico >>desktop.ini
echo IconIndex=0 >>desktop.ini
attrib desktop.ini +h +s