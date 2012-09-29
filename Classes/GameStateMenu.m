//
//  GameStateMenu.m
//  BomberBilly
//
//  Created by Ruud van Falier on 4/4/11.
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
	if (self.touching)
	{
		// Run tutorial button
        // coords: 79, 107 - size: 172,26
		if ((self.touchPosition.x >= 79 && self.touchPosition.x <= 251) &&
			(SCREEN_HEIGHT - self.touchPosition.y >= 107 && SCREEN_HEIGHT - self.touchPosition.y <= 133))
		{
			[self.gameStateManager changeGameState:[GameStateTutorial class]];
			return;
		}
        
        // Run game button
        // coords: 95, 167 - size: 141,29
		if ((self.touchPosition.x >= 95 && self.touchPosition.x <= 236) &&
			(SCREEN_HEIGHT - self.touchPosition.y >= 167 && SCREEN_HEIGHT - self.touchPosition.y <= 196))
		{
			[self.gameStateManager changeGameState:[GameStateMain class]];
			return;
		}
        
        // Run tutorial button
        // coords: 81, 224 - size: 170,28
		/*if ((self.touchPosition.x >= 81 && self.touchPosition.x <= 251) &&
			(SCREEN_HEIGHT - self.touchPosition.y >= 224 && SCREEN_HEIGHT - self.touchPosition.y <= 252))
		{
			[self.gameStateManager changeGameState:[GameStateLevelEditor class]];
			return;
		}*/
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
