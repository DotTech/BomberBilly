//
//  AnimationSequence.h
//  BomberBilly
//
//  Created by Ruud van Falier on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface AnimationSequence : NSObject {
	CGRect* frames;
	CGRect maximumFrameSize;
	int* frameTimeouts;
	int currentFrame;
	int frameCount;
	BOOL loop;
	int flippedFrameOffsetX;
}

@property (readonly) BOOL animationEnded;

- (AnimationSequence*) initSpriteWithFrames:(NSDictionary*)sequenceData;
- (AnimationSequence*) initTileWithFrames:(NSArray*)framesData loop:(BOOL)l;
- (void) addFrame:(NSDictionary*)frameData addAtIndex:(int)index isFlipped:(BOOL)flipped;
- (void) reset;
- (CGRect) getCurrentFrame:(BOOL)flipped;
- (CGRect) getMaximumFrameSize;
- (int) getCurrentFrameTimeout;
- (void) setNextFrame;

@end
