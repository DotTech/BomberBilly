//
//  AnimationSequence.h
//  BomberBilly
//
//  Created by Ruud van Falier on 2/15/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface AnimationSequence : NSObject
{
@private
	CGRect* frames;
    int* frameTimeouts;
    CGRect maximumFrameSize;
    int currentFrame;
    int frameCount;
    int flippedFrameOffsetX;
    BOOL loop;
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
