//
//  Sprite.m
//  BomberBilly
//
//  Created by Ruud van Falier on 2/15/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import "Sprite.h"
#import "ResourceManager.h"

@implementation Sprite

@synthesize animation;
@synthesize x;
@synthesize y;
@synthesize flipped;
@synthesize offScreen;


- (Sprite*) initSprite:(NSString*)spriteName
{
	CLog();
	[super init];
	
	Animation* anim = [[Animation alloc] initForSprite:spriteName];
	
	lastUpdateTime = 0;	
	self.animation = anim;
	self.flipped = NO;
	self.x = 0;
	self.y = 0;
	self.offScreen = YES;
	
	[anim release];
	
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


// Draw current frame for the sprite at point.
// point.x is considered to be the center of the sprite, point.y is the bottom
- (void) drawAtPoint:(CGPoint)point
{
	CLogGL();
	
	if (!self.offScreen)
	{
		CGRect currentFrame = [self getCurrentFrame];
		int xOffset = 0;
		
		if (currentFrame.size.width <= animation.width) {
			xOffset = animation.width - currentFrame.size.width;
			xOffset = xOffset / 2;
		}
		
		// Make drawing point x the center of the sprite
		xOffset -= animation.width / 2;
		
		// Draw the frame on the OpenGL surface
		[[resManager getTexture:animation.spriteSheetFileName] 
		 drawInRect:CGRectMake(point.x + xOffset, point.y, currentFrame.size.width, currentFrame.size.height)
		 withClip:currentFrame withRotation:0 withScale:animation.scale];
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
}


- (CGRect) getCurrentFrame
{
	CLogGL();
	return [[animation get] getCurrentFrame:flipped];
}


#pragma mark -
#pragma mark Property overrides

- (int) dataRow
{
	// Determine which platform data row the sprite is located in
	// Note that sprite.y starts at bottom of the screen, but data rows start at the top of the array
	// So if (sprite.y == 480) then (spriteDataRow == 0)
	return floor((double)(SCREEN_HEIGHT - 1 - self.y) / TILE_HEIGHT);
}


- (int) dataColumn
{
	// If we dont overlap multiple columns, return immediatly
	if (self.dataColumnMin == self.dataColumnMax) {
		return self.dataColumnMax;
	}
	
	// Determine which column contains the most part of the sprite
	double widthOffset = (double)self.animation.sequenceWidth / 2;
	
	double minColumnSurface = (double)(self.x - widthOffset) / TILE_WIDTH;
	minColumnSurface = (double)self.dataColumnMax - minColumnSurface;
	
	double maxColumnSurface = (double)(self.x + widthOffset) / TILE_WIDTH;
	maxColumnSurface = maxColumnSurface - (double)self.dataColumnMax;
	
	if (minColumnSurface == maxColumnSurface) 
	{
		// We're spanning exactly the same amount of surface on both columns
		// If we're facing right, return columnMax, otherwise columnMin
		if (self.flipped) {
			return self.dataColumnMin;
		}
		else {
			return self.dataColumnMax;
		}
	}
	
	if (minColumnSurface > maxColumnSurface) {
		return self.dataColumnMin;
	}
	else {
		return self.dataColumnMax;
	}
}


- (int) dataColumnMin
{
	// Determine which platform data column(s) the sprite is overlapping	
	int widthOffset = self.animation.sequenceWidth / 2;
	int column = ceil((self.x - widthOffset) / TILE_WIDTH);
	
	if (column < 0) {
		column = 0;
	}
	
	return column;
}


- (int) dataColumnMax
{
	// Determine which platform data column(s) the sprite is overlapping
	int widthOffset = self.animation.sequenceWidth / 2;
	int column = ceil((self.x + widthOffset) / TILE_WIDTH);
	
	if (column > (SCREEN_WIDTH / TILE_WIDTH) - 1) {
		column = (SCREEN_WIDTH / TILE_WIDTH) - 1;
	}
	
	return column;
}

@end
