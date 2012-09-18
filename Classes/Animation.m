//
//  Animation.m
//  BomberBilly
//
//  Created by Ruud van Falier on 2/15/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import "Animation.h"
#import "ResourceManager.h"

@implementation Animation

@synthesize spriteSheetFileName;
@synthesize	tileSheetFileName;
@synthesize currentSequence;
@synthesize scale;
@synthesize rotation;


- (Animation*) initForSprite:(NSString*)spriteSheetFile
{
	CLog();
	[super init];
	
	maximumFrameSize = CGRectNull;
	rotation = 0;
    
	self.spriteSheetFileName = spriteSheetFile;
	NSDictionary* pListData = [resManager loadConfigSection:spriteSheetFile];
	
	// Loop through animation sequences
	NSString* key;
	NSEnumerator* keyEnumerator = [pListData keyEnumerator];
	sequences = [NSMutableDictionary dictionaryWithCapacity:1];
	int count = 0;
	
	while (key = [keyEnumerator nextObject]) {
		// Create animationsequence object and add it to our dictionary
		NSDictionary* sequenceData = [pListData objectForKey:key];		
		scale = [[sequenceData valueForKey:@"scale"] floatValue]; 
		
		AnimationSequence* tmp = [[AnimationSequence alloc] initSpriteWithFrames:sequenceData];
		[sequences setValue:tmp forKey:key];
		[tmp release];
		
		// Set default sequence
		if (count == 0) {
			[self setSequence:key];
		}
	}

	[sequences retain];
	return self;
}


- (Animation*) initForTile:(int)tileNumber
{
	CLog();
	[super init];
	
	maximumFrameSize = CGRectNull;
	
	self.tileSheetFileName = TILES;
	NSArray* pListData = (NSArray*)[resManager loadConfigSection:TILES];
	NSDictionary* tileData = [pListData objectAtIndex:tileNumber];

	// Create animationsequence object and add it to our dictionary
	scale = 1;
	BOOL loop = [[tileData valueForKey:@"loop"] boolValue];
	
	// Loop through animation sequences
	NSString* key;
	NSEnumerator* keyEnumerator = [tileData keyEnumerator];
	sequences = [NSMutableDictionary dictionaryWithCapacity:1];
	int count = 0;
	
	while (key = [keyEnumerator nextObject]) 
	{
		// Split key name on underscore and use 2nd part as sequence name
		NSArray* nameParts = [key componentsSeparatedByString:@"_"];
		if (nameParts.count > 1)
		{
			NSString* sequenceName = [nameParts objectAtIndex:1];
			NSArray* sequenceData = [tileData objectForKey:key];
			
			AnimationSequence* tmp = [[AnimationSequence alloc] initTileWithFrames:sequenceData loop:loop];
			[sequences setValue:tmp forKey:sequenceName];
			[tmp release];
			
			// Set default sequence
			if (count == 0) {
				[self setSequence:sequenceName];
			}
			count++;
		}
	}
	
	[sequences retain];
	return self;
}


- (void) dealloc
{
	CLog();
	[sequences release];
	[currentSequence release];
	[spriteSheetFileName release];
	[super dealloc];
}


// Loops through all sequences and determines the maximum width and height of this animated sprite
// Does not account for scaling!
- (CGRect) getMaximumFrameSize
{
	CLogGL();
	
	if (CGRectEqualToRect(maximumFrameSize, CGRectNull)) 
	{
		maximumFrameSize = CGRectMake(0, 0, 0, 0);
		NSEnumerator* enumerator = [sequences keyEnumerator];
		id key;
		
		while (key = [enumerator nextObject])
		{
			CGRect maxSequenceSize = [[sequences objectForKey:key] getMaximumFrameSize];
			if (maxSequenceSize.size.width > maximumFrameSize.size.width) {
				maximumFrameSize.size.width = maxSequenceSize.size.width;
			}
			if (maxSequenceSize.size.height > maximumFrameSize.size.height) {
				maximumFrameSize.size.height = maxSequenceSize.size.height;
			}
		}
	}
	
	return maximumFrameSize;
}

- (void) setSequence:(NSString*)sequence
{
	CLog();
	self.currentSequence = sequence;
	[[self get] reset];
}


- (AnimationSequence*) get
{
	CLogGL();
	return (AnimationSequence*)[sequences objectForKey:currentSequence];
}


#pragma mark -
#pragma mark Property overrides

// Maximum width of animation.
// Takes all sequences into account and also applies scaling
- (int) width
{
	return [self getMaximumFrameSize].size.width * scale;
}

// Maximum height of animation.
// Takes all sequences into account and also applies scaling
- (int) height
{
	return [self getMaximumFrameSize].size.height * scale;
}

// Maximum width of current animation sequence (with scaling applied)
- (int) sequenceWidth
{
	return [[self get] getMaximumFrameSize].size.width * scale;
}

// Maximum height of current animation sequence (with scaling applied)
- (int) sequenceHeight
{
	return [[self get] getMaximumFrameSize].size.height * scale;
}

@end
