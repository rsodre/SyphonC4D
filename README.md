# SyphonC4D

A Syphon Server to visualize Cinema 4D Renders in Real Time


By Roger Sodre / [Studio Avante](http://studioavante.com/) / [@Roger_S](https://twitter.com/Roger_S)

[Syphon](http://syphon.v002.info/) by [Tom Butterworth](http://kriss.cx/tom/) and [Anton Marini](http://vade.info/)

## Download & Installation

Compiled, ready to use plugin download: 
[SyphonC4D.zip](http://download.studioavante.com/Syphon/SyphonC4D.zip)

Copy `SyphonRxx` folder to `/Applications/MAXON/CINEMA 4D Rxx/plugins/`

Open Cinema 4D, Render Settings, Effects, add the **Syphon Server** effect.

**Warning:** SyphonC4D will slow down the render (specially when in real time mode), use only for live preview.

**Warning:** Remove it from settings before sending it to a render farm.

## Supported Versions

Tested and validated on...

* Cinema 4D Lite	: No
* Cinema 4D R13.061	: Yes
* Cinema 4D R14.041	: Yes (use R13 version)
* Cinema 4D R15.064	: Yes (if fails, try R13 version)
* Cinema 4D R16.051	: Yes
* Cinema 4D R17.055	: Yes (use R16 version)
* Cinema 4D R18.057	: Yes (use R16 version)
* Cinema 4D R19.053	: Yes (use R16 version)
* Cinema 4D R20.055	: Yes
* Cinema 4D R21+	: Hopefully Yes


## Compiling the Source

The XCode projects are configured for the default location of Cinema 4D: `/Applications/MAXON/CINEMA 4D Rxx/`

If your installation is on another place, relink the Cinema 4D libs and edit `install.sh`

