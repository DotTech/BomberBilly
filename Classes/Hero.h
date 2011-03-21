//
//  Hero.h
//  BomberBilly
//
//  Created by ruud on 21/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"
#import "World.h"

typedef enum {
	Idle = 0,
	Falling = 1,
	Jumping = 2,
	Walking = 3,
	DroppingBomb = 4,
	Dying = 5,
	Dead = 6,
	ReachedFinish = 7,
	DoneCheering = 8
} HeroState;

@interface Hero : Sprite {
	World* world;		// Reference to the gameworld is required for collision detection
	HeroState state;	// Tells us what our hero is doing
	
	float lastHeroUpdateTime;
	int jumpAcceleration;
	int jumpedHeight;
	int walkTowardsX;
	int bombs;
	int lifes;
}

@property (readwrite, assign) World* world;
@property HeroState state;
@property int walkTowardsX;
@property int bombs;
@property int lifes;

- (BOOL) standingOnPlatform;
- (BOOL) standingOnElevator;
- (BOOL) checkEnemyCollision;
- (void) jump;
- (void) walk;
- (void) fall;
- (void) dropBomb;
- (void) die;
- (void) cheer;
- (void) moveSideways;
- (BOOL) moveWithElevator:(Tile*)platform;
- (void) takeBomb:(Tile*)tile;

@end
