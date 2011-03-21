//
//  World.m
//  BomberBilly
//
//  Created by Ruud van Falier on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "World.h"
#import "Enemy.h"
#import "Level.h"
#import "DebugLevel.h"
#import "DebugElevators.h"
#import "DebugTileDetection.h"
#import "LevelOne.h"
#import "LevelTwo.h"
#import "ResourceManager.h"

@implementation World

@synthesize tilesLayer;
@synthesize enemies;
@synthesize levels;


#pragma mark -
#pragma mark Initialization and deallocation

- (World*) init
{
	CLog();
	[super init];
	
	// Initialize all available levels
	// This does not create any of the level's game objects yet, 
	// which is done in [self loadLevel] when the level becomes active
	levels = new Level*[NUMBER_OF_LEVELS];
	levels[0] = [[DebugLevel alloc] init];
	levels[1] = [[LevelOne alloc] init];
	levels[2] = [[LevelTwo alloc] init];
	
	// Debug levels
	//levels[1] = [[DebugElevators alloc] init];
	
	return self;
}


- (void) dealloc
{
	CLog();
	releaseObjectArray(tilesLayer, self.currentLevel.worldTileCount);
	releaseObjectArray(enemies, self.currentLevel.enemyCount);
	releaseObjectArray(levels, NUMBER_OF_LEVELS);
	[super dealloc];
}


#pragma mark -
#pragma mark Initialization of world objects

- (void) loadLevel:(int)index progressCallback:(ProgressCallback)callback
{
	CLog();
	releaseObjectArray(tilesLayer, self.currentLevel.worldTileCount);
	releaseObjectArray(enemies, self.currentLevel.enemyCount);
	
	// Invoke callback and pass the loading progress percentage 
	[callback.callbackObject performSelector:callback.callbackMethod withObject:[NSNumber numberWithInt:0]];
	
	currentLevelIndex = index;
	tilesLayer = [self.currentLevel getTilesData:self progressCallback:callback];
	enemies = [self.currentLevel getEnemyData:self];
}


- (Level*) currentLevel
{
	CLogGL();
	
	#if DEBUG_TILE_DETECTION
	return [[DebugTileDetection alloc] init];
	#endif
	
	return self.levels[currentLevelIndex];
}


#pragma mark -
#pragma mark Tile detection methods

#if DEBUG_TILE_DETECTION
- (Tile*) DEBUG_nearestPlatform:(CGPoint)spriteLocation inDirection:(Direction)direction isFlipped:(BOOL)flipped
{
	CLogGL();
	
	Sprite* s = [[Sprite alloc] initSprite:SPRITE_HERO];
	[s.animation setSequence:ANIMATION_HERO_WALKING];
	s.offScreen = NO;
	s.x = spriteLocation.x;
	s.y = spriteLocation.y;
	s.flipped = flipped;

	Tile* t = [self nearestPlatform:s inDirection:direction];
	[s release];
	
	return t;
}
#endif


- (Tile*) nearestPlatform:(Sprite*)sprite inDirection:(Direction)direction
{
	CLogGL();
	
	// Return the tile located directly underneath the sprite
	int downY = sprite.dataRow + 1;
	if (direction == Down && downY < self.currentLevel.worldTileHeight)
	{
		int i = CoordsToIndex(sprite.dataColumn, downY);
		return tilesLayer[i];
	}
	
	// Return the tile located directly above the sprite
	int upY = sprite.dataRow - 1;
	if (direction == Up && upY >= 0)
	{
		int i = CoordsToIndex(sprite.dataColumn, upY);
		return tilesLayer[i];
	}
	
	// Return the tile located directly right from the sprite
	int rightX = sprite.dataColumn + 1;
	if (direction == Right && rightX < self.currentLevel.worldTileWidth)
	{
		int i = CoordsToIndex(rightX, sprite.dataRow);
		return tilesLayer[i];
	}
	
	// Return the tile located directly left from the sprite
	int leftX = sprite.dataColumn - 1;
	if (direction == Left && leftX >= 0)
	{
		int i = CoordsToIndex(leftX, sprite.dataRow);
		return tilesLayer[i];
	}
	
	return NULL;
}


