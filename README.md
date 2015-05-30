# SyphonC4D

A Syphon Server to visualize Cinema 4D Renders in Real Time


By Roger Sodre / [Studio Avante](http://studioavante.com/) / [@Roger_S](https://twitter.com/Roger_S)

[Syphon](http://syphon.v002.info/) by [Tom Butterworth](http://kriss.cx/tom/) and [Anton Marini](http://vade.info/)

Download & Installation
=======================

Compiled, ready to use plugin download: 
[SyphonC4D.zip](http://download.studioavante.com/Syphon/SyphonC4D.zip)

Copy `SyphonRxx` folder to `/Applications/MAXON/CINEMA 4D Rxx/plugins/`

Open Cinema 4D, Render Settings, Effects, add the **Syphon Server** effect.

**Warning:** SyphonC4D will slow down the render (specially when in real time mode), use only for live preview.

**Warning:** Remove it from your project before sending it to a render farm.

Supported Versions
==================

Cinema 4D R13	: Yes

Cinema 4D R14	: Yes (use the R13 version)

Cinema 4D R15	: Yes (if it does not work, try the R13 version)

Cinema 4D R16	: Yes

Cinema 4D R17+	: Hopefully yes

Cinema 4D Lite	: No

Compiling the Source
====================

The XCode projects are configured for the default location of Cinema 4D: `/Applications/MAXON/CINEMA 4D Rxx/`

If your installation is on another place, relink the Cinema 4D libs and edit `install.sh`

