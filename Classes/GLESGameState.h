//
//  GLESGameState.h
//  BomberBilly
//
//  Created by Ruud van Falier on 2/14/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameState.h"

@interface GLESGameState : GameState {
}

- (id) initWithFrame:(CGRect)frame andManager:(GameStateManager*)pManager;
- (void) swapBuffers;
- (BOOL) bindLayer;
+ (void) setup2D;

@end
