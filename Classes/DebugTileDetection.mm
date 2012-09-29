//
//  DebugBombing.m
//  BomberBilly
//
//  Created by Ruud van Falier on 3/18/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import "DebugTileDetection.h"
#import "Level.h"

@implementation DebugTileDetection


- (DebugTileDetection*) init
{
	CLog();
	self = [super init];
	
	self.startBombs = 20;
	self.heroSpawnPoint = CGPointMake(20, 384);
	
    #if DEBUG_TILE_DETECTION_ENEMIES
        self.heroSpawnPoint = CGPointMake(-100, 384);
    #endif
    
	return self;
}


- (Tile**) getTilesData:(World*)world progressCallback:(Callback)callback
{
	CLog();
	int drawData[13][10] = {
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	};
	
	int physicsData[13][10] = {
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	};
	
	// Create the tile objects
	return [self createTilesLayer:world physicsData:physicsData drawingData:drawData switchesParams:NULL progressCallback:callback];
}


- (Entity**) getEnemyData:(World*)world
{
  	CLog();
    
    #if !DEBUG_TILE_DETECTION_ENEMIES
        self.enemyCount = 0;
        return NULL;
    #endif
    
	self.enemyCount = 1;
	Enemy** enemies = new Enemy*[self.enemyCount];
	
    enemies[0] = [[Enemy alloc] initWithWorld:world];
	enemies[0].x = 20;
	enemies[0].y = 384;
    
	return enemies;
}

@end
