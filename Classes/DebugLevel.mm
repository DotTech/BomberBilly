//
//  DebugLevel.mm
//  BomberBilly
//
//  Created by Ruud van Falier on 3/14/11.
//  Copyright 2011 DotTech. All rights reserved.
//
// TODO: Write more documentation on this class so it can be used in future as example of how to create levels

#import "DebugLevel.h"

@implementation DebugLevel


- (DebugLevel*) init
{
	CLog();
	self = [super init];
	
	self.startBombs = 10;
	self.heroSpawnPoint = CGPointMake(15, 480);
	
	return self;
}


- (Tile**) getTilesData:(World*)world progressCallback:(Callback)callback
{
	CLog();
    
	/* Define what tile images to draw in the world */
	
    // DrawingFlag values
    // 0:dfDrawNothing, 1:dfIndestructibleBlock, 2:dfDestructibleBlock, 3:dfJumpBlock, 4:dfDynamite, 5:dfSpikes
    // 6:dfExitDoor, 7:dfElevator, 8:dfSwitch, 9:dfOneWayLeftToRight, 10:dfOneWayRightToLeft
	int drawData[13][10] = {
		{ 0, 0, 0, 0, 9, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 9, 0, 0, 0, 0, 0 },
		{ 1, 1, 3, 1, 1, 1, 1, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0,10, 0, 1, 1 },
		{ 0, 0, 0, 0, 0, 0,10, 0, 1, 0 },
		{ 0, 0, 0, 0, 0, 0,10, 0, 1, 0 },
		{ 0, 0, 0, 0, 0, 0,10, 0, 1, 0 },
		{ 0, 0, 0, 0, 0, 0,10, 0, 1, 0 },
		{ 2, 2, 2, 1, 1, 1, 1, 1, 1, 0 },
		{ 9, 9, 9, 0, 0, 0, 0, 0, 0, 0 },
		{ 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 2, 2, 2, 3, 2, 2, 2, 2, 2, 2 }
	};
	
	
	/* Define how the tiles will behave  */
	
    // PhysicFlag values
    // 0:pfNoTile, 1:pfIndestructibleTile, 2:pfDestructibleTile, 3:pfJumpTile, 4:pfBombTile, 5:pfDeadlyTile
    // 6:pfFinishTile, 7:pfElevatorTile, 8:pfSwitchTile, 9:pfOneWayLeftToRight, 10:pfOneWayRightToLeft
	int physicsData[13][10] = {
		{ 0, 0, 0, 0, 9, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 9, 0, 0, 0, 0, 0 },
		{ 1, 1, 3, 1, 1, 1, 1, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0,10, 0, 1, 1 },
		{ 0, 0, 0, 0, 0, 0,10, 0, 1, 0 },
		{ 0, 0, 0, 0, 0, 0,10, 0, 1, 0 },
		{ 0, 0, 0, 0, 0, 0,10, 0, 1, 0 },
		{ 0, 0, 0, 0, 0, 0,10, 0, 1, 0 },
		{ 2, 2, 2, 1, 1, 1, 1, 1, 1, 0 },
		{ 9, 9, 9, 0, 0, 0, 0, 0, 0, 0 },
		{ 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 2, 2, 2, 3, 2, 2, 2, 2, 2, 2 }
	};
	
	
	/* Define how the switch tiles will behave  */
	SwitchParameters* sParams = [self defineSwitches];
	
	
	// Create the tile objects
	return [self createTilesLayer:world physicsData:physicsData drawingData:drawData switchesParams:sParams progressCallback:callback];
}

/*
 - (Tile**) getTilesData:(World*)world progressCallback:(Callback)callback
 {
 CLog();
 
// DrawingFlag values
// 0:dfDrawNothing, 1:dfIndestructibleBlock, 2:dfDestructibleBlock, 3:dfJumpBlock, 4:dfDynamite, 5:dfSpikes
// 6:dfExitDoor, 7:dfElevator, 8:dfSwitch
int drawData[13][10] = {
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 0, 9, 8, 8,10, 8, 0, 0, 0, 4 },
    { 2, 2, 1, 2, 5, 1, 1, 5, 5, 2 },
    { 0, 8,10, 0, 0, 0, 0, 0, 0, 0 },
    { 2, 2, 2, 2, 7, 2, 1, 0, 0, 0 },
    { 0, 8, 0, 0, 0, 8, 1, 2, 2, 0 },
    { 1, 1, 5, 5, 5, 5, 1, 0, 0, 0 },
    { 0, 0, 0, 0, 0, 0, 1, 0, 1, 1 },
    { 2, 2, 2, 2, 2, 2, 1, 0, 0, 0 },
    { 5, 5, 5, 5, 5, 5, 1, 1, 1, 1 },
    { 0, 0, 0, 0, 0, 0, 0, 8, 0, 6 },
    { 2, 2, 2, 3, 2, 2, 2, 2, 2, 2 }
};


// PhysicFlag values
// 0:pfNoTile, 1:pfIndestructibleTile, 2:pfDestructibleTile, 3:pfJumpTile, 4:pfBombTile, 5:pfDeadlyTile
// 6:pfFinishTile, 7:pfElevatorTile, 8:pfSwitchTile
int physicsData[13][10] = {
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 0, 9, 8, 8,10, 8, 0, 0, 0, 4 },
    { 2, 2, 1, 2, 5, 1, 1, 5, 5, 2 },
    { 0, 8,10, 0, 0, 0, 0, 0, 0, 0 },
    { 2, 2, 2, 2, 7, 2, 1, 0, 0, 0 },
    { 0, 8, 0, 0, 0, 8, 1, 2, 2, 0 },
    { 1, 1, 5, 5, 5, 5, 1, 0, 0, 0 },
    { 0, 0, 0, 0, 0, 0, 1, 0, 1, 1 },
    { 2, 2, 2, 2, 2, 2, 1, 0, 0, 0 },
    { 5, 5, 5, 5, 5, 5, 1, 1, 1, 1 },
    { 0, 0, 0, 0, 0, 0, 0, 8, 0, 6 },
    { 2, 2, 2, 3, 2, 2, 2, 2, 2, 2 }
};


// Define how the switch tiles will behave
SwitchParameters* sParams = [self defineSwitches];


// Create the tile objects
return [self createTilesLayer:world physicsData:physicsData drawingData:drawData switchesParams:sParams progressCallback:callback];
}
*/

