//
//  GameStateTutorial.h
//  BomberBilly
//
//  Created by Ruud van Falier on 3/21/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CMMotionManager.h>
#import "ResourceManager.h"
#import "GLESGameState.h"
#import "GameStateMain.h"
#import "FeedbackItem.h"


@interface GameStateTutorial : GameStateMain
{
@private
    FeedbackItem** feedbackItems;
    int activeFeedbackItem;
    int feedbackItemCount;
    GLFont* fontFeedback;
    GLFont* fontFeedbackBg;
    float secondsUntilFeedbackHide;
    float feedbackActivationTime;
}

@property (readonly) GLFont* fontFeedback;
@property (readonly) GLFont* fontFeedbackBg;

- (void) defineFeedback;
- (void) updateFeedback:(float)gameTime;
- (void) drawFeedbackText:(FeedbackItem*)item;
- (void) drawString:(NSString*)string atPoint:(CGPoint)point;
- (NSString*) countdownProgressBar;

@end
