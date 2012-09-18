//
//  DebugElevators.m
//  BomberBilly
//
//  Created by Ruud van Falier on 3/18/11.
//  Copyright 2011 DotTech. All rights reserved.
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


- (Tile**) getTilesData:(World*)world progressCallback:(Callback)callback
{
	CLog();
    
    // DrawingFlag values
    // 0:dfDrawNothing, 1:dfIndestructibleBlock, 2:dfDestructibleBlock, 3:dfJumpBlock, 4:dfDynamite, 5:dfSpikes
    // 6:dfExitDoor, 7:dfElevator, 8:dfSwitch
	int drawData[13][10] = {
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
	
    // PhysicFlag values
    // 0:pfNoTile, 1:pfIndestructibleTile, 2:pfDestructibleTile, 3:pfJumpTile, 4:pfBombTile, 5:pfDeadlyTile
    // 6:pfFinishTile, 7:pfElevatorTile, 8:pfSwitchTile
	int physicsData[13][10] = {
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
	return [self createTilesLayer:world physicsData:physicsData drawingData:drawData switchesParams:NULL progressCallback:callback];
}


// Initialize the enemy sprites for this level
- (Entity**) getEnemyData:(World*)world
{
	CLog();
	enemyCount = 1;
	Enemy** enemies = new Enemy*[enemyCount];
	
	for (int i=0; i<enemyCount; i++) {
		enemies[i] = [[Enemy alloc] initWithWorld:world];
	}
    
	enemies[0].x = 50;
	enemies[0].y = 480;
    enemies[0].preventFallingOfBlocks = YES;
	enemies[0].flipped = YES;
	
	return enemies;
}

@end
