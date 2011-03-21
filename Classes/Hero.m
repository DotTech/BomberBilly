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

@synthesize world;
@synthesize state;
@synthesize walkTowardsX;
@synthesize bombs;
@synthesize lifes;


- (Hero*)init
{
	CLog();
	
	[super initSprite:SPRITE_HERO];
	[self.animation setSequence:ANIMATION_HERO_IDLE];
	
	jumpAcceleration = HERO_JUMP_ACCELERATION;
	jumpedHeight = 0;
	walkTowardsX = -1;
	bombs = 0;
	lifes = 0;
	state = Idle;
	
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
		if (![self standingOnPlatform] && 
			![self standingOnElevator] &&
			(state != Jumping && state != Falling && state != Dying && state != ReachedFinish)) 
		{
			state = Falling;
		}
		
		// Update hero according to its state
		if (state != Idle) 
		{
			[self walk];
			[self jump];
			[self fall];
			[self dropBomb];
			[self die];
			[self cheer];
		}
		
		// Check for collision with enemies and start dying if we hit one
		if (state != Dead && state != ReachedFinish && [self checkEnemyCollision]) {
			state = Dying;
		}
		
		// Check for animation sequences that are still active while they are not supposed to be
		if ((state != Walking && self.animation.currentSequence == ANIMATION_HERO_WALKING) || 
			(state != Falling && self.animation.currentSequence == ANIMATION_HERO_JUMP_HANG)) {
			[self.animation setSequence:ANIMATION_HERO_IDLE];
		}
		
		lastHeroUpdateTime = gameTime * 1000;
	}
}


#if !DEBUG_TILE_DETECTION
- (BOOL) standingOnPlatform
{
	CLogGL();
	
	// Find nearest platform underneath hero
	Tile* platform = [self.world nearestPlatform:self inDirection:Down];
	if (platform != NULL)
	{
		// Check if the platform underneath us is one we are allowed to stand on.
		// Note that pfElevatorTile is not allowed since that type is handled by the standingOnElevator method
		if (platform.physicsFlag != pfNoTile && platform.physicsFlag != pfElevatorTile && 
			platform.physicsFlag != pfElevatorHalfTile && platform.physicsFlag != pfBombTile && 
			platform.physicsFlag != pfSwitchTile) 
		{
			if (self.y == platform.y + TILE_HEIGHT)
			{
				if (platform.physicsFlag == pfDeadlyTile && !DEBUG_DEADLYTILES_DONT_KILL) {
					self.state = Dying;
				}
				return YES;
			}
		}
	}
	return NO;
}
#endif


#if DEBUG_TILE_DETECTION
// Special version of standingOnPlatform used for tile detection debugging
// Performs tile detection on the left, right and bottom side of the sprite 
// and changes the animation for the detected tiles to visualize which tiles are detected
- (BOOL) standingOnPlatform
{
	CLogGL();
	
	for (int i=0; i<10; i++) {
		int t = [self.world CoordsToIndex:CGPointMake(i, 1)];
		[self.world.tilesLayer[t].animation setSequence:ANIMATION_TILE_DEFAULT];
		
		t = [self.world CoordsToIndex:CGPointMake(i, 3)];
		[self.world.tilesLayer[t].animation setSequence:ANIMATION_TILE_DEFAULT];
	}
	
	// Detect tile underneath hero
	Tile* platform = [self.world nearestPlatform:self inDirection:Down];
	if (platform != NULL) {
		[platform.animation setSequence:ANIMATION_TILE_DEBUGDETECTION];
	}
	
	// Detect tile left and right from hero
	Tile* left = [self.world DEBUG_nearestPlatform:CGPointMake(self.x, self.y + TILE_HEIGHT) inDirection:Left isFlipped:self.flipped];
	if (left != NULL) {
		[left.animation setSequence:ANIMATION_TILE_DEBUGDETECTION];
	}
	
	Tile* right = [self.world DEBUG_nearestPlatform:CGPointMake(self.x, self.y + TILE_HEIGHT) inDirection:Right isFlipped:self.flipped];
	if (right != NULL) {
		[right.animation setSequence:ANIMATION_TILE_DEBUGDETECTION];
	}
	
	return YES;
}
#endif


