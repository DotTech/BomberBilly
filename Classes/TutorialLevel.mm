//
//  TutorialLevel.m
//  BomberBilly
//
//  Created by Ruud van Falier on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TutorialLevel.h"

@implementation TutorialLevel


- (TutorialLevel*) init
{
	CLog();
	[super init];
	
	self.startBombs = 0;
	self.heroSpawnPoint = CGPointMake(20, 480);
	
	return self;
}


- (Tile**) getTilesData:(World*)world progressCallback:(Callback)callback
{
	CLog();

    // DrawingFlag values
    // 0:dfDrawNothing, 1:dfIndestructibleBlock, 2:dfDestructibleBlock, 3:dfJumpBlock, 4:dfDynamite, 5:dfSpikes
    // 6:dfExitDoor, 7:dfElevator, 8:dfSwitch
	int drawData[13][10] = {
		{ 0, 0, 0, 0, 0, 0, 4, 0, 0, 0 },
		{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 },
		{ 0, 0, 0, 8, 0, 0, 0, 0, 0, 0 },
		{ 1, 0, 1, 1, 1, 1, 1, 1, 1, 1 },
		{ 0, 0, 0, 8, 0, 0, 0, 0, 8, 0 },
		{ 1, 7, 1, 1, 1, 5, 5, 1, 1, 1 },
		{ 0, 0, 0, 0, 2, 4, 0, 0, 8, 4 },
		{ 2, 2, 2, 2, 2, 1, 1, 1, 1, 1 },
		{ 5, 5, 5, 5, 0, 0, 0, 0, 0, 4 },
		{ 8, 0, 4, 2, 0, 0, 0, 0, 1, 1 },
		{ 1, 1, 1, 2, 1, 1, 1, 3, 1, 1 },
		{ 6, 2, 0, 0, 0, 0, 0, 0, 0, 4 },
		{ 1, 1, 1, 1, 5, 5, 5, 5, 5, 1 }
	};
	
    // PhysicFlag values
    // 0:pfNoTile, 1:pfIndestructibleTile, 2:pfDestructibleTile, 3:pfJumpTile, 4:pfBombTile, 5:pfDeadlyTile
    // 6:pfFinishTile, 7:pfElevatorTile, 8:pfSwitchTile
	int physicsData[13][10] = {
		{ 0, 0, 0, 0, 0, 0, 4, 0, 0, 0 },
		{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 },
		{ 0, 0, 0, 8, 0, 0, 0, 0, 0, 0 },
		{ 1, 0, 1, 1, 1, 1, 1, 1, 1, 1 },
		{ 0, 0, 0, 8, 0, 0, 0, 0, 8, 0 },
		{ 1, 7, 1, 1, 1, 5, 5, 1, 1, 1 },
		{ 0, 0, 0, 0, 2, 4, 0, 0, 8, 4 },
		{ 2, 2, 2, 2, 2, 1, 1, 1, 1, 1 },
		{ 5, 5, 5, 5, 0, 0, 0, 0, 0, 4 },
		{ 8, 0, 4, 2, 0, 0, 0, 0, 1, 1 },
		{ 1, 1, 1, 2, 1, 1, 1, 3, 1, 1 },
		{ 6, 2, 0, 0, 0, 0, 0, 0, 0, 4 },
		{ 1, 1, 1, 1, 5, 5, 5, 5, 5, 1 }
	};
	
	/* Define how the switch tiles will behave  */
	SwitchParameters* sParams = [self defineSwitches];
	
	// Create the tile objects
	return [self createTilesLayer:world physicsData:physicsData drawingData:drawData switchesParams:sParams progressCallback:callback];
}


// Define how the switches in this level behave
- (SwitchParameters*) defineSwitches
{
	CLog();
	
	// Switch parameters need to be defined in the same order as they appear in the definition (starting at the top row, reading from left to right)
	SwitchParameters* sParams = new SwitchParameters[5];
	
	// Switch at position x=3, y=2
	// Targets the elevator located at x=1, y=5
	sParams[0].state = SwitchOff;
	sParams[0].targetTilesCount = 1;
	sParams[0].targetTileIndexes = new int[sParams[0].targetTilesCount];
	sParams[0].targetTileIndexes[0] = CoordsToIndex(1, 5);
	
	// Switch at position x=3, y=4
	// Targets the deadly tiles located at x=5-6, y=5
	sParams[1].state = SwitchOff;
	sParams[1].targetTilesCount = 2;
	sParams[1].targetTileIndexes = new int[sParams[1].targetTilesCount];
	sParams[1].targetTileIndexes[0] = CoordsToIndex(5, 5);
	sParams[1].targetTileIndexes[1] = CoordsToIndex(6, 5);
	
	// Switch at position x=8, y=4
	// Targets the destructible tiles located at x=5-6, y=5
	sParams[2].state = SwitchOff;
	sParams[2].targetTilesCount = 2;
	sParams[2].targetTileIndexes = new int[sParams[2].targetTilesCount];
	sParams[2].targetTileIndexes[0] = CoordsToIndex(5, 5);
	sParams[2].targetTileIndexes[1] = CoordsToIndex(6, 5);
	
	// Switch at position x=8, y=6
	// Targets all destructible tiles located at x=0-3, y=7
	sParams[3].state = SwitchOff;
	sParams[3].targetTilesCount = 4;
	sParams[3].targetTileIndexes = new int[sParams[3].targetTilesCount];
	sParams[3].targetTileIndexes[0] = CoordsToIndex(0, 7);
    sParams[3].targetTileIndexes[1] = CoordsToIndex(1, 7);
    sParams[3].targetTileIndexes[2] = CoordsToIndex(2, 7);
    sParams[3].targetTileIndexes[3] = CoordsToIndex(3, 7);
	
	// Switch at position x=0, y=9
	// Targets all deadly tiles located at x=4-8, y=12
	sParams[4].state = SwitchOff;
	sParams[4].targetTilesCount = 5;
	sParams[4].targetTileIndexes = new int[sParams[4].targetTilesCount];
	sParams[4].targetTileIndexes[0] = CoordsToIndex(4, 12);
	sParams[4].targetTileIndexes[1] = CoordsToIndex(5, 12);
	sParams[4].targetTileIndexes[2] = CoordsToIndex(6, 12);
	sParams[4].targetTileIndexes[3] = CoordsToIndex(7, 12);
	sParams[4].targetTileIndexes[4] = CoordsToIndex(8, 12);
	
	return sParams;
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
	
	enemies[0].x = 48;
	enemies[0].y = 260;
	enemies[0].flipped = YES;

	return enemies;
}

@end
