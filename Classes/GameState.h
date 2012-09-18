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

@interface GameState : UIView {
	GameStateManager* gameStateManager;
	
	// Track touches
	CGPoint touchPosition;
	BOOL touching;
	
	// Used to keep track of FPS
	CFTimeInterval fpsLastSecondStart;
	int fpsFramesThisSecond;
	int fps;
}

- (id) initWithFrame:(CGRect)frame andManager:(GameStateManager*)manager;

- (void) render;
- (void) update:(float)gameTime;

- (void) handleTouch;
- (void) catchTouch:(NSSet*)touches;

- (void) updateFps;

@end
