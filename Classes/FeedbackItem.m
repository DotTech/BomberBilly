//
//  FeedbackItem2.m
//  BomberBilly
//
//  Created by Ruud van Falier on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedbackItem.h"


@implementation FeedbackItem

@synthesize feedback;
@synthesize activateAtPoint;
@synthesize markingPoint;
@synthesize wasShown;

- (FeedbackItem*) initFeedbackItem:(NSString*)feedbackText activationPoint:(CGPoint)aPoint markingPoint:(CGPoint)mPoint
{
    [super init];
    
    self.feedback = [[NSString alloc] initWithString:feedbackText];
    self.activateAtPoint = CGPointMake(aPoint.x, aPoint.y);
    self.markingPoint = CGPointMake(mPoint.x, mPoint.y);
    self.wasShown = NO;
    
    return self;
}

- (void) dealloc
{
    [feedback release];
    [super dealloc];
}

@end
