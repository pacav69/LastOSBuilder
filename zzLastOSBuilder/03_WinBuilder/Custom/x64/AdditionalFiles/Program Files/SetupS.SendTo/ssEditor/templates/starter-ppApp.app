<Title>
	ppApp example template

<Version>
	v00.00

<Description>
With more and more people finding uses for SetupS and ppApps, this will allow anyone to make their very own Silent Setup app or game. It will show up on ssWPI or can be used via SendTo SetupS for whenever one is in a rush to put an app (or game) back onto their PC.

Use the examples in this template to help you get started.

<URL>
	http://#WebLink1#
	http://#WebLink2#

<Category>
	Other

<BuildType>
	ppApp

<AppPath>
	%ppApps%\MyApp

<StartMenuSourcePath>
	MyApp

<Catalog>
	Other

<StartMenuDestPath>
	9 Other
	- Other

<Flags>
	KeepAll = No

<ShortcutS>
	Target="MyApp.exe"
	Comment="A ppApp example shortcut"
	Name="ppApp Example"

<End>
