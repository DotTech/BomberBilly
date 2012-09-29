//
//  GameState.h
//  BomberBilly
//
//  Created by Ruud van Falier on 19/01/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import "GameStateManager.h"

@interface GameState : UIView
{
@private
    CGPoint touchPosition;
    CFTimeInterval fpsLastSecondStart;
    int fpsFramesThisSecond;
}

@property (nonatomic, retain) GameStateManager* gameStateManager;
@property BOOL touching;
@property (assign) CGPoint touchPosition;
@property int fps;

- (id) initWithFrame:(CGRect)frame andManager:(GameStateManager*)manager;

- (void) render;
- (void) update:(float)gameTime;

- (void) handleTouch;
- (void) catchTouch:(NSSet*)touches;

- (void) updateFps;

@end
