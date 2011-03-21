//
//  DebugLevel.mm
//  BomberBilly
//
//  Created by Ruud van Falier on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// TODO: Write more documentation on this class so it can be used in future as example of how to create levels

#import "DebugLevel.h"
#import "Enemy.h"

@implementation DebugLevel

- (DebugLevel*) init
{
	CLog();
	[super init];
	
	self.startBombs = 10;
	self.heroSpawnPoint = CGPointMake(20, 480);
	
	return self;
}


- (Tile**) getTilesData:(World*)world progressCallback:(ProgressCallback)callback
{
	CLog();
	/* Define what tile images to draw in the world */
	
	// 0 - draw nothing
	// 1 - gray tile
	// 2 - yellowish tile
	// 3 - jump tile
	// 4 - dynamite
	// 5 - spikes
	// 6 - exit
	// 7 - elevator
	// 8 - switch
	int tilesDrawData[13][10] = {
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 8, 8, 0, 8, 0, 0, 0, 4 },
		{ 2, 2, 2, 2, 5, 1, 1, 5, 5, 2 },
		{ 0, 8, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 2, 2, 2, 2, 7, 2, 1, 0, 0, 0 },
		{ 0, 8, 0, 0, 0, 8, 1, 1, 1, 0 },
		{ 1, 1, 5, 5, 5, 5, 1, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 1, 0, 1, 1 },
		{ 2, 2, 2, 2, 2, 2, 1, 0, 0, 0 },
		{ 5, 5, 5, 5, 5, 5, 1, 1, 1, 1 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 6 },
		{ 2, 2, 2, 3, 2, 2, 2, 2, 2, 2 }
	};
	
	
	/* Define how the tiles will behave  */
	
	// 0 = No tile
	// 1 = Indistructible platform
	// 2 = Destructible platform
	// 3 = Jump platform
	// 4 = Bomb
	// 5 = Deadly
	// 6 = Exit
	// 7 = Elevator
	// 9 = Switch
	int tilesPhysicsData[13][10] = {
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 9, 9, 0, 9, 0, 0, 0, 4 },
		{ 2, 2, 2, 2, 5, 1, 1, 5, 5, 2 },
		{ 0, 9, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 2, 2, 2, 2, 7, 2, 1, 0, 0, 0 },
		{ 0, 9, 0, 0, 0, 9, 1, 1, 1, 0 },
		{ 1, 1, 5, 5, 5, 5, 1, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 1, 0, 1, 1 },
		{ 2, 2, 2, 2, 2, 2, 1, 0, 0, 0 },
		{ 5, 5, 5, 5, 5, 5, 1, 1, 1, 1 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 6 },
		{ 2, 2, 2, 3, 2, 2, 2, 2, 2, 2 }
	};
	
	
	/* Define how the switch tiles will behave  */
	SwitchParameters* sParams = [self defineSwitches];
	
	
	// Create the tile objects
	return [self createTilesLayer:world physicsData:tilesPhysicsData drawingData:tilesDrawData switchesParams:sParams progressCallback:callback];
}


// Define how the switches in this level behave
- (SwitchParameters*) defineSwitches
{
	CLog();
	// Possible switch targets are:
	// - pfElevatorTile: enable or disable elevator movement
	// - pfDeadlyTile: changed to destructible tiles when switched
	// - pfIndestructibleTile: change them into jumping tiles
	// - pfDestructibleTile: blown up when switched
	
	// Switch parameters need to be defined in the same order as they appear in the definition (starting at the top row, reading from left to right)
	SwitchParameters* sParams = new SwitchParameters[6];
	
	// Switch at position x=2, y=2
	// Targets the elevator located at x=4, y=5
	sParams[0].state = SwitchOff;
	sParams[0].targetTilesCount = 1;
	sParams[0].targetTileIndexes = new int[sParams[0].targetTilesCount];
	sParams[0].targetTileIndexes[0] = CoordsToIndex(4, 5);
	
	// Switch at position x=3, y=2
	// Targets the deadly tile located at x=4, y=3
	sParams[1].state = SwitchOff;
	sParams[1].targetTilesCount = 1;
	sParams[1].targetTileIndexes = new int[sParams[1].targetTilesCount];
	sParams[1].targetTileIndexes[0] = CoordsToIndex(4, 3);
	
	// Switch at position x=5, y=2
	// Targets the indestructible tile located at x=6, y=3
	sParams[2].state = SwitchOff;
	sParams[2].targetTilesCount = 1;
	sParams[2].targetTileIndexes = new int[sParams[2].targetTilesCount];
	sParams[2].targetTileIndexes[0] = CoordsToIndex(6, 3);
	
	// Switch at position x=1, y=5
	// Targets all deadly tiles located at y=7 and ranging x=2 to x=5
	sParams[3].state = SwitchOff;
	sParams[3].targetTilesCount = 4;
	sParams[3].targetTileIndexes = new int[sParams[3].targetTilesCount];
	sParams[3].targetTileIndexes[0] = CoordsToIndex(2, 7);
	sParams[3].targetTileIndexes[1] = CoordsToIndex(3, 7);
	sParams[3].targetTileIndexes[2] = CoordsToIndex(4, 7);
	sParams[3].targetTileIndexes[3] = CoordsToIndex(5, 7);
	
	// Switch at position x=1, y=7
	// Targets all destructible tiles located at y=9 and ranging x=0 to x=5
	sParams[4].state = SwitchOff;
	sParams[4].targetTilesCount = 6;
	sParams[4].targetTileIndexes = new int[sParams[4].targetTilesCount];
	sParams[4].targetTileIndexes[0] = CoordsToIndex(0, 9);
	sParams[4].targetTileIndexes[1] = CoordsToIndex(1, 9);
	sParams[4].targetTileIndexes[2] = CoordsToIndex(2, 9);
	sParams[4].targetTileIndexes[3] = CoordsToIndex(3, 9);
	sParams[4].targetTileIndexes[4] = CoordsToIndex(4, 9);
	sParams[4].targetTileIndexes[5] = CoordsToIndex(5, 9);
	
	// Switch at position x=5, y=7
	// Targets all deadly tiles located at y=10 and ranging x=0 to x=5
	sParams[5].state = SwitchOff;
	sParams[5].targetTilesCount = 6;
	sParams[5].targetTileIndexes = new int[sParams[5].targetTilesCount];
	sParams[5].targetTileIndexes[0] = CoordsToIndex(0, 10);
	sParams[5].targetTileIndexes[1] = CoordsToIndex(1, 10);
	sParams[5].targetTileIndexes[2] = CoordsToIndex(2, 10);
	sParams[5].targetTileIndexes[3] = CoordsToIndex(3, 10);
	sParams[5].targetTileIndexes[4] = CoordsToIndex(4, 10);
	sParams[5].targetTileIndexes[5] = CoordsToIndex(5, 10);
	
	return sParams;
}


// Initialize the enemy sprites for this level
- (Sprite**) getEnemyData:(World*)world
{
	CLog();
	enemyCount = 7;
	Enemy** enemies = new Enemy*[enemyCount];
	
	for (int i=0; i<enemyCount; i++) {
		enemies[i] = [[Enemy alloc] init];
		enemies[i].offScreen = NO;
		enemies[i].world = world;
		enemies[i].state = EnemyMoving;
	}

	// Drop 6 enemies on row 9
	for (int i=0; i<6; i++) {
		enemies[i].y = 210;
		enemies[i].x = i * 32 + 15;
	}
	
	enemies[6].y = 330;
	enemies[6].x = 260;
	enemies[6].flipped = YES;
	
	return enemies;
}

@end
