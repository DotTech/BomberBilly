//
//  SwitchTile.h
//  BomberBilly
//
//  Created by Ruud van Falier on 3/19/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"
#import "Tile.h"
#import "World.h"

// Switches are tiles that can be set to an On or Off state.
// By doing so they change the state of other tiles (the target tiles)
// Possible targets are:
// - pfElevatorTile: enable or disable elevator movement 
//					 (TODO: Disabling elevators does not work because once they have moved the target pointer is invalid)
// - pfDeadlyTile: change them into destructible tiles
// - pfIndestructibleTile: change them into jumping tiles
// - pfDestructibleTile: blow them up by turning the switch on
// - ... more to come

typedef enum {
	SwitchOff = 0,
	SwitchOn = 1
} SwitchState;

@interface SwitchTile : Tile
{
@private
    Sprite* tileMarker;
}

@property (assign) Tile** targets;
@property SwitchState state;
@property BOOL hasBeenSwitched;
@property int targetsCount;

- (Tile*) initSwitch:(Tile**)targetTiles targetsCount:(int)tCount position:(CGPoint)pos setState:(SwitchState)s;
- (void) updateSequence;
- (void) pauseElevators;
- (void) toggleSwitch;

@end
