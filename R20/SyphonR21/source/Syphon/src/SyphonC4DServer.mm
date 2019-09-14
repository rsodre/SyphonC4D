/*
 SyphonC4DServer.mm
 Cinder Syphon Implementation
 
 Created by astellato on 2/6/11
 
 Copyright 2011 astellato, bangnoise (Tom Butterworth) & vade (Anton Marini).
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

// This will solve redefinition of UInt on ge_sys_math.h
#define SYPHON

#ifndef C4DR13
#import "osx_include.h"		// Resolves UInt conflict
#endif
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#import <Syphon/Syphon.h>
#import "SyphonC4DServer.h"
#import "c4d.h"

static SyphonC4DServer		_instance;
static NSOpenGLContext*	_gl = NULL;
#define _glctx			((CGLContextObj)[_gl CGLContextObj])

#define BIND_CONTEXT()\
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];\
	NSOpenGLContext * prevContext = [NSOpenGLContext currentContext];\
	[_gl makeCurrentContext];\
	CGLLockContext(_glctx);

#define UNBIND_CONTEXT()\
	CGLUnlockContext(_glctx);\
	if ( prevContext )\
		[prevContext makeCurrentContext];\
	else\
		[NSOpenGLContext clearCurrentContext];\
	[pool drain];



SyphonC4DServer & SyphonC4DServer::Instance()
{
	return _instance;
}

SyphonC4DServer::SyphonC4DServer()
{
	//_openGLContext = NULL;
	mSyphon = nil;
	mTarget = GL_TEXTURE_RECTANGLE_ARB;
	mIntFormat = GL_RGB8;
	mFormat = GL_RGB;
	mWidth = 0;
	mHeight = 0;
	bAlpha = false;
	mTexID = 0;
	mFbo = 0;
}

SyphonC4DServer::~SyphonC4DServer()
{
	this->shutdown();
}

NSDictionary * SyphonC4DServer::getDescription()
{
	return ( mSyphon ? mSyphon.serverDescription : nil );
}


void SyphonC4DServer::shutdown()
{
	BIND_CONTEXT()

	if ( mTexID > 0 )
		glDeleteTextures(1, &mTexID);
	if ( mFbo > 0 )
		glDeleteFramebuffersEXT(1, &mFbo);
	if (mSyphon)
	{
		//NSLog(@"Syphpn shutdown...");
		[mSyphon stop];
		[mSyphon release];
		mSyphon = nil;
	}

	UNBIND_CONTEXT()
}

void * SyphonC4DServer::getCurrentContext()
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSOpenGLContext * currContext = [NSOpenGLContext currentContext];
	[pool drain];
	return (void*)currContext;
}


void SyphonC4DServer::start(std::string n, bool privateServer)
{
	// https://developer.apple.com/library/mac/documentation/graphicsimaging/conceptual/opengl-macprogguide/opengl_contexts/opengl_contexts.html
	// https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSOpenGLContext_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40004074
	// https://developer.apple.com/library/mac/documentation/graphicsimaging/conceptual/opengl-macprogguide/opengl_pixelformats/opengl_pixelformats.html
	if (_gl == NULL)
	{
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		//NSLog(@"CREATE CONTEXT ctx 0 [%ld]",(long)[[NSOpenGLContext currentContext] CGLContextObj]);
		NSOpenGLPixelFormatAttribute attribs [] = { NSOpenGLPFADoubleBuffer, NSOpenGLPFAPixelBuffer, 0 };
		NSOpenGLPixelFormat * pf = [(NSOpenGLPixelFormat *)[NSOpenGLPixelFormat alloc]
									initWithAttributes:attribs];
		_gl = [[NSOpenGLContext alloc] initWithFormat:pf shareContext:nil];
		[pool drain];
	}

	BIND_CONTEXT()

	NSString *title = [NSString stringWithCString:n.c_str()
										 encoding:[NSString defaultCStringEncoding]];
	if (!mSyphon)
	{
		NSDictionary *options = nil;
		if ( privateServer )
			// http://rypress.com/tutorials/objective-c/data-types/nsdictionary.html
			options = @{ SyphonServerOptionIsPrivate : [NSNumber numberWithBool:privateServer] };
		//mSyphon = [[SyphonServer alloc] initWithName:title context:CGLGetCurrentContext() options:options];
		mSyphon = [[SyphonServer alloc] initWithName:title context:_glctx options:options];
	}
	else
	{
		[mSyphon setName:title];
	}
    
	UNBIND_CONTEXT()
}

std::string SyphonC4DServer::getName()
{
	std::string name;
	if (mSyphon)
	{
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		name = [[mSyphon name] cStringUsingEncoding:[NSString defaultCStringEncoding]];
		[pool drain];
	}
	return name;
}

std::string SyphonC4DServer::getUUID()
{
	std::string uuid;
	if ( mSyphon )
	{
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		NSString * u = [mSyphon.serverDescription objectForKey:SyphonServerDescriptionUUIDKey];
		uuid = std::string( [u UTF8String] );
		[pool drain];
	}
	return uuid;
}

void SyphonC4DServer::setSize(int width, int height, bool alpha)
{
	BIND_CONTEXT()

	//NSLog(@"MAKE TEX...\n");
	// same size!
	//if ( mWidth == width && mHeight == height && bAlpha == alpha )
	//	return;

	// delete old
	if ( mTexID > 0 )
		glDeleteTextures(1, &mTexID);
	if ( mFbo > 0 )
		glDeleteFramebuffersEXT(1, &mFbo);

	// init
	mTarget = GL_TEXTURE_RECTANGLE_ARB;
	mIntFormat = GL_RGB8;
	mFormat = GL_RGB;
	mWidth = width;
	mHeight = height;
	bAlpha = alpha;
	mTexID = 0;
	mFbo = 0;
	this->setArea( 0, 0, mWidth, mHeight );

	// make new
	if ( width > 0 && height > 0 )
	{
		//NSLog(@"MAKE TEX %d %d\n",width,height);

		// Make texture
		glEnable(mTarget);
		glGenTextures(1, &mTexID);
		glBindTexture(mTarget, mTexID);
		//glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);
		mIntFormat = ( bAlpha ? GL_RGBA8 : GL_RGB8 );
		mFormat = ( bAlpha ? GL_RGBA : GL_RGB );
		// http://www.opengl.org/sdk/docs/man/html/glTexImage2D.xhtml
		glTexImage2D( mTarget, 0, mIntFormat, mWidth, mHeight,
					 0, mFormat, GL_UNSIGNED_BYTE, NULL);

		// Make FBO
		glGenFramebuffersEXT(1, &mFbo);
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, mFbo);
		glFramebufferTextureEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, mTexID, 0);
		glClearColor( 0, 0, 0, 0 );
		glClear( GL_COLOR_BUFFER_BIT );

		// unbind all
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT,0);
		glBindTexture( mTarget, 0 );

		//NSLog(@"TEX OK!!!\n");

		//this->publish();
	}

	UNBIND_CONTEXT()
}
void SyphonC4DServer::setArea (int startX, int startY, int endX, int endY)
{
	mStartX = startX;
	mStartY = startY;
	mAreaWidth = endX-mStartX;
	mAreaHeight = endY-mStartY;
}

void SyphonC4DServer::publishLine( PixelPost *pp )
{
	// Copy Line
	if ( pp == NULL )
		return;

	BIND_CONTEXT()

	glEnable(mTarget);
	glBindTexture(mTarget, mTexID);

	// file:///Volumes/HDD/Dev/C4D/_SDK/C4DR13SDKHTML20120522/help/pages/c4d_videopostdata/struct_PixelPost1139.html
	int bpp = pp->comp;
	GLenum fmt = ( bpp == 4 ? GL_RGBA : GL_RGB );
	int x = pp->xmin;
	int y = pp->line;
	int w = pp->xmax - pp->xmin + 1;
	//NSLog(@"publishLine xy [%d %d]  w [%d]  bpp [%d]  aa [%d]",x,y,w,bpp,pp->aa);
	if ( ! pp->aa )
	{
		// http://www.opengl.org/sdk/docs/man/html/glTexSubImage2D.xhtml
		glTexSubImage2D( mTarget, 0,
						x, (mHeight-y-1), w, 1,
						fmt, GL_FLOAT, pp->col );
	}
	else
	{
		// AA: 4 pixels per pixel
		// file:///Volumes/HDD/Dev/C4D/_SDK/C4DR13SDKHTML20120522/help/pages/c4d_videopostdata/struct_PixelPost1139.html#aa5
		Float32 line[w*bpp];
		for (int i = 0 ; i < w ; i++)
			for (int b = 0 ; b < bpp ; b++)
				line[i*bpp+b] = (pp->col[i*bpp*4+b+0] + pp->col[i*bpp*4+b+4] + pp->col[i*bpp*4+b+8] + pp->col[i*bpp*4+b+12]) / 4.0f;
		glTexSubImage2D( mTarget, 0,
						x, (mHeight-y-1), w, 1,
						fmt, GL_FLOAT, line );
	}

	this->publish();

	UNBIND_CONTEXT()
}


void SyphonC4DServer::publishBuffer( VPBuffer *buf )
{
	if ( buf == NULL )
		return;

	BIND_CONTEXT()

	glEnable(mTarget);
	glBindTexture(mTarget, mTexID);

	int bpp = buf->GetCpp();
	unsigned char line[mWidth*bpp];
	GLenum fmt = ( bpp == 4 ? GL_RGBA : GL_RGB );
	for (unsigned y = 0 ; y < mHeight ; y++)
	{
		buf->GetLine(0,y,mWidth,&line,8,true);
		// http://www.opengl.org/sdk/docs/man/html/glTexSubImage2D.xhtml
		glTexSubImage2D( mTarget, 0,
						0, (mHeight-y-1), mWidth, 1,
						fmt, GL_UNSIGNED_BYTE, line );
	}

	this->publish();

	//NSLog(@"publishBuffer PUBLISHED!");

	UNBIND_CONTEXT()
}

void SyphonC4DServer::publish()
{
	//NSLog(@"PUBLISH ctx [%ld]",(long)[[NSOpenGLContext currentContext] CGLContextObj]);
	[mSyphon publishFrameTexture:mTexID
				   textureTarget:mTarget
					 imageRegion:NSMakeRect(mStartX, mStartY, mAreaWidth, mAreaHeight)
			   textureDimensions:NSMakeSize(mWidth, mHeight)
						 flipped:false];
	//NSLog(@"PUBLISHED!");
}

