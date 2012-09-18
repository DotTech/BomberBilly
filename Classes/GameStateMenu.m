//
//  GameStateMenu.m
//  BomberBilly
//
//  Created by Ruud van Falier van Falier on 4/4/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import "GameStateMenu.h"
#import	"GameStateMain.h"
#import	"GameStateTutorial.h"
#import	"GameStateLevelEditor.h"

@implementation GameStateMenu

- (GameStateMenu*) initWithFrame:(CGRect)frame andManager:(GameStateManager*)manager
{
	if ((self = [super initWithFrame:frame andManager:manager]))
	{
	}
	return self;
}


- (void) update:(float)gameTime
{
	if (touching)
	{
		// Run tutorial button
        // coords: 79, 107 - size: 172,26
		if ((touchPosition.x >= 79 && touchPosition.x <= 251) &&
			(SCREEN_HEIGHT - touchPosition.y >= 107 && SCREEN_HEIGHT - touchPosition.y <= 133))
		{
			[gameStateManager changeGameState:[GameStateTutorial class]];
			return;
		}
        
        // Run game button
        // coords: 95, 167 - size: 141,29
		if ((touchPosition.x >= 95 && touchPosition.x <= 236) &&
			(SCREEN_HEIGHT - touchPosition.y >= 167 && SCREEN_HEIGHT - touchPosition.y <= 196))
		{
			[gameStateManager changeGameState:[GameStateMain class]];
			return;
		}
        
        // Run tutorial button
        // coords: 81, 224 - size: 170,28
		if ((touchPosition.x >= 81 && touchPosition.x <= 251) &&
			(SCREEN_HEIGHT - touchPosition.y >= 224 && SCREEN_HEIGHT - touchPosition.y <= 252))
		{
			[gameStateManager changeGameState:[GameStateLevelEditor class]];
			return;
		}
	}
}


- (void) render
{
	// Clear anything left over from the last frame, and set background color.
	glClear(GL_COLOR_BUFFER_BIT);
	
	[[resManager getTexture:BACKGROUND_MENU] drawInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
	
	// Swap working buffer to active buffer
	[self swapBuffers];
}

@end
