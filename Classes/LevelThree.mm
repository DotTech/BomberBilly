//
//  LevelThree.m
//  BomberBilly
//
//  Created by Ruud van Falier on 3/27/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import "LevelThree.h"


@implementation LevelThree

- (LevelThree*) init
{
	CLog();
	[super init];
	
	self.startBombs = 0;
	self.heroSpawnPoint = CGPointMake(15, 96);
	
	return self;
}


- (Tile**) getTilesData:(World*)world progressCallback:(Callback)callback
{
	CLog();
    
    // DrawingFlag values
    // 0:dfDrawNothing, 1:dfIndestructibleBlock, 2:dfDestructibleBlock, 3:dfJumpBlock, 4:dfDynamite, 5:dfSpikes
    // 6:dfExitDoor, 7:dfElevator, 8:dfSwitch
	int drawData[13][10] = {
		{ 8, 4, 4, 2, 0, 2, 4, 4, 8, 0 },
        { 1, 1, 1, 2, 1, 1, 2, 1, 1, 1 },
        { 0, 8, 2, 0, 0, 8, 2, 0, 0, 2 },
        { 0, 1, 1, 7, 1, 1, 5, 1, 0, 0 },
        { 0, 0, 1, 0, 0, 0, 0, 0, 0, 4 },
        { 0, 0, 1, 4, 4, 1, 0, 1, 7, 1 },
        { 0, 0, 1, 2, 1, 0, 0, 0, 0, 0 },
        { 7, 0, 0, 0, 0, 0, 0, 0, 0, 8 },
        { 8, 0, 1, 1, 1, 3, 0, 0, 3, 2 },
        { 5, 0, 1, 0, 0, 4, 2, 0, 2, 2 },
        { 1, 0, 1, 2, 2, 2, 2, 0, 2, 5 },
        { 0, 0, 8, 2, 2, 2, 8, 4, 1, 6 },
        { 1, 7, 1, 5, 5, 5, 7, 1, 1, 1 }
	};
    
    // PhysicFlag values
    // 0:pfNoTile, 1:pfIndestructibleTile, 2:pfDestructibleTile, 3:pfJumpTile, 4:pfBombTile, 5:pfDeadlyTile
    // 6:pfFinishTile, 7:pfElevatorTile, 8:pfSwitchTile
	int physicsData[13][10] = {
		{ 8, 4, 4, 2, 0, 2, 4, 4, 8, 0 },
        { 1, 1, 1, 2, 1, 1, 2, 1, 1, 1 },
        { 0, 8, 2, 0, 0, 8, 2, 0, 0, 2 },
        { 0, 1, 1, 7, 1, 1, 5, 1, 0, 0 },
        { 0, 0, 1, 0, 0, 0, 0, 0, 0, 4 },
        { 0, 0, 1, 4, 4, 1, 0, 1, 7, 1 },
        { 0, 0, 1, 2, 1, 0, 0, 0, 0, 0 },
        { 7, 0, 0, 0, 0, 0, 0, 0, 0, 8 },
        { 8, 0, 1, 1, 1, 3, 0, 0, 3, 2 },
        { 5, 0, 1, 0, 0, 4, 2, 0, 2, 2 },
        { 1, 0, 1, 2, 2, 2, 2, 0, 2, 5 },
        { 0, 0, 8, 2, 2, 2, 8, 4, 1, 6 },
        { 1, 7, 1, 5, 5, 5, 7, 1, 1, 1 }
	};
	
	// Setup switch
	SwitchParameters* sParams = [self defineSwitches];
	
	// Create the tile objects
	return [self createTilesLayer:world physicsData:physicsData drawingData:drawData switchesParams:sParams progressCallback:callback];
}


