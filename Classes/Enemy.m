//
//  Enemy.m
//  BomberBilly
//
//  Created by ruud on 21/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "Tile.h"

@implementation Enemy

@synthesize world;
@synthesize state;


- (Enemy*)init
{
	CLog();
	[super initSprite:SPRITE_ENEMIES];
	[self.animation setSequence:ANIMATION_ENEMY_DEVILCAR];
	
	fallAcceleration = 1;
	
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
		if (![self standingOnPlatform] && (state != EnemyFalling && state != EnemyDying && state != EnemyDead)) {
			state = EnemyFalling;
		}
		
		[self move];
		[self fall];
		[self die];
		
		lastEnemyUpdateTime = gameTime * 1000;
	}
}


- (BOOL) standingOnPlatform
{
	CLogGL();
	
	// Find nearest platform underneath enemy
	Tile* platform = [self.world nearestPlatform:self inDirection:Down];
	if (platform != NULL)
	{
		// Check if found platform is one that we can stand on
		if (platform.physicsFlag != pfNoTile && platform.physicsFlag != pfElevatorTile && platform.physicsFlag != pfElevatorHalfTile 
			&& self.y == platform.y + TILE_HEIGHT) 
		{
			if (platform.physicsFlag == pfDeadlyTile) {
				self.state = EnemyDying;
			}
			return YES;
		}
	}
	return NO;
}


#pragma mark -
#pragma mark Enemy movement

// TODO: Something is off with the enemy tile detection...
// When moving left enemy.dataColumn returns an incorrect value (it considers the sprite to be in dataColumnMin while it's not)
- (void) move
{
	CLogGL();
	
	// Enemies simply move horizontally in any direction until they hit an object that blocks them
	// When blocked, they change direction and continue moving in the new direction
	
	if (self.state == EnemyMoving)
	{
		CLogGLU();
		
		int widthOffset = self.animation.sequenceWidth / 2;
		
		Tile* platform = [self.world nearestPlatform:self inDirection:(self.flipped ? Left : Right)];
		BOOL blockingPlatform = !(platform == NULL || platform.physicsFlag == pfNoTile || platform.physicsFlag == pfElevatorTile 
												   || platform.physicsFlag == pfElevatorHalfTile || platform.physicsFlag == pfBombTile);
		
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
		
		if (platform != NULL && platform.physicsFlag != pfNoTile && platform.physicsFlag != pfElevatorTile && 
			platform.physicsFlag != pfElevatorHalfTile && platform.physicsFlag != pfSwitchTile) 
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
@end
