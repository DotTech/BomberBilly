/*
 *  Helpers.h
 *  BomberBilly
 *
 *  Created by Ruud van Falier on 3/20/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

// This file is included by Constants.h so it will be available from all source files
// It contains C functions and structs that are not specificly related to a single class


/************************************************************************/
// Helper for callback functionality									 /
/************************************************************************/

// Struct that allows us to define callback methods
typedef struct sProgressCallback {
	id callbackObject;
	SEL callbackMethod;
} ProgressCallback;

// Use this function to create a ProgressCallback object
static ProgressCallback CreateCallback(id obj, SEL method) 
{
    ProgressCallback r;
	r.callbackObject = obj;
	r.callbackMethod = method;
	return r;
}


/************************************************************************/
// Call logging functions												 /
/************************************************************************/

// These functions write a log entry with information about the caller.
// It logs the class name, method name and the line it was called from.
//
// There are 4 different call log functions that you should use:
// - CLogGL	 :	Use this in methods that are being called for every iteration of the gameloop (let's call them update methods)
//				In this project, update methods are always called for every iteration without checking if it's time to update, or what the object's state is.
//				For example: hero.update() is always called and only then we start checking how much time has passed since the last update 
//							 and if we actually need to perform the update... 
//							 The same goes for state updates, we call Move() during every update and that method checks if the current state allows hero to move
//				Always put the call to CLogGL on the first line of the method so it is always called!
//
// - CLogGLU :	This one must also be placed inside update methods, but this time only when the update is being executed!
//				So in hero.move() we will first call CLogGL(), then we check if moving is actually necessary/possible and only then we call CLogGLU()
//
// - CLog	 :	Use this function for every other type of method call you want to log.

#if DEBUG_ENABLE_CALL_LOGGING
#   define CLog(fmt, ...) if (CLogFilter(__FUNCTION__)) NSLog((@"CLog: %s [Line %d]" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define CLog(...)
#endif

#if DEBUG_ENABLE_CALL_LOGGING && DEBUG_ENABLE_CALL_LOGGING_GAMELOOP_ALL
#   define CLogGL(fmt, ...) if (CLogFilter(__FUNCTION__)) NSLog((@"CLogGL: %s [Line %d] " fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define CLogGL(...)
#endif

#if DEBUG_ENABLE_CALL_LOGGING && DEBUG_ENABLE_CALL_LOGGING_GAMELOOP_UPDATES
#   define CLogGLU(fmt, ...) if (CLogFilter(__FUNCTION__)) NSLog((@"CLogGLU: %s [Line %d] " fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define CLogGLU(...)
#endif

// Used by the CLog macro to check if filter is active and if the data we're logging passes the filter
static bool CLogFilter(const char* caller)
{
	if (DEBUG_CALL_LOGGING_FILTER != @"") {
		NSString* callerName = [NSString stringWithCString:caller encoding:NSUTF8StringEncoding];
		return [callerName rangeOfString:DEBUG_CALL_LOGGING_FILTER].location != NSNotFound;
	}
	return true;
}


/************************************************************************/
// Conversion of level row/column coordinates to tile data array index   /
/************************************************************************/

// Convert x/y coordinate to array index
static int CoordsToIndex(int x, int y)
{
	CLogGL();
	return y * (SCREEN_WIDTH / TILE_WIDTH) + x;
}

// Convert array index to CGPoint
static CGPoint IndexToCoords(int index)
{
	CLogGL();
	int columns = SCREEN_WIDTH / TILE_WIDTH;
	int x = index % columns;
	int y = floor(index / columns);
	
	return CGPointMake(x, y);
}


/*****************************************************************************/
// Cleanup function for object pointer arrays containing Objective C objects  /
/*****************************************************************************/

// Loops through pointer array and calls dealloc for each object then deletes the array
// If we would only call delete it would just remove the pointers and the objects would still be retained in memory
// TODO: i used free() instead of delete because the last is only available from C++
//		 test in memory analyzer if this makes any difference
static void releaseObjectArray(NSObject** array, int size)
{
	CLog();
	if (array != NULL) {
		for (int i=0; i<size; i++) {
			if (array[i] != nil) {
				[array[i] release];
			}
		}
	}
	free(array);
}
