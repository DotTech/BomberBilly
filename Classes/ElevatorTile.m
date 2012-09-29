//
//  ElevatorTile.m
//  BomberBilly
//
//  Created by Ruud van Falier on 3/12/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import "ElevatorTile.h"
#import "ResourceManager.h"

@implementation ElevatorTile

@synthesize world;
@synthesize	halfElevator;
@synthesize state;
@synthesize initialY;
@synthesize waitingStartTime;


- (Tile*) initElevator:(DrawingFlag)dFlag physicsFlag:(PhysicsFlag)pFlag position:(CGPoint)pos setState:(ElevatorState)s worldPointer:(World*)w
{
	CLog();
	self = [super initTile:dFlag physicsFlag:pFlag position:pos];
	
	self.world = w;
	self.state = s;
	self.initialY = pos.y;
	self.halfElevator = NULL;
	
	return self;
}


- (void) dealloc
{
    [world release];
    [super dealloc];
}


- (void) resetAnimation
{
	CLogGL();
	
	if (self.drawingFlag != dfDrawNothing)
	{
		CLogGLU();
		Animation* anim = [[Animation alloc] initForTile:(int)self.drawingFlag];
		self.animation = anim;
		[anim release];
	}
}


- (void) update:(float)gameTime
{
	CLogGL();
	[super update:gameTime];
	
	if (self.physicsFlag == pfElevatorTile && self.state != ElevatorPaused)
	{
		if (gameTime * 1000 > lastElevatorUpdate + ELEVATOR_UPDATE_INTERVAL) 
		{
			CLogGLU();
            
			[self move:gameTime];
            lastElevatorUpdate = gameTime * 1000;
		}
	}
}


- (void) switchCallback:(BOOL)stateIsOn
{
	CLog();
    
    [self startTileBlinking:NO];
    [NSTimer scheduledTimerWithTimeInterval:SWITCH_TARGETMARKER_DURATION target:self selector:@selector(stopTileBlinking) userInfo:nil repeats:NO];
}


- (void) executeSwitchAction
{
	CLog();
    
    [super executeSwitchAction];
	self.state = ElevatorMovingUp;
}


- (void) move:(float)gameTime
{
	CLogGL();
	
	// Remember where the elevator is located in the tile array before we move it
	int oldIndex = CoordsToIndex(self.dataColumn, self.dataRow);
	int oldDataColumn = self.dataColumn;
	int oldDataRow = self.dataRow;
	
	// Update the elevator's drawing coordinates
	// If the coordinates didn't change, we don't need to continue executing this method
	if (![self updatePosition:gameTime]) {
		return;
	}
	
	CLogGLU();
	
	// Calculate the new index of the elevator in the tile data array
	// If it has changed we move the elevator to the new index
	int newIndex = CoordsToIndex(self.dataColumn, self.dataRow);
	if (newIndex != oldIndex)
	{
		// First reset the tile data for the old index to an empty tile
		Tile* oldTile = self.world.tilesLayer[oldIndex];
		oldTile.x = oldDataColumn * TILE_WIDTH;
		oldTile.y = SCREEN_HEIGHT - TILE_HEIGHT - (oldDataRow * TILE_HEIGHT);
		oldTile.physicsFlag = pfNoTile;
		oldTile.drawingFlag = dfDrawNothing;
		
		// Reset half elevator to empty tile
		ElevatorTile* hElevator = ((ElevatorTile*)self.world.tilesLayer[oldIndex]).halfElevator;
		if (hElevator != NULL) {
			hElevator.physicsFlag = pfNoTile;
			hElevator.drawingFlag = dfDrawNothing;
			hElevator.state = ElevatorNoState;
		}
		
		// Now make the tile element at the new index an ElevatorTile
		// If the new index does not contain an ElevatorTile instance yet, initialize one
		if (![self.world.tilesLayer[newIndex] isKindOfClass:[ElevatorTile class]])
		{
			CGPoint drawingPoint = IndexToCoords(newIndex);
			drawingPoint.x = drawingPoint.x * TILE_WIDTH;
			drawingPoint.y = SCREEN_HEIGHT - TILE_HEIGHT - drawingPoint.y * TILE_HEIGHT;
			
			[self.world.tilesLayer[newIndex] release];
			self.world.tilesLayer[newIndex] = [[ElevatorTile alloc] initElevator:dfElevator 
																	 physicsFlag:pfElevatorTile 
																		position:drawingPoint
																		setState:self.state
																	worldPointer:self.world];
			
			// Remember the Y coordinate where the elevator originally started at
			// The elevator can never move further down than its starting location 
			((ElevatorTile*)self.world.tilesLayer[newIndex]).initialY = self.initialY;
		}
		
		// Make tile at new index an elevator tile
		ElevatorTile* newTile = (ElevatorTile*)self.world.tilesLayer[newIndex];
		newTile.physicsFlag = pfElevatorTile;
		newTile.drawingFlag = dfElevator;
		newTile.state = self.state;
		newTile.waitingStartTime = self.waitingStartTime;
		[newTile resetAnimation];
		
		// If elevator is moving down the tile's drawing point must be moved to the top of the row
		if (self.state == ElevatorMovingDown) {
			newTile.y = self.y;
		}
	}
	
	// Handle the half of the elevator that occupies another data row in the tile array
	// (see method for more explaination)
	if (self.dataRowMin != self.dataRowMax) {
		[self moveHalfElevator];
	}
	else {
		// If the elevator is positioned exactly on one row, we dont need a HalfElevator object
		if (self.state == ElevatorMovingDown) {
			self.halfElevator.physicsFlag = pfNoTile;
			self.halfElevator.drawingFlag = dfDrawNothing;
		}
	}
}


