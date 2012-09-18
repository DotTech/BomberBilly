//
//  Enemy.m
//  BomberBilly
//
//  Created by Ruud van Falier on 21/02/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import "Enemy.h"
#import "Tile.h"
#import "Level.h"

// TODO: 
// - Something is off with the enemy tile detection...
//   When moving left enemy.dataColumn returns an incorrect value (it considers the sprite to be in dataColumnMin while it's not)
// - Enemies with preventFallingOfBlocks==YES get into infinite flip when tiles underneath them are exploded

@implementation Enemy

@dynamic state;
@synthesize preventFallingOfBlocks;


- (Enemy*) initWithWorld:(World*)w
{
	CLog();
    
	[super initSprite:SPRITE_ENEMIES withWorld:w];
	[self.animation setSequence:ANIMATION_ENEMY_DEVILCAR];
	
    offScreen = NO;
    fallAcceleration = 1;
    preventFallingOfBlocks = NO;
	self.state = EnemyFalling;
    
	return self;
}


#pragma mark -
#pragma mark Enemy update

- (void) update:(float)gameTime
{
	CLogGL();
	[super update:gameTime];

	if (gameTime * 1000 > lastEnemyUpdateTime + ENEMY_UPDATE_INTERVAL)
	{
		CLogGLU();
		
		// If enemy is not on a platform it needs to start falling down
		if (![self standingOnPlatform:EnemyDying] && 
            ![self standingOnElevator] &&
            (self.state != EnemyFalling && self.state != EnemyDying && self.state != EnemyDead)) 
        {
            if (self.state == EnemyMoving && preventFallingOfBlocks) {
                // Turn around when enemy is walking and the edge of a row of blocks is reached
                self.flipped = !self.flipped;
            }
            else {
                self.state = EnemyFalling;
            }
		}
		
		[self walk];
		[self fall];
		[self die];
		
		lastEnemyUpdateTime = gameTime * 1000;
	}
}


#pragma mark -
#pragma mark Enemy movement

- (void) walk
{
	CLogGL();
	
	// Enemies simply move horizontally in any direction until they hit an object that blocks them
	// When blocked, they change direction and continue moving in the new direction
	
	if (self.state == EnemyMoving)
	{
		CLogGLU();
		
		int widthOffset = self.animation.sequenceWidth / 2;
		Tile* platform = [self.world nearestPlatform:self inDirection:(self.flipped ? Left : Right)];
        
        // Define which tiles are blocking
        BOOL blockingPlatform = platform != NULL && (platform.physicsFlag == pfDeadlyTile || platform.physicsFlag == pfDestructibleTile || 
                                                     platform.physicsFlag == pfIndestructibleTile || platform.physicsFlag == pfJumpTile ||
                                                     platform.physicsFlag == pfElevatorTile || platform.physicsFlag == pfElevatorHalfTile);
        
		// Found a platform that can block our way. Check if it's in blocking range
		if (!self.flipped) {
			// Moving to the right
			int nextX = self.x + widthOffset + ENEMY_WALK_ACCELERATION;
			if ((!blockingPlatform || nextX < platform.x) && nextX < SCREEN_WIDTH) {
				self.x += ENEMY_WALK_ACCELERATION;
				return;
			}
		}
		else {
			// Moving to the left
			int nextX = self.x - widthOffset - ENEMY_WALK_ACCELERATION;
			if ((!blockingPlatform || nextX > platform.x + TILE_WIDTH) && nextX > 0) {
				self.x -= ENEMY_WALK_ACCELERATION;
				return;
			}
		}
		
		// If we are being blocked, turn around
		self.flipped = !self.flipped;
	}
}


- (void) fall
{
	CLogGL();
	
	if (self.state == EnemyFalling)
	{
		CLogGLU();
		
		// Find nearest platform underneath hero
		Tile* platform = [self.world nearestPlatform:self inDirection:Down];
		int platformY = SCREEN_HEIGHT - SCREEN_WORLD_HEIGHT - TILE_HEIGHT;
		
        // Define which tiles are blocking
        BOOL blockingPlatform = platform != NULL && (platform.physicsFlag == pfDeadlyTile || platform.physicsFlag == pfDestructibleTile || 
                                                     platform.physicsFlag == pfIndestructibleTile || platform.physicsFlag == pfJumpTile ||
                                                     platform.physicsFlag == pfElevatorTile);

        if (blockingPlatform)
		{
			platformY = platform.y + TILE_HEIGHT;
		}
		
		// Fall down if we didnt hit the floor yet
		if (self.y - fallAcceleration >= platformY) {
			self.y -= fallAcceleration;
		}
		else if (platformY > SCREEN_HEIGHT - SCREEN_WORLD_HEIGHT)
		{
			if (platform.physicsFlag == pfDeadlyTile) {
				// We hit a deadly tile, kill enemy
				self.state = EnemyDying;
				self.y = platformY;
			}
			else {
				// Enemy touched down, end the fall and reset parameters
				fallAcceleration = 1;
				self.y = platformY;					
				self.state = EnemyMoving;
			}
		}
		else 
		{
			// We fell off the screen
			self.y = SCREEN_HEIGHT - SCREEN_WORLD_HEIGHT;
			self.state = EnemyDying;
		}
		
		// Make us move down faster after each movement
		// This creates a sense of gravity
		if (fallAcceleration < HERO_JUMP_ACCELERATION) {
			fallAcceleration++;
		}
	}
}


- (void) die
{
	CLogGL();
	
	if (self.state == EnemyDying)
	{
		CLogGLU();
		
		if (self.animation.currentSequence != ANIMATION_ENEMY_DYING) {
			[self.animation setSequence:ANIMATION_ENEMY_DYING];
		}
		
		if ([self.animation get].animationEnded) {
			self.state = EnemyDead;
			offScreen = YES;
			self.x = -100;
			self.y = -100;
		}
	}
}


#pragma mark -
#pragma mark Properties

- (EnemyState) getState
{
    return (EnemyState)super.state;
}

- (void) setState:(EnemyState)s
{
    super.state = s;
}

@end
