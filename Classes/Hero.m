//
//  Hero.m
//  BomberBilly
//
//  Created by ruud on 21/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Hero.h"
#import "Tile.h"
#import "Enemy.h"
#import "Level.h"

@implementation Hero

@dynamic state;
@synthesize walkTowardsX;
@synthesize bombs;
@synthesize lifes;


- (Hero*)initWithWorld:(World*)w
{
	CLog();
	
	[super initSprite:SPRITE_HERO withWorld:w];
	[self.animation setSequence:ANIMATION_HERO_IDLE];
	
	jumpAcceleration = HERO_JUMP_ACCELERATION;
	jumpedHeight = 0;
	walkTowardsX = -1;
	bombs = 0;
	lifes = 0;
	self.state = HeroIdle;
	
	return self;
}


#pragma mark -
#pragma mark Hero update

- (void) update:(float)gameTime
{
	CLogGL();
	[super update:gameTime];
	
	if (gameTime * 1000 > lastHeroUpdateTime + HERO_UPDATE_INTERVAL)
	{
		CLogGLU();
        
		// If our hero is not on a platform or elevator it needs to start falling down
		if (![self standingOnPlatform:HeroDying] && 
			![self standingOnElevator] &&
			(self.state != HeroJumping && self.state != HeroFalling && self.state != HeroDying && self.state != HeroReachedFinish)) 
		{
			self.state = HeroFalling;
		}
		
		// Update hero according to its self.state
		if (self.state != HeroIdle) 
		{
			[self walk];
			[self jump];
			[self fall];
			[self dropBomb];
			[self die];
			[self cheer];
		}
		
		// Check for collision with enemies and start dying if we hit one
		if (self.state != HeroDead && self.state != HeroReachedFinish && [self checkEnemyCollision]) {
			self.state = HeroDying;
		}
		
		// Check for animation sequences that are still active while they are not supposed to be
		if ((self.state != HeroWalking && self.animation.currentSequence == ANIMATION_HERO_WALKING) || 
			(self.state != HeroFalling && self.animation.currentSequence == ANIMATION_HERO_JUMP_HANG)) {
			[self.animation setSequence:ANIMATION_HERO_IDLE];
		}
		
		lastHeroUpdateTime = gameTime * 1000;
	}
}


- (BOOL) checkEnemyCollision
{
	CLogGL();
	
	if (DEBUG_ENEMIES_DONT_KILL) {
		return NO;
	}
	
	for (int i=0; i<self.world.currentLevel.enemyCount; i++)
	{
		Enemy* e = (Enemy*)self.world.enemies[i];
		if (e.state != EnemyDying && e.state != EnemyDead)
		{
			int swOffset = [[self.animation get] getCurrentFrame:NO].size.width * self.animation.scale / 2;
			int ewOffset = [[e.animation get] getCurrentFrame:NO].size.width * e.animation.scale / 2;
			int eHeight = [[e.animation get] getCurrentFrame:NO].size.height * e.animation.scale;
			
			BOOL collision = (self.x + swOffset >= e.x - ewOffset && self.x - swOffset <= e.x + ewOffset) && (self.y <= e.y + eHeight && self.y >= e.y);
			if (collision) {
				return YES;
			}
		}
	}
	
	return NO;
}


#pragma mark -
#pragma mark Hero movement

- (void) walk
{
	CLogGL();
	
	if (self.state == HeroWalking)
	{
		CLogGLU();
		
		// Flip hero into the right direction
		int widthOffset = self.animation.sequenceWidth / 2;
		if (self.x + widthOffset < walkTowardsX) {
			self.flipped = NO;
		}
		else if (self.x - widthOffset > walkTowardsX) {
			self.flipped = YES;
		}
		
		// If hero is standing on a jumping platform, start jumping
		Tile* platform = [self.world nearestPlatform:self inDirection:Down];
		if (platform.physicsFlag == pfJumpTile) {
			self.state = HeroJumping;
			return;
		}
		
		// Start walking animation
		if (self.animation.currentSequence != ANIMATION_HERO_WALKING) {
			[self.animation setSequence:ANIMATION_HERO_WALKING];
		}
		
		// Handle the actual movement
		[self moveSideways];
	}
}


