//
//  LevelTwo.mm
//  BomberBilly
//
//  Created by Ruud van Falier on 3/15/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import "LevelTwo.h"

@implementation LevelTwo


- (LevelTwo*) init
{
	CLog();
	[super init];
	
	self.startBombs = 0;
	self.heroSpawnPoint = CGPointMake(305, 480);
	
	return self;
}


- (Tile**) getTilesData:(World*)world progressCallback:(Callback)callback
{
	CLog();
    
    // DrawingFlag values
    // 0:dfDrawNothing, 1:dfIndestructibleBlock, 2:dfDestructibleBlock, 3:dfJumpBlock, 4:dfDynamite, 5:dfSpikes
    // 6:dfExitDoor, 7:dfElevator, 8:dfSwitch
	int drawData[13][10] = {
		{ 0, 5, 0, 2, 2, 6, 2, 4, 0, 0 },
		{ 0, 1, 2, 1, 1, 1, 5, 1, 0, 2 },
		{ 0, 1, 0, 0, 0, 0, 0, 0, 0, 4 },
		{ 0, 1, 2, 1, 0, 0, 0, 0, 7, 1 },
		{ 0, 4, 0, 1, 3, 1, 2, 1, 5, 1 },
		{ 0, 1, 7, 1, 0, 0, 0, 0, 0, 4 },
		{ 0, 1, 5, 1, 1, 1, 1, 1, 1, 2 },
		{ 0, 1, 0, 0, 2, 0, 0, 0, 0, 0 },
		{ 0, 1, 1, 1, 1, 2, 1, 0, 0, 4 },
		{ 0, 1, 0, 4, 2, 8, 1, 5, 3, 1 },
		{ 0, 1, 0, 1, 1, 1, 1, 0, 0, 4 },
		{ 0, 2, 4, 0, 0, 0, 4, 0, 0, 1 },
		{ 7, 1, 1, 1, 1, 1, 1, 3, 5, 1 }
	};
	
    // PhysicFlag values
    // 0:pfNoTile, 1:pfIndestructibleTile, 2:pfDestructibleTile, 3:pfJumpTile, 4:pfBombTile, 5:pfDeadlyTile
    // 6:pfFinishTile, 7:pfElevatorTile, 8:pfSwitchTile
	int physicsData[13][10] = {
		{ 0, 5, 0, 2, 2, 6, 2, 4, 0, 0 },
		{ 0, 1, 2, 1, 1, 1, 5, 1, 0, 2 },
		{ 0, 1, 0, 0, 0, 0, 0, 0, 0, 4 },
		{ 0, 1, 2, 1, 0, 0, 0, 0, 7, 1 },
		{ 0, 4, 0, 1, 3, 1, 2, 1, 5, 1 },
		{ 0, 1, 7, 1, 0, 0, 0, 0, 0, 4 },
		{ 0, 1, 5, 1, 1, 1, 1, 1, 1, 2 },
		{ 0, 1, 0, 0, 2, 0, 0, 0, 0, 0 },
		{ 0, 1, 1, 1, 1, 2, 1, 0, 0, 4 },
		{ 0, 1, 0, 4, 2, 8, 1, 5, 3, 1 },
		{ 0, 1, 0, 1, 1, 1, 0, 0, 0, 4 },
		{ 0, 2, 4, 0, 0, 0, 4, 0, 0, 1 },
		{ 7, 1, 1, 1, 1, 1, 1, 3, 5, 1 }
	};
	
	// Setup switch
	SwitchParameters* sParams = [self defineSwitches];
	
	// Create the tile objects
	return [self createTilesLayer:world physicsData:physicsData drawingData:drawData switchesParams:sParams progressCallback:callback];
}


- (SwitchParameters*) defineSwitches
{
	CLog();
	SwitchParameters* sParams = new SwitchParameters[1];
	
	sParams[0].state = SwitchOff;
	sParams[0].targetTilesCount = 1;
	sParams[0].targetTileIndexes = new int[sParams[0].targetTilesCount];
	sParams[0].targetTileIndexes[0] = CoordsToIndex(1, 0);
	
	return sParams;
}


- (Entity**) getEnemyData:(World*)world
{
	CLog();
	enemyCount = 2;
	Enemy** enemies = new Enemy*[enemyCount];
	
	for (int i=0; i<enemyCount; i++) {
		enemies[i] = [[Enemy alloc] initWithWorld:world];
	}
	
	enemies[0].y = 290;
	enemies[0].x = 195;
	
	enemies[1].y = 250;
	enemies[1].x = 110;
	
	return enemies;
}

@end
