//
//  DebugElevators.m
//  BomberBilly
//
//  Created by Ruud van Falier on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DebugElevators.h"

@implementation DebugElevators

- (DebugElevators*) init
{
	CLog();
	[super init];
	
	self.startBombs = 10;
	self.heroSpawnPoint = CGPointMake(10, 480);
	//self.heroSpawnPoint = CGPointMake(20, 480);
	
	return self;
}


- (Tile**) getTilesData:(World*)world progressCallback:(ProgressCallback)callback
{
	CLog();
	// 0 - draw nothing
	// 1 - gray tile
	// 2 - yellowish tile
	// 3 - jump tile
	// 4 - dynamite
	// 5 - spikes
	// 6 - exit
	// 7 - elevator
	int tilesDrawData[13][10] = {
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 1, 0, 1, 0, 0, 0, 0, 0, 0, 1 },
		{ 1, 0, 1, 0, 4, 0, 0, 4, 0, 1 },
		{ 1, 0, 1, 0, 1, 0, 0, 2, 2, 1 },
		{ 1, 0, 1, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 7, 1, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 1, 1, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 0, 1, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 0, 1, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 0, 1, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 0, 1, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 0, 1, 0, 1, 0, 0, 7, 0, 1 },
		{ 1, 1, 1, 1, 1, 7, 1, 1, 1, 1 }
	};
	
	// 0 = No tile
	// 1 = Indistructible platform
	// 2 = Destructible platform
	// 3 = Jump platform
	// 4 = Bomb
	// 5 = Deadly
	// 6 = Exit
	// 7 = Elevator
	int tilesPhysicsData[13][10] = {
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 1, 0, 1, 0, 0, 0, 0, 0, 0, 1 },
		{ 1, 0, 1, 0, 4, 0, 0, 4, 0, 1 },
		{ 1, 0, 1, 0, 1, 0, 0, 2, 2, 1 },
		{ 1, 0, 1, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 7, 1, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 1, 1, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 0, 1, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 0, 1, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 0, 1, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 0, 1, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 0, 1, 0, 1, 0, 0, 7, 0, 1 },
		{ 1, 1, 1, 1, 1, 7, 1, 1, 1, 1 }
	};
	
	// Create the tile objects
	return [self createTilesLayer:world physicsData:tilesPhysicsData drawingData:tilesDrawData switchesParams:NULL progressCallback:callback];
}

@end
