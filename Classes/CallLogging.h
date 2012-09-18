//
//  CallLogging.h
//  BomberBilly
//
//  Created by Ruud van Falier van Falier on 3/21/11.
//  Copyright 2011 DotTech. All rights reserved.
//

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