- (SwitchParameters*) defineSwitches
{
	CLog();
	SwitchParameters* sParams = new SwitchParameters[7];
	
    // Switch at 1,0 targeting indestructible tile at 9,1
    int i = 0;
	sParams[i].state = SwitchOff;
	sParams[i].targetTilesCount = 1;
	sParams[i].targetTileIndexes = new int[sParams[i].targetTilesCount];
	sParams[i].targetTileIndexes[0] = CoordsToIndex(9, 1);
    
    // Switch at 9,0 targeting deadly tile at 0,9
    i++;
	sParams[i].state = SwitchOff;
	sParams[i].targetTilesCount = 1;
	sParams[i].targetTileIndexes = new int[sParams[i].targetTilesCount];
	sParams[i].targetTileIndexes[0] = CoordsToIndex(0, 9);
    
    // Switch at 1,2 targeting deadly tiles at 3-5,12
    i++;
	sParams[i].state = SwitchOff;
	sParams[i].targetTilesCount = 3;
	sParams[i].targetTileIndexes = new int[sParams[i].targetTilesCount];
	sParams[i].targetTileIndexes[0] = CoordsToIndex(3, 12);
    sParams[i].targetTileIndexes[1] = CoordsToIndex(4, 12);
    sParams[i].targetTileIndexes[2] = CoordsToIndex(5, 12);
    
    // Switch at 5,2 targeting elevator tile at 3,3
    i++;
	sParams[i].state = SwitchOff;
	sParams[i].targetTilesCount = 1;
	sParams[i].targetTileIndexes = new int[sParams[i].targetTilesCount];
	sParams[i].targetTileIndexes[0] = CoordsToIndex(3, 3);
    
    // Switch at 7,9 targeting destructible tiles at 3-5,10
    i++;
	sParams[i].state = SwitchOff;
	sParams[i].targetTilesCount = 3;
	sParams[i].targetTileIndexes = new int[sParams[i].targetTilesCount];
	sParams[i].targetTileIndexes[0] = CoordsToIndex(3, 10);
    sParams[i].targetTileIndexes[1] = CoordsToIndex(4, 10);
    sParams[i].targetTileIndexes[2] = CoordsToIndex(5, 10);
    
    // Switch at 0,8 targeting deadly tile at 9,10
    i++;
	sParams[i].state = SwitchOff;
	sParams[i].targetTilesCount = 1;
	sParams[i].targetTileIndexes = new int[sParams[i].targetTilesCount];
	sParams[i].targetTileIndexes[0] = CoordsToIndex(9, 10);
    
    // Switch at 2,11 targeting destructible tiles at 3-5,11
    i++;
	sParams[i].state = SwitchOff;
	sParams[i].targetTilesCount = 3;
	sParams[i].targetTileIndexes = new int[sParams[i].targetTilesCount];
	sParams[i].targetTileIndexes[0] = CoordsToIndex(3, 11);
    sParams[i].targetTileIndexes[1] = CoordsToIndex(4, 11);
    sParams[i].targetTileIndexes[2] = CoordsToIndex(5, 11);
    
    // Switch at 6,11 targeting destructible tiles at 3,0-1
    i++;
	sParams[i].state = SwitchOff;
	sParams[i].targetTilesCount = 2;
	sParams[i].targetTileIndexes = new int[sParams[i].targetTilesCount];
	sParams[i].targetTileIndexes[0] = CoordsToIndex(3, 0);
    sParams[i].targetTileIndexes[1] = CoordsToIndex(3, 1);
    
	return sParams;
}


- (Entity**) getEnemyData:(World*)world
{
	CLog();
	enemyCount = 3;
	Enemy** enemies = new Enemy*[enemyCount];
	
	for (int i=0; i<enemyCount; i++) {
		enemies[i] = [[Enemy alloc] initWithWorld:world];
	}
	
	enemies[0].x = 112;
	enemies[0].y = 176;
	
	enemies[1].x = 270;
	enemies[1].y = 480;

    enemies[2].x = 128;
	enemies[2].y = 400;

	return enemies;
}

@end
