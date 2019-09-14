#!/bin/bash

# Configure
export FRAMEWORKS_DIR="../../C4DSDK/R21.016/frameworks/"
export TOOL_DIR="../../C4DSDK/Tools/ProjectTool_R21_20190205"

# Create link to frameworks
export FRAMEWORKS_LINK="./frameworks"
ln -sf "$FRAMEWORKS_DIR" "$FRAMEWORKS_LINK"

# Generate project
export GENERATED_DIR="$PWD/SyphonR21"
if [ "$1" = "project" ]; then
	# options: $TOOL_DIR/resource/config.txt
	echo "Generating project..."
	export TOOL_BIN="$TOOL_DIR/kernel_app.app/Contents/MacOS/kernel_app"
	"$TOOL_BIN" g_updateproject="$GENERATED_DIR"
	echo "Done!"
elif [ "$1" = "code" ]; then
	# usage: sourceprocessor.py [-h] [--registeronly] [--singlethreaded] [-f] [--option OPTION] [--doxygen] [--publicframeworks] directories [directories ...]
	echo "Generating code..."
	python "$FRAMEWORKS_LINK/settings/sourceprocessor/sourceprocessor.py" "$GENERATED_DIR"
	echo "Done!"
else
	echo "usage: ./gen.sh project"
	echo "usage: ./gen.sh code"
fi

# cleanup
#unlink "$FRAMEWORKS_LINK"
