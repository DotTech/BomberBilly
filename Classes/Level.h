//
//  Level.h
//  BomberBilly
//
//  Created by Ruud van Falier on 3/14/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"
#import "ElevatorTile.h"
#import "SwitchTile.h"
#import "Entity.h"
#import "Enemy.h"

typedef struct {
    SwitchState state;
    int* targetTileIndexes;	// Array with indexes of target tiles in tilesLayer array
	int targetTilesCount;	// Number of elements in targetTileIndexes array
} SwitchParameters;

@interface Level : NSObject
{
@private
    CGPoint heroSpawnPoint;
    int worldSize;
}

@property int startBombs;
@property int enemyCount;
@property CGPoint heroSpawnPoint;
@property int worldTileWidth;
@property int worldTileHeight;
@property (readonly) int worldTileCount;
@property (retain) NSString* backgroundImage;

- (Tile**) getTilesData:(World*)world progressCallback:(Callback)callback;
- (SwitchParameters*) defineSwitches;
- (Entity**) getEnemyData:(World*)world;
- (void) invokeProgressCallback:(Callback)callback percentage:(int)p;
- (Tile**) createTilesLayer:(World*)world 
				physicsData:(int[SCREEN_WORLD_HEIGHT / TILE_HEIGHT][SCREEN_WIDTH / TILE_WIDTH])pData 
				drawingData:(int[SCREEN_WORLD_HEIGHT / TILE_HEIGHT][SCREEN_WIDTH / TILE_WIDTH])dData
			 switchesParams:(SwitchParameters*)sParams
		   progressCallback:(Callback)callback;

@end
