//
//  LevelOne.m
//  BomberBilly
//
//  Created by Ruud van Falier on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelOne.h"
#import "Enemy.h"


@implementation LevelOne


- (LevelOne*) init
{
	CLog();
	[super init];
	
	self.startBombs = 0;
	self.heroSpawnPoint = CGPointMake(20, 480);
	
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
		{ 0, 0, 4, 0, 2, 4, 4, 0, 0, 0 },
		{ 1, 1, 2, 2, 1, 1, 1, 2, 1, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 4, 0, 5, 5, 0, 0, 0, 0, 0 },
		{ 0, 1, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 1, 1, 1, 3, 5, 1, 0 },
		{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 1, 1, 2, 1, 1, 1, 7 },
		{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
		{ 0, 4, 0, 1, 1, 2, 0, 0, 1, 1 },
		{ 0, 1, 1, 1, 0, 0, 2, 0, 0, 6 },
		{ 7, 1, 1, 1, 1, 3, 5, 1, 1, 1 }
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
		{ 0, 0, 4, 0, 2, 4, 4, 0, 0, 0 },
		{ 1, 1, 2, 2, 1, 1, 1, 2, 1, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 4, 0, 5, 5, 0, 0, 0, 0, 0 },
		{ 0, 1, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 1, 1, 1, 3, 5, 1, 0 },
		{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 1, 1, 2, 1, 1, 1, 7 },
		{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
		{ 0, 4, 0, 1, 1, 2, 0, 0, 1, 1 },
		{ 0, 1, 1, 1, 0, 0, 2, 0, 0, 6 },
		{ 7, 1, 1, 1, 1, 3, 5, 1, 1, 1 }
	};
	
	// Create the tile objects
	return [self createTilesLayer:world physicsData:tilesPhysicsData drawingData:tilesDrawData switchesParams:NULL progressCallback:callback];
}


- (Sprite**) getEnemyData:(World*)world
{
	CLog();
	enemyCount = 1;
	Enemy** enemies = new Enemy*[enemyCount];
	
	for (int i=0; i<enemyCount; i++) {
		enemies[i] = [[Enemy alloc] init];
		enemies[i].offScreen = NO;
		enemies[i].world = world;
		enemies[i].state = EnemyMoving;
	}
	
	enemies[0].y = 384;
	enemies[0].x = 290;
	
	return enemies;
}

@end
