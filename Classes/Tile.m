//
//  Tile.m
//  BomberBilly
//
//  Created by Ruud van Falier on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Tile.h"
#import "ResourceManager.h"

// TODO: Pass isStateOn argument with executeSwitchAction 

@implementation Tile

@synthesize animation;
@synthesize width;
@synthesize height;
@synthesize x;
@synthesize y;
@synthesize physicsFlag;
@synthesize drawingFlag;


- (Tile*) initTile:(DrawingFlag)dFlag physicsFlag:(PhysicsFlag)pFlag position:(CGPoint)pos
{
	CLog();
	[super init];
	
	if (dFlag != dfDrawNothing)
	{
		Animation* anim = [[Animation alloc] initForTile:(int)dFlag];
		self.animation = anim;
		[anim release];
	}

    tileBlinkingFlag = bfNotBlinking;
	self.x = pos.x;
	self.y = pos.y;
	self.width = TILE_WIDTH;
	self.height = TILE_HEIGHT;	
	self.physicsFlag = pFlag;
	self.drawingFlag = dFlag;
	
	return self;
}


- (void) dealloc
{
	CLog();
	[animation release];
	[super dealloc];
}


#pragma mark -
#pragma mark Update & rendering

- (void) draw
{
	CLogGL();
	[self drawAtPoint:CGPointMake(self.x, self.y)];
}


- (void) drawAtPoint:(CGPoint)point
{
	CLogGL();
	
	if (self.drawingFlag != dfDrawNothing)
	{
		CLogGLU();
		CGRect currentFrame = [[self.animation get] getCurrentFrame:NO];
		[[resManager getTexture:TILES] 
					 drawInRect:CGRectMake(point.x, point.y, self.width, self.height)
					   withClip:currentFrame withRotation:self.animation.rotation withScale:self.animation.scale];
	}
}


- (void) update:(float)gameTime
{
	CLogGL();
	
	if (gameTime * 1000 > lastUpdateTime + [[animation get] getCurrentFrameTimeout]) 
	{
		CLogGLU();
		[[animation get] setNextFrame];
		lastUpdateTime = gameTime * 1000;
	}
    
    [self updateBlinking:gameTime];  
}


#pragma mark -
#pragma mark SwitchTile target handling

// A SwitchTile has targeted this tile and was toggled by the player.
// Now we let the tile blink for a short period so the player can see what Tile is being targeted
- (void) switchCallback:(BOOL)stateIsOn
{
	CLog();
    
    // Don't use fade out effect when we're going to explode the tile
    [self startTileBlinking:(self.physicsFlag != pfDestructibleTile)];
    
    [NSTimer scheduledTimerWithTimeInterval:SWITCH_TARGETMARKER_DURATION target:self selector:@selector(stopTileBlinking) userInfo:nil repeats:NO];
}


// Marking period (initiated by switchCallback) has passed and we can now execute the actual switch action
- (void) executeSwitchAction
{
    CLog();
    
    // Destructible tile switch toggled
    // Blow up the tile
    if (self.physicsFlag == pfDestructibleTile) 
    {
        self.physicsFlag = pfNoTile;
        [self.animation setSequence:ANIMATION_TILE_EXPLOSION];
    }
    
    // Deadly tile switch toggled
    // Change it to a destructible tile
    if (self.physicsFlag == pfDeadlyTile)
    {
        self.physicsFlag = pfDestructibleTile;
        
        Animation* anim = [[Animation alloc] initForTile:(int)dfDestructibleBlock];
        self.animation = anim;
        [anim release];
    }
    
    // Indestructible tile switch toggled
    // Change it to a deadly tile with drawingflag dfSpikes
    if (self.physicsFlag == pfIndestructibleTile)
    {
        self.physicsFlag = pfDeadlyTile;
        
        Animation* anim = [[Animation alloc] initForTile:(int)dfSpikes];
        self.animation = anim;
        [anim release];
    }
}


#pragma mark -
#pragma mark Tile blinking

- (void) updateBlinking:(float)gameTime
{
    // If tileBlinking is true, make the tile blink by hiding and showing it at a specific interval
    if (tileBlinkingFlag != bfNotBlinking && gameTime * 1000 > lastBlinkUpdateTime + TILE_BLINKING_INTERVAL)
    {
		CLogGLU();
        
        if (tileBlinkingFlag == bfBlinkingNoFading || tileBlinkingFlag == bfBlinkingWithFading) {
            self.drawingFlag = (self.drawingFlag == dfDrawNothing) ? drawingFlagBeforeBlink : dfDrawNothing;
        }
        else if (tileBlinkingFlag == bfEndingWithFading && self.animation.scale > 0) {
            self.animation.scale -= 0.15f;
            self.animation.rotation += 45;
        }
        else if (tileBlinkingFlag == bfFadingIn && self.animation.scale < 1) {
            self.animation.scale += 0.15f;
            self.animation.rotation -= 45;
        }
        else {
            [self stopTileBlinkingDone];
        }
        
		lastBlinkUpdateTime = gameTime * 1000;
    }
}


- (void) startTileBlinking:(BOOL)fadeOutAfterBlink
{
    tileBlinkingFlag = (fadeOutAfterBlink) ? bfBlinkingWithFading : bfBlinkingNoFading;
    drawingFlagBeforeBlink = drawingFlag;
}


- (void) stopTileBlinking
{
    tileBlinkingFlag = (tileBlinkingFlag == bfBlinkingWithFading) ? bfEndingWithFading : bfEndingNoFading;
    drawingFlag = drawingFlagBeforeBlink;
}


- (void) stopTileBlinkingDone
{
    [self stopTileBlinkingDone:YES];
}


- (void) stopTileBlinkingDone:(BOOL)executeSwitchAction
{
    if (tileBlinkingFlag == bfEndingWithFading) 
    {
        if (executeSwitchAction) {
            [self executeSwitchAction];
        }
        tileBlinkingFlag = bfFadingIn;
        self.animation.scale = 0;
        self.animation.rotation = 315;
        
        return;
    }
    
    if (tileBlinkingFlag != bfFadingIn && executeSwitchAction) {
        [self executeSwitchAction];
    }
    
    self.animation.scale = 1.0f;
    self.animation.rotation = 0;
    drawingFlag = drawingFlagBeforeBlink;
    tileBlinkingFlag = bfNotBlinking;
}


#pragma mark -
#pragma mark Properties

- (int) dataRow
{
	// Note that sprite.y starts at bottom of the screen, but data rows start at the top of the array
	// So if (sprite.y == 480) then (spriteDataRow == 0)
	return floor((double)(SCREEN_HEIGHT - 1 - self.y) / TILE_HEIGHT);
}


- (int) dataColumn
{
	return floor((double)(self.x / TILE_WIDTH));
}


@end
