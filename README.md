# Scroll wheel for Trackman Marble Trackball
Using AutoHotKey(AHK), enables (semi-) natural (vertical and horizontal) scroll wheel and middle click on multi-monitor setup.


I have no right to do anything with this code. I'm only using this for personal use. I have no right to share this code or allow anyone to use it. But the code's online and I'm pretty sure you do have the ability to use this for your own good privately. You can probably mod it to your liking. I don't know how, though.
( ͡° ͜ʖ ͡°)

## Features

This enables you to:

* scroll with your Trackman Marble like a boss

* hold Middle Mouse Button (We will call this "MMB" in short) while moving cursor, especially when navigating in Blender

* do the above with other trackballs if you tweak the settings a little bit

* add more features on your own (but you have to get through my spaghetti code added in)



## Usage

How to use after install:

* Clicking either of two additional mouse buttons act as a MMB click.  

* While pressing on one of them, you can use trackball to scroll.

* While pressing on the other, you can use trackball to move cursor.

* Try it out yourself!


## Howto

To use through installing and running (and auto-running at startup):

1. Download the trackball-scroll-wheel.ahk file.

1. Download [AutoHotKey](https://www.autohotkey.com/).  
You can automate stuff with this thing. You can swap keys. It's awesome. It's Free and Open Source, by GPLv2.
We need this program to run an .ahk file, like how you need a music player app to run .ogg/.mp3 music files.

1. Double click the .ahk file you downloaded. It'll run. Like how music plays when you open a music file.
Once you close the file through the tray icon or by log out, you will have to re-run the file again. Or, you could do the following.

1. To  run the file on startup, refer to https://www.autohotkey.com/docs/FAQ.htm#Startup on the Startup section.



## FYI

This file was originally created by [Erik Elmore](https://github.com/IronSavior), a.k.a. IronSavior at https://autohotkey.com/board/topic/4677-wheel-button-emulation-script/ back in 2005-08-16.  
[Wayne Jensen](https://github.com/kwaiette) (kwaiette) added natural multidirectional scroll at https://github.com/kwaiette/trackman-scroll-wheel.  
Thank you both!

I added in the middle mouse holding for Blender, and changed threshold to fit my cursor speed. But then on my dual monitor setup, on my second monitor, it didn't work as intended. So I googled up what was causing the problem, fixed it, and made cursor invisible while scrolling so that you don't see cursor going nuts. I'm sure there's a way to make cursor stay still, but I haven't tried that.

## License?

As for licensing, I would like to specify anything but I haven't asked for permission for neither Erik nor Wayne, and the code I copy-pasted is GPL so I shouldn't be uploading this anywhere yet but in case anyone needs it ASAP, I'm uploading my tweak for the time being. I should have asked their permissions but I'm too lazy... Anyways that's why this's for my personal use only and I have no right to allow anyone to use it. ¯\\\_(ツ)\_/¯


I haven't tried it myself, but there's https://github.com/Seelge/TrackballScroll if you want a simpler solution with an actual license.
