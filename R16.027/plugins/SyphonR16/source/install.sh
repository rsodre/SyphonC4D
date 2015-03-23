#!/bin/bash
#
#  install.sh
#  SyphonR16
#
#  Created by Roger S on 22/3/2015
#

# Get preprocessor macros to shell (not working)
#eval "${GCC_PREPROCESSOR_DEFINITIONS}"
#eval "${GCC_PREPROCESSOR_MACROS}"

# Check cinema install version
# http://askubuntu.com/questions/299710/how-to-determine-if-a-string-is-a-substring-of-another-in-bash
# R13 build
if [ "${GCC_PREPROCESSOR_DEFINITIONS/C4DR13}" != "$GCC_PREPROCESSOR_DEFINITIONS" ]; then
	export C4D="R13"
	export SOURCE_DIR="${R16_DIR}"
# R15 build
elif [ "${GCC_PREPROCESSOR_DEFINITIONS/C4DR15}" != "$GCC_PREPROCESSOR_DEFINITIONS" ]; then
	export C4D="R15"
	export SOURCE_DIR="${R16_DIR}"
# R16 build
else
	export C4D="R16"
	export SOURCE_DIR="${PROJECT_DIR}"
fi
export DEST_FOLDER="${LOCAL_APPS_DIR}/MAXON/CINEMA 4D ${C4D}/plugins/${TARGET_NAME}"
echo "Installing for [${C4D}] on [${DEST_FOLDER}]..."

# make plugin folder
sudo mkdir -p "${DEST_FOLDER}"
sudo chmod a+rw "${DEST_FOLDER}"

# copy files
export THE_LIB="${TARGET_BUILD_DIR}/${EXECUTABLE_NAME}"
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
