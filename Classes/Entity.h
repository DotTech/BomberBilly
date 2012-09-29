//
//  Entity.h
//  BomberBilly
//
//  Created by Ruud van Falier on 3/27/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"
#import "World.h"

@interface Entity : Sprite {
}

@property (nonatomic, retain) World* world;
@property (nonatomic, retain) id state;

- (Sprite*) initSprite:(NSString*)spriteName withWorld:(World*)w;

- (void) walk;
- (void) fall;
- (BOOL) moveWithElevator:(Tile*)platform;

- (BOOL) standingOnPlatform:(int)entityDyingState;
- (BOOL) standingOnElevator;

@end