/*
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
	SwitchParameters* sParams = new SwitchParameters[7];
	
	// Switch at position x=3, y=2
	// Targets the deadly tile located at x=4, y=3
    int i = 0;
	sParams[i].state = SwitchOff;
	sParams[i].targetTilesCount = 1;
	sParams[i].targetTileIndexes = new int[sParams[i].targetTilesCount];
	sParams[i].targetTileIndexes[0] = CoordsToIndex(4, 3);
	
	// Switch at position x=2, y=2
	// Targets the elevator located at x=4, y=5
    i++;
	sParams[i].state = SwitchOff;
	sParams[i].targetTilesCount = 1;
	sParams[i].targetTileIndexes = new int[sParams[i].targetTilesCount];
	sParams[i].targetTileIndexes[0] = CoordsToIndex(4, 5);

	// Switch at position x=5, y=2
	// Targets the indestructible tile located at x=6, y=3
    i++;
	sParams[i].state = SwitchOff;
	sParams[i].targetTilesCount = 1;
	sParams[i].targetTileIndexes = new int[sParams[i].targetTilesCount];
	sParams[i].targetTileIndexes[0] = CoordsToIndex(6, 3);
	
	// Switch at position x=1, y=5
	// Targets all deadly tiles located at y=7 and ranging x=2 to x=5
    i++;
	sParams[i].state = SwitchOff;
	sParams[i].targetTilesCount = 4;
	sParams[i].targetTileIndexes = new int[sParams[i].targetTilesCount];
	sParams[i].targetTileIndexes[0] = CoordsToIndex(2, 7);
	sParams[i].targetTileIndexes[1] = CoordsToIndex(3, 7);
	sParams[i].targetTileIndexes[2] = CoordsToIndex(4, 7);
	sParams[i].targetTileIndexes[3] = CoordsToIndex(5, 7);
	
	// Switch at position x=1, y=7
	// Targets all destructible tiles located at y=9 and ranging x=0 to x=5
    i++;
	sParams[i].state = SwitchOff;
	sParams[i].targetTilesCount = 6;
	sParams[i].targetTileIndexes = new int[sParams[i].targetTilesCount];
	sParams[i].targetTileIndexes[0] = CoordsToIndex(0, 9);
	sParams[i].targetTileIndexes[1] = CoordsToIndex(1, 9);
	sParams[i].targetTileIndexes[2] = CoordsToIndex(2, 9);
	sParams[i].targetTileIndexes[3] = CoordsToIndex(3, 9);
	sParams[i].targetTileIndexes[4] = CoordsToIndex(4, 9);
	sParams[i].targetTileIndexes[5] = CoordsToIndex(5, 9);
	
	// Switch at position x=5, y=7
	// Targets all deadly tiles located at y=10 and ranging x=0 to x=5
    i++;
	sParams[i].state = SwitchOff;
	sParams[i].targetTilesCount = 6;
	sParams[i].targetTileIndexes = new int[sParams[i].targetTilesCount];
	sParams[i].targetTileIndexes[0] = CoordsToIndex(0, 10);
	sParams[i].targetTileIndexes[1] = CoordsToIndex(1, 10);
	sParams[i].targetTileIndexes[2] = CoordsToIndex(2, 10);
	sParams[i].targetTileIndexes[3] = CoordsToIndex(3, 10);
	sParams[i].targetTileIndexes[4] = CoordsToIndex(4, 10);
	sParams[i].targetTileIndexes[5] = CoordsToIndex(5, 10);
    
	// Switch at position x=7, y=11
	// Targets all deadly tiles located at y=6 and ranging x=7 to x=8
    i++;
	sParams[i].state = SwitchOff;
	sParams[i].targetTilesCount = 2;
	sParams[i].targetTileIndexes = new int[sParams[i].targetTilesCount];
	sParams[i].targetTileIndexes[0] = CoordsToIndex(7, 6);
	sParams[i].targetTileIndexes[1] = CoordsToIndex(8, 6);
	
	return sParams;
}
*/

/*
// Initialize the enemy sprites for this level
- (Entity**) getEnemyData:(World*)world
{
	CLog();
	self.enemyCount = 7;
	Enemy** enemies = new Enemy*[self.enemyCount];
	
	for (int i=0; i<self.enemyCount; i++) {
		enemies[i] = [[Enemy alloc] initWithWorld:world];
	}

	// Drop 6 enemies on row 9
	for (int i=0; i<6; i++) {
		enemies[i].y = 210;
		enemies[i].x = i * 32 + 15;
	}
	
	enemies[6].y = 330;
	enemies[6].x = 260;
    enemies[6].preventFallingOfBlocks = YES;
	enemies[6].flipped = YES;
	
	return enemies;
}
*/
@end
