#pragma once
//#if (defined C4DR13) || (defined C4DR15)
#if (defined C4DR13)

#ifndef C4DR13
#define C4DR13
#endif

// R13/14/15 compatibility to R16

// inline Int32 GetC4DVersion(void) { return C4DOS.version; }

typedef Real Float;
typedef SReal Float32;
typedef LONG Int32;
typedef LMatrix Matrix;
typedef UWORD UInt16;

#define SetFloat SetReal
#define GetFloat GetReal
#define SetInt32 SetLong
#define GetInt32 GetLong

#define PI pi
#define PI2 pi2
#define PI05 pi05

#endif	// C4DR13
