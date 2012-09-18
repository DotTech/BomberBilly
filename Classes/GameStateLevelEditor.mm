//
//  GameStateLevelEditor.m
//  BomberBilly
//
//  Created by Ruud van Falier on 4/4/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import "GameStateLevelEditor.h"

#define TILE_COUNT 8

@implementation GameStateLevelEditor

- (GameStateLevelEditor*) initWithFrame:(CGRect)frame andManager:(GameStateManager*)manager
{
	if ((self = [super initWithFrame:frame andManager:manager]))
	{
        controlTiles = new Tile*[TILE_COUNT];
        for (int i=1; i<=TILE_COUNT; i++) 
        {
            CGPoint drawPosition = CGPointMake((i - 1) * TILE_WIDTH, 32);
            controlTiles[i - 1] = [[Tile alloc] initTile:(DrawingFlag)i physicsFlag:(PhysicsFlag)i position:drawPosition];
        }
	}
	return self;
}


- (void) update:(float)gameTime
{
    [self handleTouch];
    
    for (int i=0; i<TILE_COUNT; i++) {
        [controlTiles[i] update:gameTime];
    }
}


- (void) handleTouch
{
    if (touching)
    {
        if (touchPosition.x >= 0 && touchPosition.x <= TILE_COUNT * TILE_WIDTH
            && touchPosition.y >= 32 && touchPosition.y <= 64)
        {
            // Cancel previously blinking tile
            if (controlTiles[selectedTile].blinkingFlag != bfNotBlinking) {
                [controlTiles[selectedTile] stopTileBlinkingDone:NO];
            }
            
            // Start blinking touched tile
            selectedTile = floor((double)(touchPosition.x / TILE_WIDTH));
            if (controlTiles[selectedTile].blinkingFlag == bfNotBlinking) {
                [controlTiles[selectedTile] startTileBlinking:NO];
            }
        }
    }
}


- (void) render
{
	// Clear anything left over from the last frame, and set background color.
	glClear(GL_COLOR_BUFFER_BIT);
	
	[[resManager getTexture:BACKGROUND_LEVELEDITOR] drawInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
	
    for (int i=0; i<TILE_COUNT; i++) {
        [controlTiles[i] draw];
    }
    
	// Swap working buffer to active buffer
	[self swapBuffers];
}

@end
