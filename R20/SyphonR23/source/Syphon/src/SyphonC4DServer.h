/*
 SyphonC4DServer.h
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

#pragma once

//#include "cinder/app/AppBasic.h"
//#include "cinder/gl/Texture.h"
#include <string>
#include "opengl/gl.h"

typedef signed int c4d_Int32;
typedef float c4d_Float32;

#ifdef __OBJC__
@class SyphonServer;
@class NSDictionary;
#else
class SyphonServer;
class NSDictionary;
#endif
class PixelPost;
class VPBuffer;

class SyphonC4DServer {
	public:
	SyphonC4DServer();
	~SyphonC4DServer();

	static SyphonC4DServer & Instance();
	void shutdown();

	void * getCurrentContext();

	void start (std::string n, bool privateServer=false);
	void setSize (int width, int height, bool alpha=false);
	void setArea (int startX, int startY, int endX, int endY);

	std::string getName();
	std::string getUUID();
	NSDictionary * getDescription();
	bool isRunning()	{return (bool)mSyphon; }

	void publishLine( PixelPost *pp );
    void publishBuffer( VPBuffer *buf );

	//void publishLine( c4d_Int32 line, c4d_Float32 *col, c4d_Int32 xmin, c4d_Int32 xmax, c4d_Int32 comp, bool aa )

    
protected:
	SyphonServer	*mSyphon;
	GLenum			mTarget;
	GLuint			mTexID;
	GLint			mIntFormat;
	GLenum			mFormat;
	GLuint			mWidth, mHeight;
	GLuint			mFbo;
	int				mStartX, mStartY, mAreaWidth, mAreaHeight;
	bool			bAlpha;

	void publish();

};

