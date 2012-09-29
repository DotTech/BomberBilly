//
//  AnimationSequence.m
//  BomberBilly
//
//  Created by Ruud van Falier on 2/15/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import "AnimationSequence.h"

@implementation AnimationSequence

- (AnimationSequence*) initSpriteWithFrames:(NSDictionary*)sequenceData
{
	CLog();
	self = [super init];
	
	NSArray* framesData = (NSArray*)[sequenceData valueForKey:@"frames"];
	loop = [[sequenceData valueForKey:@"loop"] intValue];
	flippedFrameOffsetX = [[sequenceData valueForKey:@"flippedFrameOffsetX"] intValue];
	currentFrame = 0;
	maximumFrameSize = CGRectNull;
	
	// Create CGRect array for our frames
	// Note that we also store the flipped version of each frame in the frames[] array
	// First half of the array is facing one side, second half is facing the other side
	frameCount = [framesData count];
	frames = new CGRect[frameCount*2];
	frameTimeouts = new int[frameCount*2];
	
	for (int i=0; i<frameCount; i++) {
		int flippedFrameIndex = i + frameCount;
		
		// Create a CGRect for each frame
		NSDictionary* frameData = [framesData objectAtIndex:i];
		
		// Add both versions (regular and flipped) of the frame
		[self addFrame:frameData addAtIndex:i isFlipped:NO];
		[self addFrame:frameData addAtIndex:flippedFrameIndex isFlipped:YES];
	}
	
	return self;
}


- (AnimationSequence*) initTileWithFrames:(NSArray*)framesData loop:(BOOL)l
{
	CLog();
	self = [super init];
	
	currentFrame = 0;
	maximumFrameSize = CGRectNull;
	
	// Create CGRect array for our frames
	// Tiles dont have flipped frames
	frameCount = [framesData count];
	frames = new CGRect[frameCount*2];
	frameTimeouts = new int[frameCount*2];
	loop = l;
	
	for (int i=0; i<frameCount; i++) {
		// Create a CGRect for each frame and add it to the frame array
		NSDictionary* frameData = [framesData objectAtIndex:i];
		[self addFrame:frameData addAtIndex:i isFlipped:NO];
	}
	
	return self;
}


- (void) dealloc
{
	CLog();
	delete frames;
	delete frameTimeouts;
	[super dealloc];
}


- (void) addFrame:(NSDictionary*)frameData addAtIndex:(int)index isFlipped:(BOOL)flipped
{
	CLog();
	
	int x = [[frameData valueForKey:@"x"] intValue];
	int y = [[frameData valueForKey:@"y"] intValue];
	int w = [[frameData valueForKey:@"w"] intValue];
	int h = [[frameData valueForKey:@"h"] intValue];
	int timeout = [[frameData valueForKey:@"time"] intValue];
	
	if (flipped && flippedFrameOffsetX > 0) {
		x = flippedFrameOffsetX + (flippedFrameOffsetX - x) - w;
	}
	
	frames[index] = CGRectMake(x, y, w, h);
	frameTimeouts[index] = timeout;
}


- (void) reset
{
	CLogGL();
	currentFrame = 0;
}


- (CGRect) getCurrentFrame:(BOOL)flipped
{
	CLogGL();
	
	if (flipped) {
		return frames[currentFrame + frameCount];
	}
	else {
		return frames[currentFrame];
	}
}


// Determine the maximum width and height of this animation sequence
// Does not account for scaling!
- (CGRect) getMaximumFrameSize
{
	CLogGL();
	
	if (CGRectEqualToRect(maximumFrameSize, CGRectNull)) 
	{
		maximumFrameSize = CGRectMake(0, 0, 0, 0);
		for (int i=0; i<frameCount; i++) 
		{
			if (frames[i].size.width > maximumFrameSize.size.width) {
				maximumFrameSize.size.width = frames[i].size.width;
			}
			if (frames[i].size.height > maximumFrameSize.size.height) {
				maximumFrameSize.size.height = frames[i].size.height;
			}
		}
	}
	return maximumFrameSize;
}


- (int) getCurrentFrameTimeout
{
	CLogGL();
	return frameTimeouts[currentFrame];
}


- (void) setNextFrame
{
	CLogGL();
	
	if (frameCount > 1)
	{
		currentFrame++;
		if (currentFrame >= frameCount && loop) {
			[self reset];
		}
		else if (currentFrame >= frameCount && !loop) {
			currentFrame--;
		}
	}
}


- (BOOL) animationEnded
{
	CLogGL();
	return currentFrame == frameCount - 1;
}

@end
