//
//  ElevatorTile.h
//  BomberBilly
//
//  Created by Ruud van Falier on 3/12/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"
#import "World.h"

typedef enum {
	ElevatorMovingUp = 0,
	ElevatorMovingDown = 1,
	ElevatorWaitingForUp = 2,
	ElevatorWaitingForDown = 3,
	ElevatorNoState = 4,
	ElevatorPaused = 5
} ElevatorState;

@interface ElevatorTile : Tile
{
@private
    float lastElevatorUpdate;
}

@property (nonatomic, retain) World* world;
@property (assign) ElevatorTile* halfElevator;   // No retain since it's a reference to an element from the world.tilesLayer pointer array
@property ElevatorState state;
@property int initialY;
@property float waitingStartTime;
@property (readonly) int dataRowMin;
@property (readonly) int dataRowMax;

- (Tile*) initElevator:(DrawingFlag)dFlag physicsFlag:(PhysicsFlag)pFlag position:(CGPoint)pos setState:(ElevatorState)s worldPointer:(World*)w;
- (void) move:(float)gameTime;
- (BOOL) updatePosition:(float)gameTime;
- (void) moveHalfElevator;
- (void) resetAnimation;

@end
