//
//  Tile.m
//  BomberBilly
//
//  Created by Ruud van Falier on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Tile.h"
#import "ResourceManager.h"

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
					   withClip:currentFrame withRotation:0];
	}
}


- (void) update:(float)gameTime
{
	CLogGL();
	
	if (gameTime * 1000 > lastUpdateTime + [[animation get] getCurrentFrameTimeout]) 
	{
		CLogGLU();
		lastUpdateTime = gameTime * 1000;
		[[animation get] setNextFrame];
	}
}


- (void) switchCallback:(BOOL)stateIsOn
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
	// Change it to a jump tile
	if (self.physicsFlag == pfIndestructibleTile)
	{
		self.physicsFlag = pfJumpTile;
		
		Animation* anim = [[Animation alloc] initForTile:(int)dfJumpBlock];
		self.animation = anim;
		[anim release];
	}
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
