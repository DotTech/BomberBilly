//
//  SwitchTile.m
//  BomberBilly
//
//  Created by Ruud van Falier on 3/19/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import "SwitchTile.h"
#import "ElevatorTile.h"

@implementation SwitchTile

@synthesize targets;
@synthesize state;
@synthesize hasBeenSwitched;
@synthesize targetsCount;


- (Tile*) initSwitch:(Tile**)targetTiles targetsCount:(int)tCount position:(CGPoint)pos setState:(SwitchState)s
{
	CLog();
	self = [super initTile:dfSwitch physicsFlag:pfSwitchTile position:pos];
	
	self.state = s;
	self.targets = targetTiles;
	self.hasBeenSwitched = NO;
	self.targetsCount = tCount;
	
	// Set correct animation sequence for current state
	[self updateSequence];
	
	// Pause any elevators that are a target for this switch
	[self pauseElevators];
	
	return self;
}


- (void) dealloc
{
    [tileMarker release];
    [super dealloc];
}


- (void) toggleSwitch
{
	CLog();
	
	// We are only allowed to toggle the switch once (at least for now)
	if (!hasBeenSwitched)
	{
		// Update switch state and animation
		self.hasBeenSwitched = YES;
		self.state = !self.state;
		[self updateSequence];
		
		// Execute the switch callback on target tiles
		for (int i=0; i<targetsCount; i++) {
			[self.targets[i] switchCallback:self.state];
		}
	}
}


// When an elevator is a target for this switch and the initial switch state if off,
// the elevator needs be set to pause
- (void) pauseElevators
{
	CLog();
	
	if (self.state == SwitchOff)
	{
		for (int i=0; i<targetsCount; i++) {
			if (self.targets[i].physicsFlag == pfElevatorTile) {
				((ElevatorTile*)self.targets[i]).state = ElevatorPaused;
			}
		}
	}
}


// Check if the active animation sequence matches the the switch state
- (void) updateSequence
{
	CLog();
	
	if (self.state == SwitchOn && self.animation.currentSequence != ANIMATION_SWITCH_ON) {
		[self.animation setSequence:ANIMATION_SWITCH_ON];
	}
	
	if (self.state == SwitchOff && self.animation.currentSequence != ANIMATION_SWITCH_OFF) {
		[self.animation setSequence:ANIMATION_SWITCH_OFF];
	}
}


@end
