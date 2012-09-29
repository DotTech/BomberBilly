//
//  Hero.h
//  BomberBilly
//
//  Created by Ruud van Falier on 21/02/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

typedef enum {
	HeroIdle = 0,
	HeroFalling = 1,
	HeroJumping = 2,
	HeroWalking = 3,
	HeroDroppingBomb = 4,
	HeroDying = 5,
	HeroDead = 6,
	HeroReachedFinish = 7,
	HeroDoneCheering = 8
} HeroState;

@interface Hero : Entity
{
@private
    float lastHeroUpdateTime;
    int jumpAcceleration;
    int jumpedHeight;
}

@property (nonatomic) HeroState state;
@property int walkTowardsX;
@property int bombs;
@property int lifes;

- (Hero*)initWithWorld:(World*)w;
- (void) jump;
- (void) dropBomb;
- (void) die;
- (void) cheer;
- (void) moveSideways;
- (BOOL) checkEnemyCollision;
- (void) takeBomb:(Tile*)tile;

@end