- (void) jump
{
	CLogGL();
	
	if (self.state == HeroJumping)
	{
		CLogGLU();
		
		if (self.animation.currentSequence != ANIMATION_HERO_JUMP_UP) {
			[self.animation setSequence:ANIMATION_HERO_JUMP_UP];
		}
		
		// Find nearest platform above hero
		Tile* platform = [self.world nearestPlatform:self inDirection:Up];
        
        // Define which tiles are blocking
        BOOL blockingPlatform = platform != NULL && (platform.physicsFlag == pfDeadlyTile || platform.physicsFlag == pfDestructibleTile || 
                                                     platform.physicsFlag == pfIndestructibleTile || platform.physicsFlag == pfJumpTile);

        BOOL hitCeiling = (blockingPlatform && self.y + jumpAcceleration >= platform.y);
		
		// Start falling down if ceiling is hit or maximum jump height was reached
		if (hitCeiling || jumpedHeight >= HERO_JUMP_MAXHEIGHT) {
			self.state = HeroFalling;
		}
		else
		{
			self.y += jumpAcceleration;
			jumpedHeight += jumpAcceleration;
			
			// Make us move up slower after each movement
			// This creates a sense of gravity
			if (jumpAcceleration > 1) {
				jumpAcceleration--;
			}
		}

		[self moveSideways];
	}
}


- (void) fall
{
	CLogGL();
	
	if (self.state == HeroFalling)
	{
		CLogGLU();
		
		// Find nearest platform underneath hero
		Tile* platform = [self.world nearestPlatform:self inDirection:Down];
		int platformY = SCREEN_HEIGHT - SCREEN_WORLD_HEIGHT - TILE_HEIGHT;
		
		if (platform != NULL && platform.physicsFlag != pfNoTile && platform.physicsFlag != pfElevatorHalfTile) {
			platformY = platform.y + TILE_HEIGHT;
		}
		
		// Fall down if we didnt hit the floor yet
		if (self.y - jumpAcceleration >= platformY) 
		{
			// Start air hang animation sequence
			if (self.animation.currentSequence != ANIMATION_HERO_JUMP_HANG && self.animation.currentSequence != ANIMATION_HERO_JUMP_TOUCHDOWN) {
				[self.animation setSequence:ANIMATION_HERO_JUMP_HANG];
				jumpAcceleration = 1;
			}
			self.y -= jumpAcceleration;
		}
		
		// Check if we are almost touching the floor, we do a little animation right before we hit it
		if (self.y - jumpAcceleration > platformY && self.y - jumpAcceleration < platformY + 10) 
		{
			if (self.animation.currentSequence != ANIMATION_HERO_JUMP_TOUCHDOWN) {
				[self.animation setSequence:ANIMATION_HERO_JUMP_TOUCHDOWN];
			}
		}
		else if (self.y - jumpAcceleration <= platformY)
		{
			if (platformY > SCREEN_HEIGHT - SCREEN_WORLD_HEIGHT)
			{
				if (platform.physicsFlag == pfBombTile) {
					// We hit a bomb, add it to inventory and remove it from the world
					[self takeBomb:platform];
				}
				else if (platform.physicsFlag == pfSwitchTile) {
					[(SwitchTile*)platform toggleSwitch];
					self.y -= jumpAcceleration;
				}
				else if (platform.physicsFlag == pfDeadlyTile && !DEBUG_DEADLYTILES_DONT_KILL) {
					// We hit a deadly tile, kill hero
					self.state = HeroDying;
					self.y = platformY;
				}
				else if (platform.physicsFlag == pfFinishTile) {
					self.state = HeroReachedFinish;
					self.y = platformY;
				}
				else 
				{
					// Player touched down, end the fall and reset parameters
					jumpedHeight = 0;
					jumpAcceleration = HERO_JUMP_ACCELERATION;
					self.y = platformY;
					
					self.state = HeroIdle;
					[self.animation setSequence:ANIMATION_HERO_IDLE];
				}
			}
			else 
			{
				// We fell off the screen
				self.y = SCREEN_HEIGHT - SCREEN_WORLD_HEIGHT;
				self.state = HeroDying;
			}
		}
		
		// Make us move down faster after each movement
		// This creates a sense of gravity
		if (jumpAcceleration < HERO_JUMP_ACCELERATION) {
			jumpAcceleration++;
		}
		
		[self moveSideways];
	}
}


