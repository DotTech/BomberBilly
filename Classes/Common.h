/*
 *  Helpers.h
 *  BomberBilly
 *
 *  Created by Ruud van Falier on 3/20/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

// This file is included by Constants.h so it will be available from all source files
// It contains commonly used C functions and structs that are not specificly related to a single class

#import "Callback.h"
#import "CallLogging.h"


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
