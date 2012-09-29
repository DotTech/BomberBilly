//
//  GameStateGameOver.m
//  BomberBilly
//
//  Created by Ruud van Falier on 3/14/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import "GameStateGameOver.h"
#import	"GameStateMain.h"

@implementation GameStateGameOver


- (GameStateGameOver*) initWithFrame:(CGRect)frame andManager:(GameStateManager*)manager
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
		// Control panel is being touched
		if ((self.touchPosition.x >= BOMB_BUTTON.origin.x && self.touchPosition.x <= BOMB_BUTTON.origin.x + BOMB_BUTTON.size.width) &&
			(SCREEN_HEIGHT - self.touchPosition.y >= BOMB_BUTTON.origin.y && SCREEN_HEIGHT - self.touchPosition.y <= BOMB_BUTTON.origin.y + BOMB_BUTTON.size.height))
		{
			[self.gameStateManager changeGameState:[GameStateMain class]];
			return;
		}
	}
}


- (void) render
{
	// Clear anything left over from the last frame, and set background color.
	glClear(GL_COLOR_BUFFER_BIT);
	
	[[resManager getTexture:BACKGROUND_GAMEOVER] drawInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
	
	// Swap working buffer to active buffer
	[self swapBuffers];
}

@end
