//
//  LevelTwo.mm
//  BomberBilly
//
//  Created by Ruud van Falier on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelTwo.h"
#import "Enemy.h"


@implementation LevelTwo

- (LevelTwo*) init
{
	CLog();
	[super init];
	
	self.startBombs = 0;
	self.heroSpawnPoint = CGPointMake(305, 480);
	
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
	// 8 = Switch
	int tilesDrawData[13][10] = {
		{ 0, 5, 0, 2, 2, 6, 2, 4, 0, 0 },
		{ 0, 1, 2, 1, 1, 1, 5, 1, 0, 2 },
		{ 0, 1, 0, 0, 0, 0, 0, 0, 0, 4 },
		{ 0, 1, 2, 1, 0, 0, 0, 0, 7, 1 },
		{ 0, 4, 0, 1, 3, 1, 2, 5, 5, 1 },
		{ 0, 1, 7, 1, 0, 0, 0, 0, 0, 4 },
		{ 0, 1, 5, 1, 1, 1, 1, 1, 1, 2 },
		{ 0, 1, 0, 0, 2, 0, 0, 0, 0, 0 },
		{ 0, 1, 1, 1, 1, 2, 1, 0, 0, 4 },
		{ 0, 1, 0, 4, 2, 8, 1, 5, 3, 1 },
		{ 0, 1, 0, 1, 1, 1, 1, 0, 0, 4 },
		{ 0, 2, 4, 0, 0, 0, 4, 0, 0, 1 },
		{ 7, 1, 1, 1, 1, 1, 1, 3, 5, 1 }
	};
	
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
		{ 0, 5, 0, 2, 2, 6, 2, 4, 0, 0 },
		{ 0, 1, 2, 1, 1, 1, 5, 1, 0, 2 },
		{ 0, 1, 0, 0, 0, 0, 0, 0, 0, 4 },
		{ 0, 1, 2, 1, 0, 0, 0, 0, 7, 1 },
		{ 0, 4, 0, 1, 3, 1, 2, 5, 5, 1 },
		{ 0, 1, 7, 1, 0, 0, 0, 0, 0, 4 },
		{ 0, 1, 5, 1, 1, 1, 1, 1, 1, 2 },
		{ 0, 1, 0, 0, 2, 0, 0, 0, 0, 0 },
		{ 0, 1, 1, 1, 1, 2, 1, 0, 0, 4 },
		{ 0, 1, 0, 4, 2, 9, 1, 5, 3, 1 },
		{ 0, 1, 0, 1, 1, 1, 0, 0, 0, 4 },
		{ 0, 2, 4, 0, 0, 0, 4, 0, 0, 1 },
		{ 7, 1, 1, 1, 1, 1, 1, 3, 5, 1 }
	};
	
	// Setup switch
	SwitchParameters* sParams = [self defineSwitches];
	
	// Create the tile objects
	return [self createTilesLayer:world physicsData:tilesPhysicsData drawingData:tilesDrawData switchesParams:sParams progressCallback:callback];
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


- (Sprite**) getEnemyData:(World*)world
{
	CLog();
	enemyCount = 2;
	Enemy** enemies = new Enemy*[enemyCount];
	
	for (int i=0; i<enemyCount; i++) {
		enemies[i] = [[Enemy alloc] init];
		enemies[i].offScreen = NO;
		enemies[i].world = world;
		enemies[i].state = EnemyMoving;
	}
	
	enemies[0].y = 290;
	enemies[0].x = 195;
	
	enemies[1].y = 250;
	enemies[1].x = 110;
	
	return enemies;
}

@end
