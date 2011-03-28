//
//  Tile.h
//  BomberBilly
//
//  Created by Ruud van Falier on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animation.h"

typedef enum {
	pfNoTile = 0,
	pfIndestructibleTile = 1,
	pfDestructibleTile = 2,
	pfJumpTile = 3,
	pfBombTile = 4,
	pfDeadlyTile = 5,
	pfFinishTile = 6,
	pfElevatorTile = 7,
	pfElevatorHalfTile = 1007,	// When an elevator is moving, it can occupy 2 elements at once in the data array.
                                // In this case one of them (the one containing least part of the elevator) is pfElevatorHalfTile
	pfSwitchTile = 8
} PhysicsFlag;

typedef enum {
	dfDrawNothing = 0,
	dfIndestructibleBlock = 1,
	dfDestructibleBlock = 2,
	dfJumpBlock = 3,
	dfDynamite = 4,
	dfSpikes = 5,
	dfExitDoor = 6,
	dfElevator = 7,
	dfSwitch = 8,
    dfYellowRectangle = 9
} DrawingFlag;

typedef enum {
    bfNotBlinking = 0,
    bfBlinkingWithFading = 1,
    bfBlinkingNoFading = 2,
    bfFadingIn = 3,
    bfEndingWithFading = 4,
    bfEndingNoFading = 5
} BlinkingFlag;

@interface Tile : NSObject {
	int width;
	int height;
	int x;
	int y;
	float lastUpdateTime;
	PhysicsFlag physicsFlag;
	DrawingFlag drawingFlag;
	Animation* animation;
    
    float lastBlinkUpdateTime;    
    BlinkingFlag tileBlinkingFlag;
    DrawingFlag drawingFlagBeforeBlink;
}

@property (nonatomic, retain) Animation* animation;
@property int x;
@property int y;
@property int width;
@property int height;
@property PhysicsFlag physicsFlag;
@property DrawingFlag drawingFlag;

// Location of tile in the world tile data array
@property (readonly) int dataRow;
@property (readonly) int dataColumn;

- (Tile*) initTile:(DrawingFlag)dFlag physicsFlag:(PhysicsFlag)pFlag position:(CGPoint)pos;

- (void) draw;
- (void) drawAtPoint:(CGPoint)point;
- (void) update:(float)gameTime;

- (void) switchCallback:(BOOL)stateIsOn;
- (void) executeSwitchAction;

- (void) updateBlinking:(float)gameTime;
- (void) startTileBlinking:(BOOL)fadeOutAfterBlink;
- (void) stopTileBlinking;
- (void) stopTileBlinkingDone;
- (void) stopTileBlinkingDone:(BOOL)executeSwitchAction;

@end
