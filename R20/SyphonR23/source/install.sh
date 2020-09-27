#!/bin/bash
#
#  install.sh
#  SyphonR20
#
#  Created by Roger S on 22/3/2015
#

# Get preprocessor macros to shell (not working)
#eval "${GCC_PREPROCESSOR_DEFINITIONS}"
#eval "${GCC_PREPROCESSOR_MACROS}"

# Change Syphon searchpath
# http://lessons.runrev.com/m/4071/l/15029-linking-an-osx-external-bundle-with-a-dylib-library
# http://qin.laya.com/tech_coding_help/dylib_linking.html
export THE_LIB="${TARGET_BUILD_DIR}/${EXECUTABLE_NAME}"
install_name_tool -change @loader_path/../Frameworks/Syphon.framework/Versions/A/Syphon @loader_path/Syphon.framework/Versions/A/Syphon "$THE_LIB"
otool -L "$THE_LIB" | grep Syphon.framework

# Check cinema install version
# http://askubuntu.com/questions/299710/how-to-determine-if-a-string-is-a-substring-of-another-in-bash
# R21 build
if [ "${GCC_PREPROCESSOR_DEFINITIONS/C4DR21}" != "$GCC_PREPROCESSOR_DEFINITIONS" ]; then
	export C4D="R21"
	export SOURCE_DIR="${R21_DIR}"
# R20 build
else
	export C4D="R20"
	export SOURCE_DIR="${PROJECT_DIR}"
fi
export DEST_FOLDER="${LOCAL_APPS_DIR}/MAXON/CINEMA 4D ${C4D}/plugins/${TARGET_NAME}"
echo "Installing for [${C4D}] on [${DEST_FOLDER}]..."

# make plugin folder
sudo mkdir -p "${DEST_FOLDER}"
sudo chmod a+rw "${DEST_FOLDER}"

# copy files
sudo cp "${THE_LIB}" "${PROJECT_DIR}"
sudo cp "${THE_LIB}" "${DEST_FOLDER}"

# copy res folder
export THE_RES="${SOURCE_DIR}/res"
if [ -d "${DEST_FOLDER}/res" ]; then
	rm -rf "${DEST_FOLDER}/res"
fi
cp -R "${THE_RES}" "${DEST_FOLDER}/"

# finito!
ls -l "${DEST_FOLDER}"