// Scan for tiles that overlap the sprite on the specified row in the tile data array
// return the tile that is closest to the sprite.
// Does not return tiles with pfNoTile physicsflag
//
// OBSOLETE: Sprite.dataColumn now returns the column which covers most of sprite's surface
//			 Still kept the code in case we ever need to detect tiles on other rows
/* 
- (Tile*) nearestPlatformOnRow:(Sprite*)sprite dataRow:(int)row
{
	Tile* nearest = NULL;
	
	for (int x=sprite.dataColumnMin; x<=sprite.dataColumnMax; x++) 
	{
		// If we are facing left, we need to take the tile width into account
		int i = CoordsToIndex(x, row);
		int addTileWidth = TILE_WIDTH / 2;
		
		// Determine wether the current tile is closer by
		if (tilesLayer[i].physicsFlag != pfNoTile && tilesLayer[i].physicsFlag != pfElevatorHalfTile) {
			if (nearest == NULL || (abs(sprite.x - (tilesLayer[i].x + addTileWidth)) < abs(sprite.x - (nearest.x + addTileWidth)))) {
				nearest = tilesLayer[i];
			}
		}
	}
	
	return nearest;
}*/


// Find all platform tiles that are close enough to the sprite to be destroyed by a bomb
// Only returns platforms that are destructible
- (Tile**) platformsToBomb:(Sprite*)sprite
{
	CLog();
	
	int widthOffset = sprite.animation.sequenceWidth / 2;
	int p = 0;
	
	// Create empty array of tile pointers
	Tile** platforms = new Tile*[3];
	for (int i=0; i<=3; i++) {
		platforms[i] = NULL;
	}
	
	// Check for tiles on left and right side of the sprite
	// If we find one on both sides, check which one is closest
	// Proximity of the tile must be smaller than tile width
	Tile* left = [self nearestPlatform:sprite inDirection:Left];
	Tile* right = [self nearestPlatform:sprite inDirection:Right];
	
	// Found tiles on left or right side that are out of range
	if (left != NULL && sprite.x - widthOffset - (left.x + TILE_WIDTH) >= TILE_WIDTH / 2) {		
		left = NULL;
	}
	if (right != NULL && right.x - (sprite.x + widthOffset) >= TILE_WIDTH / 2) {
		right = NULL;
	}
	
	// Check for tiles directly underneath the sprite
	// There can be a maximum of three tiles in range
	for (int x=sprite.dataColumnMin; x<=sprite.dataColumnMax; x++) 
	{
		int i = CoordsToIndex(x, sprite.dataRow + 1);
		if (tilesLayer[i].physicsFlag == pfDestructibleTile) 
		{
			platforms[p] = tilesLayer[i];
			p++;
		}
	}
	
	if (left != NULL && left.physicsFlag == pfDestructibleTile)
	{
		platforms[p] = left;
		p++;
	}
	
	if (right != NULL && right.physicsFlag == pfDestructibleTile)
	{
		platforms[p] = right;
		p++;
	}
	
	return (p > 0) ? platforms : NULL;
}


#pragma mark -
#pragma mark Updating and rendering

- (void) update:(float)gameTime
{
	CLogGL();
	
	// Update world tiles
	for (int y=0; y<SCREEN_WORLD_HEIGHT/TILE_HEIGHT; y++) {
		for (int x=0; x<SCREEN_WIDTH/TILE_WIDTH; x++) 
		{
			int i = CoordsToIndex(x, y);
			[tilesLayer[i] update:gameTime];
		}
	}
	
	// Update enemies
	if (self.currentLevel.enemyCount > 0) {
		for (int i=0; i<self.currentLevel.enemyCount; i++) {
			[(Enemy*)self.enemies[i] update:gameTime];
		}
	}
}


- (void) draw
{
	CLogGL();
	
	// Draw world tiles
	for (int y=0; y<SCREEN_WORLD_HEIGHT/TILE_HEIGHT; y++) {
		for (int x=0; x<SCREEN_WIDTH/TILE_WIDTH; x++) 
		{
			int i = CoordsToIndex(x, y);
			if (tilesLayer[i].drawingFlag != dfDrawNothing) {
				[tilesLayer[i] draw];
			}
		}
	}
	
	// Draw enemies
	if (self.currentLevel.enemyCount > 0) {
		for (int i=0; i<self.currentLevel.enemyCount; i++) {
			[(Enemy*)self.enemies[i] draw];
		}
	}
	
	// Draw message if this is a debugging level
	[self drawDebugMessage];
}


- (void) drawDebugMessage
{
	CLogGL();
	
	NSString* levelClassName = NSStringFromClass([self.levels[currentLevelIndex] class]);
	NSRange match = [levelClassName rangeOfString:@"Debug"];	
	if (match.location != NSNotFound) {
		[resManager.fontMessage drawString:@"DEBUG LEVEL" atPoint:CGPointMake(75, 100)];
	}
}


@end