- (void) cheer
{
	CLogGL();
	
	if (self.state == HeroReachedFinish)
	{
		CLogGLU();
		
		if (self.animation.currentSequence != ANIMATION_HERO_CHEERING) {
			[self.animation setSequence:ANIMATION_HERO_CHEERING];
		}
		
		if ([self.animation get].animationEnded) {
			self.state = HeroDoneCheering;
		}
	}
}

#pragma mark -
#pragma mark Base movement methods used by jump, walk and fall

// Moving sideways during walking, jumping or falling
- (void) moveSideways
{
	CLogGL();
	
	if (walkTowardsX > -1)
	{
		CLogGLU();
		int widthOffset = self.animation.sequenceWidth / 2;
		int addToX = 0;
		BOOL hittingPlatform = NO;
		Tile* platform = NULL;
		
		// Find nearest platform in the direction the sprite is moving in
		// Define wether or not it's close enough to hit
		if (!self.flipped && self.x + widthOffset + HERO_WALK_ACCELERATION < SCREEN_WIDTH) 
		{
			// Try to move hero to the right
			platform = [self.world nearestPlatform:self inDirection:Right];
			addToX = HERO_WALK_ACCELERATION;
			hittingPlatform = (platform != NULL && self.x + widthOffset + HERO_WALK_ACCELERATION > platform.x);
		}
		else if (self.flipped && self.x - widthOffset - HERO_WALK_ACCELERATION > 0) 
		{
			// Try to move hero to the left
			platform = [self.world nearestPlatform:self inDirection:Left];
			addToX = -HERO_WALK_ACCELERATION;
			hittingPlatform = (platform != NULL && self.x - widthOffset - HERO_WALK_ACCELERATION < platform.x + TILE_WIDTH);
		}
		else {
			// Screen boundaries reached, dont move any further
			return;
		}
		
		// See what kind of platform we're hitting and update hero's self.state
		// Maybe move this part to a seperate method as it's also used during "fall" in slightly different manner
		if (!hittingPlatform || platform.physicsFlag == pfNoTile) {
			// Not hitting anything
			self.x += addToX;
		}
		else if (platform.physicsFlag == pfSwitchTile) {
			// Hitting switch tile
			[(SwitchTile*)platform toggleSwitch];
			self.x += addToX;
		}
		else if (platform.physicsFlag == pfDeadlyTile && !DEBUG_DEADLYTILES_DONT_KILL) {
			// Hitting something deadly
			self.state = HeroDying;
		}			
		else if (platform.physicsFlag == pfBombTile) {
			// Hitting a bomb, add it to inventory
			[self takeBomb:platform];
			self.x += addToX;
		}
		else if (platform.physicsFlag == pfFinishTile) {
			// Reached the finish of the level
			self.state = HeroReachedFinish;
			self.x += addToX;
		}
	}
}


#pragma mark -
#pragma mark Hero actions

// Drops a bomb on current location
- (void) dropBomb
{
	CLogGL();
	
	if (self.state == HeroDroppingBomb && bombs > 0)
	{
		CLogGLU();
		
		// Find platforms in range that are destructible
		Tile** platforms = [self.world platformsToBomb:self];
		
		// Destroy found platforms
		if (platforms != NULL)
		{
			for (int i=0; i<=3; i++) 
			{
				if (platforms[i] != NULL)
				{
					platforms[i].physicsFlag = pfNoTile;
					[platforms[i].animation setSequence:ANIMATION_TILE_EXPLOSION];
				}
			}
			bombs--;
		}
		
		self.state = HeroIdle;
	}
}


// We hit a bomb tile, add the bomb to inventory and remove it from the world
- (void) takeBomb:(Tile*)tile
{
	CLog();
	
	tile.physicsFlag = pfNoTile;
	tile.drawingFlag = dfDrawNothing;
	bombs++;
}


// Kill the hero
- (void) die
{
	CLogGL();
	
	if (self.state == HeroDying)
	{
		CLogGLU();
		
		if (self.animation.currentSequence != ANIMATION_HERO_DYING) {
			[self.animation setSequence:ANIMATION_HERO_DYING];
		}
		
		if ([self.animation get].animationEnded) {
			self.state = HeroDead;
		}
	}
}


#pragma mark -
#pragma mark Properties

- (HeroState) getState
{
    return (HeroState)super.state;
}

- (void) setState:(HeroState)s
{
    super.state = s;
}

@end
