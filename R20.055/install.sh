#!/bin/bash

# Change Syphon searchpath
# http://lessons.runrev.com/m/4071/l/15029-linking-an-osx-external-bundle-with-a-dylib-library
# http://qin.laya.com/tech_coding_help/dylib_linking.html
# otool -L Blendy360Cam.dylib
#
# MUST ADD TO OTHER LINKER FLAGS: -headerpad_max_install_names
#
export PLUGIN_NAME="SyphonR20"
export THE_LIB="${PROJECT_DIR}/${EXECUTABLE_NAME}"
if [ ! -f "${THE_LIB}" ]; then
	export THE_LIB="${PROJECT_DIR}/../${EXECUTABLE_NAME}"
fi
if [ ! -f "${THE_LIB}" ]; then
	echo "Lib not found: ${THE_LIB}"
	exit 1
fi
ls -l "${THE_LIB}"

#install_name_tool -change @loader_path/../Frameworks/Syphon.framework/Versions/A/Syphon @loader_path/Syphon.framework/Versions/A/Syphon "${THE_LIB}"
install_name_tool -change @loader_path/../Frameworks/Syphon.framework/Versions/A/Syphon @rpath/Syphon "${THE_LIB}"
install_name_tool -add_rpath "@loader_path/Syphon.framework/Versions/A/" "${THE_LIB}"
install_name_tool -add_rpath "@loader_path/../resources/Syphon/lib/Syphon.framework/Versions/A/" "${THE_LIB}"
install_name_tool -add_rpath "@executable_path/../../../plugins/${PLUGIN_NAME}/res/libs/osx/Syphon.framework/Versions/A/" "${THE_LIB}"
otool -L "${THE_LIB}" | grep Syphon


##################
#
# Deploy
#
export TARGET_PLUGINS_FOLDER="/Applications/MAXON/CINEMA 4D R20/plugins"
export TARGET_FOLDER="$TARGET_PLUGINS_FOLDER/SyphonR20"
export TARGET_RES_FOLDER="$TARGET_FOLDER/res"
export TARGET_LIBS_FOLDER="$TARGET_RES_FOLDER/libs/osx"
export PROJECT_FOLDER=".."

if [ -d "$TARGET_FOLDER" ]
then
	rm -rf "$TARGET_FOLDER"
fi
mkdir "$TARGET_FOLDER"

cp "$PROJECT_FOLDER/"*.xlib "$TARGET_FOLDER/"
cp -R "$PROJECT_FOLDER/res" "$TARGET_FOLDER/"

mkdir -p "$TARGET_LIBS_FOLDER"
cp -R "../source/Syphon/lib/Syphon.framework" "$TARGET_LIBS_FOLDER/"
