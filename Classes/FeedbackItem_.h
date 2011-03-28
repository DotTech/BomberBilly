//
//  FeedbackItem.h
//  BomberBilly
//
//  Created by Ruud van Falier on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
typedef struct sFeedbackItem {
    NSString* feedback;         // Feedback text to display
    CGPoint activateAtPoint;    // Point in tile data array that player needs to reach to activate the feedback
    BOOL wasShown;              // YES if feedback was shown
    CGPoint markingPoint;       // Show a marking circle sprite around this point (to clearify what the feedback is about)
} FeedbackItem;

static FeedbackItem* FeedbackItemCreate(NSString* feedback, CGPoint activateAtPoint, CGPoint markingPoint)
{
    FeedbackItem r = new FeedbackItem();
	r.feedback = feedback;
    r.activateAtPoint = activateAtPoint;
    r.markingPoint = markingPoint;
    r.wasShown = NO;
	return r;
}

static void FeedbackItemRelease(FeedbackItem* item)
{
    [item->feedback release];
    free(item);
}
*/