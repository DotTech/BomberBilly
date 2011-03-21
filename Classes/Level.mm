//
//  Level.m
//  BomberBilly
//
//  Created by Ruud van Falier on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Level.h"

@implementation Level

@synthesize startBombs;
@synthesize enemyCount;
@synthesize heroSpawnPoint;
@synthesize worldTileWidth;
@synthesize worldTileHeight;


- (Level*) init
{
	CLog();
	[super init];

	worldTileWidth = (SCREEN_WIDTH / TILE_WIDTH);
	worldTileHeight =  (SCREEN_WORLD_HEIGHT / TILE_HEIGHT);
	worldSize = worldTileWidth * worldTileHeight;	
	
	return self;
}


// Creates an array with Tile objects based on the level definition
- (Tile**) createTilesLayer:(World*)world  physicsData:(int[SCREEN_WORLD_HEIGHT / TILE_HEIGHT][SCREEN_WIDTH / TILE_WIDTH])pData 
										   drawingData:(int[SCREEN_WORLD_HEIGHT / TILE_HEIGHT][SCREEN_WIDTH / TILE_WIDTH])dData
										switchesParams:(SwitchParameters*)sParams
									  progressCallback:(ProgressCallback)callback
{
	CLog();
	Tile** tilesLayer = new Tile*[worldSize];
	int switchCounter = 0;
	int progressCounter = 0;
	int totalIterations = worldTileHeight * worldTileWidth * 2;
	
	// Loop through level definition twice.
	// First we allocate all tiles that are not of the type pfSwitchTile.
	// During the second loop we allocate all the pfSwitchTile tiles.
	// This is necessary because Switches need a reference to a target tile, which otherwise may not exist yet.
	for (int loop=0; loop<2; loop++)
	{
		for (int y=0; y<worldTileHeight; y++) {
			for (int x=0; x<worldTileWidth; x++) 
			{
				int tileIndex = CoordsToIndex(x, y);
				
				// Retrieve tile definition
				int posX = x * TILE_WIDTH;
				int posY = SCREEN_HEIGHT - TILE_HEIGHT - y * TILE_HEIGHT;
				CGPoint drawPosition = CGPointMake(posX, posY);
				
				DrawingFlag dFlag = (DrawingFlag)dData[y][x];
				PhysicsFlag pFlag = (PhysicsFlag)pData[y][x];
				
				// Allocate tile instances
				// Switch tiles may only be allocated during the second loop!
				// All other types of tiles must be allocated during the first loop
				if (loop == 0 && pFlag == pfElevatorTile) {
					// Create common tile
					tilesLayer[tileIndex] = [[ElevatorTile alloc] initElevator:dFlag physicsFlag:pFlag position:drawPosition setState:ElevatorMovingUp worldPointer:world];
				}
				else if (loop == 1 && pFlag == pfSwitchTile) 
				{
					// Create switch tile
					SwitchParameters params = sParams[switchCounter];
					SwitchState s = params.state;
					
					// Create array with pointers to target tiles in tilesLayer
					Tile** targets = new Tile*[params.targetTilesCount];
					for (int t=0; t<params.targetTilesCount; t++) {
						targets[t] = tilesLayer[params.targetTileIndexes[t]];
					}
					
					tilesLayer[tileIndex] = [[SwitchTile alloc] initSwitch:targets targetsCount:params.targetTilesCount position:drawPosition setState:s];
					switchCounter++;
				}
				else if (loop == 0) {
					// Create elevator tile
					tilesLayer[tileIndex] = [[Tile alloc] initTile:dFlag physicsFlag:pFlag position:drawPosition];
				}
				
				// Invoke callback to inform caller about the progress
				progressCounter++;
				int percentage = ceil((double)progressCounter / ((double)totalIterations / 100));
				[self invokeProgressCallback:callback percentage:percentage];
			}
		}
	}
	return tilesLayer;
}


- (Tile**) getTilesData:(World*)world progressCallback:(ProgressCallback)callback
{
	CLog();
	return NULL;
}


- (Sprite**) getEnemyData:(World*)world
{
	CLog();
	enemyCount = 0;
	return NULL;
}


- (SwitchParameters*) defineSwitches
{
	CLog();
	return NULL;
}


- (void) invokeProgressCallback:(ProgressCallback)callback percentage:(int)p
{
	[callback.callbackObject performSelector:callback.callbackMethod withObject:[NSNumber numberWithInt:p]];
}


#pragma mark -
#pragma mark Properties

- (int) worldTileCount
{
	return self.worldTileWidth * self.worldTileHeight;
}


@end
