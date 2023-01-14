Removing the arrow (Shortcut Overlay) without side effects.

Most Tweak programs remove the arrows by renaming or removing the IsShortCut String Values from the registry. Windows uses this value to track links, if you remove or rename the IsShortCut value lots of programs and features that use links won't work correctly -> for example, in Vista the shortcuts in Favorite Links, Media Center, and in the Games Explorer won't work anymore.

The files in this zip file remove the arrows the same way as TweakUI does in previous Windows versions; it refers the icon to another icon. If you refer it to a completely blank icon, the overlays turn black when you restart Explorer or Log Off and Log On again.

Solution: I've created a blank icon with some transparent pixels and with the same sizes as the default arrow (imageres.dll,162) -> no more arrows & no black overlays. 

(This is some info provided by Herby, who created this blank.ico file. From his icon and tweaks I created the !RemoveArrow and !RestoreArrow .cmd's.)