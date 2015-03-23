#define the output extension here
if !C4D_64BIT
OEXT=so
else C4D_64BIT
OEXT=so64
endif

noinst_PROGRAMS = $(c4d_bin)/plugins/cinema4dsdk/cinema4dsdk.$(OEXT)

AM_CXXFLAGS = -fPIC
AM_CFLAGS = -fPIC

__c4d_bin__plugins_cinema4dsdk_cinema4dsdk___OEXT__SOURCES = \
	./source/main.cpp \
	./source/animation/blinker.cpp \
	./source/bitmapfilter/filtermatrix.cpp \
	./source/bitmapfilter/filterthreshold.cpp \
	./source/bitmapfilter/paint_saver_test.cpp \
	./source/filter/bff.cpp \
	./source/filter/stl.cpp \
	./source/gui/activeobject.cpp \
	./source/gui/asynctest.cpp \
	./source/gui/gradientuserarea.cpp \
	./source/gui/layershaderbrowser.cpp \
	./source/gui/listview.cpp \
	./source/gui/memstat.cpp \
	./source/gui/menutest.cpp \
	./source/gui/serial.cpp \
	./source/gui/serial_hook.cpp \
	./source/gui/subdialog.cpp \
	./source/object/atom.cpp \
	./source/object/circle.cpp \
	./source/object/dropeffector.cpp \
	./source/object/gl_test_object.cpp \
	./source/object/gravitation.cpp \
	./source/object/hair_collision.cpp \
	./source/object/hair_constraint.cpp \
	./source/object/hair_deformer.cpp \
	./source/object/hair_force.cpp \
	./source/object/hair_generator.cpp \
	./source/object/hair_grass.cpp \
	./source/object/morphmixer.cpp \
	./source/object/noiseeffector.cpp \
	./source/object/roundedtube.cpp \
	./source/object/spherify.cpp \
	./source/object/triangulate.cpp \
	./source/shader/bitmapdistortionshader.cpp \
	./source/shader/gl_material.cpp \
	./source/shader/gradientshader.cpp \
	./source/shader/hair_shader.cpp \
	./source/shader/illumination.cpp \
	./source/shader/mandelbrotshader.cpp \
	./source/shader/particlevolume.cpp \
	./source/shader/simplematerial.cpp \
	./source/tag/hair_render.cpp \
	./source/tag/hair_styling.cpp \
	./source/tag/lookatcamera.cpp \
	./source/tool/edgecuttool.cpp \
	./source/tool/liquidtool.cpp \
	./source/tool/reversenormals.cpp \
	./source/tool/sculpting.cpp \
	./source/videopost/hair_videopost.cpp \
	./source/videopost/vpcolorize.cpp \
	./source/videopost/vpinvertimage.cpp \
	./source/videopost/vpreconstructimage.cpp \
	./source/videopost/vpvisualizenormals.cpp \
	./source/videopost/vpstereo.cpp \
	./source/videopost/visualize_channel.cpp \
	./source/datatype/datatype.cpp \
	./source/falloff/randomfalloff.cpp 

if INTEL
INTELFLAGS = -static -limf -lirc -lsvml -liomp5
else
INTELFLAGS = -Bstatic
endif

__c4d_bin__plugins_cinema4dsdk_cinema4dsdk___OEXT__LDFLAGS = \
	-nodefaultlibs -shared \
	$(top_builddir)/work/bin/resource/_api_lib/libapi_lib.a \
	$(INTELFLAGS) -Wl,--version-script=$(c4d_bin)/resource/_api_lib/export_lx.map

INCLUDES =  \
	-I$(c4d_bin)/plugins/cinema4dsdk/res \
	-I$(c4d_bin)/plugins/cinema4dsdk/res/description \
	-I$(c4d_bin)/plugins/cinema4dsdk/source/gui \
	-I$(c4d_api) \
	-I$(c4d_api)/c4d_customgui \
	-I$(c4d_api)/c4d_gv \
	-I$(c4d_api)/c4d_libs \
	-I$(c4d_api)/c4d_preview \
	-I$(c4d_bin)/modules/bugslife/source/mysql51/include/mysql \
	-I$(c4d_bin)/resource/modules/modeling/res/description \
	-I$(c4d_bin)/resource/modules/newman/res/description \
	-I$(c4d_bin)/resource/modules/objects/res/description \
	-I$(c4d_bin)/resource/modules/xtensions/res/description \
	-I$(c4d_bin)/resource/res/description

