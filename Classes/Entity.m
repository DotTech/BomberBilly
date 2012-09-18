//
//  Entity.m
//  BomberBilly
//
//  Created by Ruud van Falier van Falier on 3/27/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import "Entity.h"
#import "Level.h"

@implementation Entity

@synthesize world;
@synthesize state;


- (Sprite*) initSprite:(NSString*)spriteName withWorld:(World*)w
{
	CLog();
    
	[super initSprite:spriteName];
    self.world = w;
	
	return self;
}


- (void) dealloc
{
    [world release];
    [super dealloc];
}


#pragma mark -
#pragma mark Movement methods that must be implemented for all entities

- (void) walk
{
}


- (void) fall
{
}


// If entity is standing on an elevator it needs to be moved either up or down
// Returns bool indication wether entity is on elevator or not
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
#pragma mark Handling of collision between entity and tiles

#if !DEBUG_TILE_DETECTION
// Detect if the entity is standing on a tile that is blocking (a platform)
// When entity is standing on a deadly tile, entity state will be set to entityDyingState
- (BOOL) standingOnPlatform:(int)entityDyingState
{
	CLogGL();
	
	// Find nearest platform underneath hero
	Tile* platform = [self.world nearestPlatform:self inDirection:Down];
    
    // Define which tiles are blocking and allows hero to stand on them
    // Note that pfElevatorTile is not blocking for this method since that type is handled by the standingOnElevator method
    BOOL blockingPlatform = platform != NULL && (platform.physicsFlag == pfDeadlyTile || platform.physicsFlag == pfDestructibleTile || 
                                                 platform.physicsFlag == pfIndestructibleTile || platform.physicsFlag == pfJumpTile);
    
	if (blockingPlatform && self.y == platform.y + TILE_HEIGHT)
	{
        if (platform.physicsFlag == pfDeadlyTile && !DEBUG_DEADLYTILES_DONT_KILL) {
            self.state = entityDyingState;
        }
        return YES;
	}
    
	return NO;
}
#endif


#if DEBUG_TILE_DETECTION
// Special version of standingOnPlatform used for tile detection debugging
// Performs tile detection on the left, right and bottom side of the sprite 
// and changes the animation for the detected tiles to visualize which tiles are detected
- (BOOL) standingOnPlatform:(int)entityDyingState
{
    CLogGL();

    if (self.offScreen) {
        return YES;
    }
    
    for (int i=0; i<10; i++) 
    {
        int t = CoordsToIndex(i, 1);
        [self.world.tilesLayer[t].animation setSequence:ANIMATION_TILE_DEFAULT];

        t = CoordsToIndex(i, 3);
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

@end
