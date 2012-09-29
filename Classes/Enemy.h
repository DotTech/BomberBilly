//
//  Enemy.h
//  BomberBilly
//
//  Created by Ruud van Falier on 21/02/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

typedef enum {
	EnemyMoving = 0,
	EnemyFalling = 1,
	EnemyDying = 2,
	EnemyDead = 3
} EnemyState;

@interface Enemy : Entity
{
@private
    float lastEnemyUpdateTime;
    int fallAcceleration;
}

@property (nonatomic) EnemyState state;
@property BOOL preventFallingOfBlocks;  // Set to true if enemy must turn around when the edge of a block is reached
                                        // Otherwise it will just continue walking and fall off

- (Enemy*) initWithWorld:(World*)w;
- (void) die;

@end