- (BOOL) standingOnElevator
{
	CLogGL();
	
	// Checking for elevators is slightly different from checking for non-moving platforms
	// Before hero update is called, elevators have already been moved
	// So we have to check a little above and underneath the hero for elevators since it will not be standing exactly on it
	BOOL result = NO;
	
	// First we check for an elevator using hero's current data row (location in tile data array)
	Tile* platform = [self.world nearestPlatform:self inDirection:Down];
	if (platform != NULL && [platform isKindOfClass:[ElevatorTile class]] && platform.physicsFlag == pfElevatorTile) {
		result = [self moveWithElevator:platform];
	}
	
	// The elevator was not found using the hero's current data row.
	// Now we move hero up with the same acceleration as the elevator
	// Then we check if this causes the data row to change
	int initialDataRow = self.dataRow;
	int initialY = self.y;

	if (!result)
	{
		// Move hero up with same amount of steps as elevator
		self.y += ELEVATOR_ACCELERATION;
		if (self.dataRow != initialDataRow) 
		{
			// Check again for an elevator
			platform = [self.world nearestPlatform:self inDirection:Down];
			if (platform != NULL && [platform isKindOfClass:[ElevatorTile class]] && platform.physicsFlag == pfElevatorTile) {
				result = [self moveWithElevator:platform];
			}
		}
	}
	
	if (!result)
	{
		// Move hero down with same amount of steps as elevator
		self.y = initialY - ELEVATOR_ACCELERATION;
		if (self.dataRow != initialDataRow) 
		{
			// Check again for an elevator
			platform = [self.world nearestPlatform:self inDirection:Down];
			if (platform != NULL && [platform isKindOfClass:[ElevatorTile class]] && platform.physicsFlag == pfElevatorTile) {
				result = [self moveWithElevator:platform];
			}
		}
	}
	
	if (!result) {
		self.y = initialY;
	}
	
	return result;	
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
	
	if (state == Walking)
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
			self.state = Jumping;
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
	
	if (state == Jumping)
	{
		CLogGLU();
		
		if (self.animation.currentSequence != ANIMATION_HERO_JUMP_UP) {
			[self.animation setSequence:ANIMATION_HERO_JUMP_UP];
		}
		
		// Find nearest platform above hero
		Tile* platform = [self.world nearestPlatform:self inDirection:Up];
		BOOL hitCeiling = (platform != NULL && platform.physicsFlag != pfNoTile && platform.physicsFlag != pfSwitchTile 
						   && self.y + jumpAcceleration >= platform.y);
		
		// Start falling down if ceiling is hit or maximum jump height was reached
		if (hitCeiling || jumpedHeight >= HERO_JUMP_MAXHEIGHT) {
			state = Falling;
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
	
	if (state == Falling)
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
					self.state = Dying;
					self.y = platformY;
				}
				else if (platform.physicsFlag == pfFinishTile) {
					self.state = ReachedFinish;
					self.y = platformY;
				}
				else 
				{
					// Player touched down, end the fall and reset parameters
					jumpedHeight = 0;
					jumpAcceleration = HERO_JUMP_ACCELERATION;
					self.y = platformY;
					
					state = Idle;
					[self.animation setSequence:ANIMATION_HERO_IDLE];
				}
			}
			else 
			{
				// We fell off the screen
				self.y = SCREEN_HEIGHT - SCREEN_WORLD_HEIGHT;
				self.state = Dying;
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
	
	if (state == ReachedFinish)
	{
		CLogGLU();
		
		if (self.animation.currentSequence != ANIMATION_HERO_CHEERING) {
			[self.animation setSequence:ANIMATION_HERO_CHEERING];
		}
		
		if ([self.animation get].animationEnded) {
			state = DoneCheering;
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
		
		// See what kind of platform we're hitting and update hero's state
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
			self.state = Dying;
		}			
		else if (platform.physicsFlag == pfBombTile) {
			// Hitting a bomb, add it to inventory
			[self takeBomb:platform];
			self.x += addToX;
		}
		else if (platform.physicsFlag == pfFinishTile) {
			// Reached the finish of the level
			self.state = ReachedFinish;
			self.x += addToX;
		}
	}
}


// If hero is standing on an elevator it needs to be moved either up or down
// Returns bool indication wether hero is on elevator or not
- (BOOL) moveWithElevator:(Tile*)platform
{
	CLogGL();
	
	ElevatorTile* elevator = (ElevatorTile*)platform;
	if (elevator.state == ElevatorMovingUp && self.y + ELEVATOR_ACCELERATION == elevator.y + TILE_HEIGHT) {
		CLogGLU();
		self.y += ELEVATOR_ACCELERATION;
		return YES;
	}
	else if (elevator.state == ElevatorMovingDown && self.y - ELEVATOR_ACCELERATION == elevator.y + TILE_HEIGHT) {
		CLogGLU();
		self.y -= ELEVATOR_ACCELERATION;
		return YES;
	}
	else if (self.y == elevator.y + TILE_HEIGHT) {
		CLogGLU();
		return YES;
	}
	
	return NO;
}


#pragma mark -
#pragma mark Hero actions

// Drops a bomb on current location
- (void) dropBomb
{
	CLogGL();
	
	if (state == DroppingBomb && bombs > 0)
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
		
		state = Idle;
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
	
	if (state == Dying)
	{
		CLogGLU();
		
		if (self.animation.currentSequence != ANIMATION_HERO_DYING) {
			[self.animation setSequence:ANIMATION_HERO_DYING];
		}
		
		if ([self.animation get].animationEnded) {
			state = Dead;
		}
	}
}


@end
