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
* Cinema 4D R21.016	: Yes
* Cinema 4D S22.016	: Yes (use R21 version)


## Compiling the Source (R20+)

But the commited projects are ready to build.

In case you need to replicate with another SDK, inside R20 folder, there's one script for generating the C4D project and sources and another for installing.

The generation script (`gen_RXX.YYY.sh`) need to be updated with your SDK and Tools folder. You can/need to generate project and sources separated:

* `./gen_RXX.YYY.sh project`
* `./gen_RXX.YYY.sh code`

If you re-generate the project, you need to manually do this to the XCode project...

* Remove everything inside `source/Syphon/lib`
* Add to `Syphon.framework` to `source/Syphon/lib`
* Build Phases, Link Binary with Libraries, add:
	* Syphon.framework
	* OpenGL.framework
	* AppKit.framework
* Build Phases, add new Run Script Phase with:
	* `../../install_RXX.YYY.sh`
* Maybe relink frameworks and configuration files
* (optional) Edit **syphonr21** schema and set your `Cinema 4D.app` on **Run**, **Executable** to be able to run and debug the plugin from XCode.

The install script (`install_RXX.YYY.sh`) is configured for the default location of Cinema 4D: `/Applications/MAXON/CINEMA 4D Rxx/`. If your installation is on another place, edit it.


