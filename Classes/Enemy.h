//
//  Enemy.h
//  BomberBilly
//
//  Created by ruud on 21/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"
#import "World.h"

typedef enum {
	EnemyMoving = 0,
	EnemyFalling = 1,
	EnemyDying = 2,
	EnemyDead = 3
} EnemyState;

@interface Enemy : Sprite {
	World* world;		// Reference to the gameworld is required for collision detection
	EnemyState state;
	float lastEnemyUpdateTime;
	int fallAcceleration;
}

@property (readwrite, assign) World* world;
@property EnemyState state;

- (BOOL) standingOnPlatform;
- (void) move;
- (void) fall;
- (void) die;

@end
