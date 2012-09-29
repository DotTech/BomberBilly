//
//  FeedbackItem2.h
//  BomberBilly
//
//  Created by Ruud van Falier on 3/25/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FeedbackItem : NSObject
{
@private
    CGPoint activateAtPoint;
    CGPoint markingPoint;
}

@property (nonatomic, retain) NSString* feedback;   // Feedback text to display
@property CGPoint activateAtPoint;                  // Point in tile data array that player needs to reach to activate the feedback
@property CGPoint markingPoint;                     // Show a marking circle sprite around this point (to clearify what the feedback is about)
@property BOOL wasShown;                            // YES if feedback was shown

- (FeedbackItem*) initFeedbackItem:(NSString*)feedbackText activationPoint:(CGPoint)aPoint markingPoint:(CGPoint)mPoint;

@end