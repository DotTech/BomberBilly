//
//  FeedbackItem2.h
//  BomberBilly
//
//  Created by Ruud van Falier on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FeedbackItem : NSObject {
    NSString* feedback;         // Feedback text to display
    CGPoint activateAtPoint;    // Point in tile data array that player needs to reach to activate the feedback
    BOOL wasShown;              // YES if feedback was shown
    CGPoint markingPoint;       // Show a marking circle sprite around this point (to clearify what the feedback is about)
}

@property (nonatomic, retain) NSString* feedback;
@property CGPoint activateAtPoint;
@property CGPoint markingPoint;
@property BOOL wasShown;

- (FeedbackItem*) initFeedbackItem:(NSString*)feedbackText activationPoint:(CGPoint)aPoint markingPoint:(CGPoint)mPoint;

@end