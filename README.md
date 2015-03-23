# SyphonC4D

A Syphon Server to visualize Cinema 4D Renders in Real Time

By Roger Sodre / [Studio Avante](http://studioavante.com/)

[Syphon](http://syphon.v002.info/) by [Tom Butterworth](http://kriss.cx/tom/) and [Anton Marini](http://vade.info/)

Download & Installation
=======================

A ready to use plugin can be downloaded here: 
[SyphonC4D.zip](http://download.studioavante.com/Syphon/SyphonC4D.zip)

Copy `Syphon.framework` to `/Library/Frameworks/`

Copy `SyphonRxx` folder to `/Applications/MAXON/CINEMA 4D Rxx/plugins/`

Open Cinema 4D, Render Settings, Effects, add the **Syphon Server** effect.

**Warning:** Syphon will slow down the render (specially real time mode), use only if needed.

**Warning:** Remove it completely if you want to send your project to a render farm.

Supported Versions
==================

From R13 to R16 and beyond...

Use SyphonR13 for Cinema 4D R14.

SyphonR16 will hopefully work on future releases.

Will not work with Cinema 4D Lite.

Compiling the Source
====================

The XCode projects are configured for the default location of Cinema 4D: `/Applications/MAXON/CINEMA 4D Rxx/`

If your installation is on another place, relink the Cinema 4D libs and edit `install.sh`

