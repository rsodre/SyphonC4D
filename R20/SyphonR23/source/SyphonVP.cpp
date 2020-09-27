/////////////////////////////////////////////////////////////
// CINEMA 4D SDK                                           //
/////////////////////////////////////////////////////////////
// (c) 1989-2004 MAXON Computer GmbH, all rights reserved  //
/////////////////////////////////////////////////////////////

#include "main.h"
#include "c4d.h"
#include "c4d_symbols.h"
#include "lib_clipmap.h"
#include "SyphonC4DServer.h"
#include "SyphonPlugin.h"
#include <sstream>
#include <ios>
#include <iomanip>
#include <vector>
#include <map>

#include <stdarg.h>
void _printf(const char *format,...);
void _printf(const char *format,...)
{
#ifndef RELEASE
	char fmt[1024];
	sprintf(fmt,"--- Syphon: %s",format);
	va_list arp;
	va_start(arp,format);
	char buf[1024];
	vsprintf(buf,fmt,arp);
	GePrint(maxon::String(buf));
	va_end(arp);
#endif
}

// Syphon must be static because of multithreading
class SyphonVP;
static SyphonVP * thePlugin = NULL;


////////////////////////////////////
//
// PLUGIN CLASS
//
class SyphonVP : public VideoPostData
{
	INSTANCEOF(SyphonVP,VideoPostData)

public:

	Bool Init(GeListNode *node);
	void Free(GeListNode *node);
	Bool GetDEnabling(GeListNode *node, const DescID &id,const GeData &t_data,DESCFLAGS_ENABLE flags,const BaseContainer *itemdesc);
	static NodeData *Alloc(void) {
#ifdef C4DR13
		return gNew SyphonVP;
#else
		return NewObjClear(SyphonVP);
#endif
	}
	void AllocateBuffers(BaseVideoPost* node, Render* render, BaseDocument* doc);

	VIDEOPOSTINFO GetRenderInfo(BaseVideoPost* node);
	RENDERRESULT Execute(BaseVideoPost *node, VideoPostStruct *vps);
	void ExecuteLine(BaseVideoPost* node, PixelPost* pp);

private:

	// plugin options
	Bool		bSyphonEnabled;
	Int32		mSyphonMode;

	// scene info
	bool			bAlpha;
	Vector			res;				// Frame resolution
	CameraObject	*mCamera;

	// syphon lock
	pthread_mutex_t _lineLock;

};


/////////////////////////////////////////////
//
// VIDEOPOST
//
Bool SyphonVP::Init(GeListNode *node)
{
	thePlugin = this;

	pthread_mutex_init(&_lineLock, NULL);

	BaseVideoPost	*pp = (BaseVideoPost*)node;
	BaseContainer	*nodeData = pp->GetDataInstance();

	nodeData->SetBool(		VP_SYPHON_ENABLED,		true);
	nodeData->SetInt32(		VP_SYPHON_MODE,			VP_SYPHON_MODE_REALTIME);

	return true;
}

void SyphonVP::Free(GeListNode *node)
{
	if ( thePlugin )
	{
		thePlugin = NULL;
		pthread_mutex_destroy(&_lineLock);
	}
}

Bool SyphonVP::GetDEnabling(GeListNode *node, const DescID &id,const GeData &t_data,DESCFLAGS_ENABLE flags,const BaseContainer *itemdesc)
{
	bool enabled = true;
	BaseContainer *data = ((BaseObject*)node)->GetDataInstance();
	switch (id[0].id)
	{
		case VP_SYPHON_MODE:
			enabled = data->GetBool(VP_SYPHON_ENABLED);
			break;
	}
	return enabled;
}

void SyphonVP::AllocateBuffers(BaseVideoPost* node, Render* render, BaseDocument* doc)

{
	// Get camera
	mCamera = NULL;
	BaseDraw *bd_render = doc->GetRenderBaseDraw();		// the view set as "Render View"
	BaseDraw *bd_active = doc->GetActiveBaseDraw();		// The current view
	Int32 proj = bd_active->GetProjection();
	BaseDraw *bd = ( proj == Pperspective ? bd_active : bd_render );

	if ( bd )
	{
		mCamera = (CameraObject*) bd->GetSceneCamera(doc);		// the active camera
		if ( ! mCamera )
			mCamera = (CameraObject*) bd->GetEditorCamera();		// the defaut camera
	}

	if ( mCamera == NULL )
	{
		SyphonC4DServer::Instance().shutdown();
		_printf("Can't find camera! Syphon Server Disabled.");
	}
}

VIDEOPOSTINFO SyphonVP::GetRenderInfo(BaseVideoPost* node)
{
	return VIDEOPOSTINFO::EXECUTELINE;
}

RENDERRESULT SyphonVP::Execute(BaseVideoPost *node, VideoPostStruct *vps)
{
	BaseDocument *doc = vps->doc;
	BaseContainer *nodeData = node->GetDataInstance();

	// For each RENDER
	if (vps->vp==VIDEOPOSTCALL::FRAMESEQUENCE && vps->open)
	{
		BaseContainer renderData = ( vps->render ? vps->render->GetRenderData() : doc->GetActiveRenderData()->GetData() );

		bSyphonEnabled	= nodeData->GetBool(VP_SYPHON_ENABLED);
		mSyphonMode		= nodeData->GetInt32(VP_SYPHON_MODE);
		bAlpha			= renderData.GetBool(RDATA_ALPHACHANNEL);
		res.x			= renderData.GetFloat(RDATA_XRES);
		res.y			= renderData.GetFloat(RDATA_YRES);

		// Cinema4D appears to be sending invalid data on alpha channel
		// so no alpha for this server
		bAlpha = false;

		if ( bSyphonEnabled )
		{
			SyphonC4DServer::Instance().start("SyphonC4D");
			SyphonC4DServer::Instance().setSize( int(res.x), int(res.y), bAlpha );
		}
		else
		{
			SyphonC4DServer::Instance().shutdown();
		}
	}
	// Executed after each frame
	else if (vps->vp==VIDEOPOSTCALL::FRAME && ! vps->open)
	{
		// Publish full frame to Syphon Server
		if ( bSyphonEnabled )//&& mSyphonMode == VP_SYPHON_MODE_FRAME )
		{
			// TODO: R23 is delivering not the final image!!!
			VPBuffer * buf = vps->render->GetBuffer(VPBUFFER_RGBA,0);
			SyphonC4DServer::Instance().publishBuffer( buf );
		}
	}

	return RENDERRESULT::OK;
}


void SyphonVP::ExecuteLine(BaseVideoPost* node, PixelPost* pp)
{
	// Publish line to Syphon Server
	if ( bSyphonEnabled && mSyphonMode == VP_SYPHON_MODE_REALTIME && pp->valid_line )
	{
		// several processes may be rendering
		// but only one may be publishing
		pthread_mutex_lock(&_lineLock);
		SyphonC4DServer::Instance().publishLine( pp );
		pthread_mutex_unlock(&_lineLock);
	}
}

Bool RegisterSyphonPlugin(void)
{
	_printf("READY!");
	return RegisterVideoPostPlugin(ID_SYPHON,GeLoadString(IDS_SYPHONVP),PLUGINFLAG_VIDEOPOST_MULTIPLE,SyphonVP::Alloc,"SyphonPlugin"_s,0,0);
}