// Update elevator drawing position
- (BOOL) updatePosition:(float)gameTime
{
	CLogGL();
	
	if (self.state == ElevatorMovingUp)
	{
		CLogGLU();
		
        // Maximum Y position for elevators
   		int maxY = SCREEN_HEIGHT - (TILE_HEIGHT * 2);
        
		// Check if we are not going to hit a tile above the elevator
        // We actually check one row above the row that is directly above the elevator, 
        // cause we want to keep one row of free space between the elevator and the ceiling
		int newDataRow = floor((double)(SCREEN_HEIGHT - (self.y + ELEVATOR_ACCELERATION + TILE_HEIGHT)) / TILE_HEIGHT);
		int indexToCheck = CoordsToIndex(self.dataColumn, newDataRow - 1);
        Tile* tileAtNewIndex = self.world.tilesLayer[indexToCheck];
        
        // Check if tile at new index is a blocking tile
        BOOL isBlockingTile = tileAtNewIndex != NULL && 
                              (tileAtNewIndex.physicsFlag == pfDeadlyTile || tileAtNewIndex.physicsFlag == pfDestructibleTile || 
                               tileAtNewIndex.physicsFlag == pfIndestructibleTile || tileAtNewIndex.physicsFlag == pfJumpTile ||
                               tileAtNewIndex.physicsFlag == pfElevatorTile);
        
		if (self.y + ELEVATOR_ACCELERATION < maxY && !isBlockingTile) {
			self.y += ELEVATOR_ACCELERATION;
		}
		else 
        {
			self.state = ElevatorWaitingForDown;
			if (self.y + ELEVATOR_ACCELERATION >= maxY) {
				self.y = maxY;
			}
			else {
                int moveToIndex = CoordsToIndex(self.dataColumn, newDataRow);
				self.y = self.world.tilesLayer[moveToIndex].y - TILE_HEIGHT;
			}
			self.waitingStartTime = gameTime;
		}
	}
	else if (self.state == ElevatorMovingDown)
	{
		CLogGLU();
		if (self.y - ELEVATOR_ACCELERATION >= self.initialY) {
			self.y -= ELEVATOR_ACCELERATION;
		}
		else {
			self.state = ElevatorWaitingForUp;
			self.y = self.initialY;
			self.waitingStartTime = gameTime;
		}
	}
	else if (self.state == ElevatorWaitingForUp || self.state == ElevatorWaitingForDown)
	{
		CLogGLU();
		// When elevator has reached top or bottom, it will wait some time before it starts moving again
		if (gameTime * 1000 > self.waitingStartTime * 1000 + ELEVATOR_WAITING_INTERVAL)
		{
			self.state = (self.state == ElevatorWaitingForUp) ? ElevatorMovingUp : ElevatorMovingDown;
			return NO;
		}
	}
	
	return YES;
}


// If elevator is overlapping 2 elements in the data array, one of those element's physicsFlag must be set to pfElevatorHalfTile.
// This is needed so game objects know there is part of an elevator occupying a certain space.
// Which one of the two elements becomes pfElevatorHalfTile is determined by the direction the elevator is moving in.
// When moving up, dataRowMin is set to pfElevatorHalfTile. When moving down, dataRowMax 
- (void) moveHalfElevator
{
	CLogGL();
	
	// Determine the array index for the half elevator tile
	int halfElevatorIndex = CoordsToIndex(self.dataColumn, self.dataRowMin);
	
	// If the halfElevator is not an instance of ElevatorTile we need to create one
	if (![self.world.tilesLayer[halfElevatorIndex] isKindOfClass:[ElevatorTile class]])
	{
		CGPoint drawingPoint = CGPointMake(self.world.tilesLayer[halfElevatorIndex].x, 
										   self.world.tilesLayer[halfElevatorIndex].y);

		[self.world.tilesLayer[halfElevatorIndex] release];
		self.world.tilesLayer[halfElevatorIndex] = (ElevatorTile*)[[ElevatorTile alloc] initElevator:dfDrawNothing 
																						 physicsFlag:pfElevatorHalfTile
																							position:drawingPoint
																							setState:ElevatorNoState
																						worldPointer:self.world];
	}
	
	self.halfElevator = (ElevatorTile*)self.world.tilesLayer[halfElevatorIndex];
	self.halfElevator.physicsFlag = pfElevatorHalfTile;
	self.halfElevator.drawingFlag = dfDrawNothing;
	self.halfElevator.state = ElevatorNoState;
	self.halfElevator.initialY = self.initialY;
	[self.halfElevator resetAnimation];
}


#pragma mark -
#pragma mark Properties

// Tiles already have a dataRow property and we use that to determine in which row to draw the tile and apply the physics.
// But when an elevator is on the move it can be in 2 rows at one time (eg. when it's moving up and entered row 1, but has not left row 2 entirely yet)
// So physics need to be applied in both rows in such cases, so that's where we use dataRowMin and dataRowMax for.
// Note that they are never used for updating or rendering the elevator!
- (int) dataRowMin
{
	return floor((double)(SCREEN_HEIGHT - self.y) / TILE_HEIGHT) - 1;
}

- (int) dataRowMax
{
	return ceil((double)(SCREEN_HEIGHT - self.y) / TILE_HEIGHT) - 1;
}

@end
