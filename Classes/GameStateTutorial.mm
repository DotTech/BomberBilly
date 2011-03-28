//
//  GameStateTutorial.m
//  BomberBilly
//
//  Created by Ruud van Falier on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  Inherits from GameStateMain so it act like playing the regular game
//  However, it forces to load the TutorialLevel as active level and provides 
//  feedback while playing the level to learn the player about the game mechanics

#import "GameStateTutorial.h"

@implementation GameStateTutorial


#pragma mark -
#pragma mark Overrides of GameStateMain methods

// Override original gameobjects initialization to force loading the tutorial level
- (void) initGameObjects:(SEL)callback
{
	CLog();
    
    // Force tutorial level to be loaded
    currentLevel = LEVELINDEX_TUTORIAL;
    activeFeedbackItem = -1;
    
    // Define all the feedback for the tutorial
    [self defineFeedback];
    
    [super initGameObjects:callback];
}


- (void) dealloc
{
    CLog();
    releaseObjectArray(feedbackItems, feedbackItemCount);
    [super dealloc];
}


- (void) update:(float)gameTime
{
    CLogGL();

    [super update:gameTime];
	[self updateFeedback:gameTime];
}


- (void) render
{
    CLogGL();
    
    // Call base render without buffer swap
    [self render:NO];
    
    // Check if we need to display a feedback item
    if (activeFeedbackItem > -1) 
    {
        FeedbackItem* item = feedbackItems[activeFeedbackItem];
        
        // Mark the object the feedback is about
        [[resManager getTexture:TUTORIAL_MARKER] drawAtPoint:item.markingPoint];
        
        // Display the feedback item
        [self drawFeedbackText:item];
    }
    
    [self swapBuffers];
}


- (void) handleTouch
{
    CLogGL();
    
    // Cancel touch events when feedback is shown
    if (activeFeedbackItem > -1) {
        touching = NO;
    }
    
    [super handleTouch];
}


- (void) restartLevel:(BOOL)moveToNextLevel
{
	CLog();
    if (moveToNextLevel) {
        [gameStateManager changeGameState:[GameStateMain class]];
    }
    else {
        [super restartLevel:NO];
    }
}


- (void) handleHeroDeath
{
	CLogGL();
	if (self.hero.state == HeroDead) {
        CLogGLU();
		[self restartLevel:NO];
	}
}


#pragma mark -
#pragma mark Tutorial specific methods

// Draws the feedback text on the screen.
// It will break down the text and draw it in seperate lines
// because only 25 characters fit on one line
- (void) drawFeedbackText:(FeedbackItem*)item
{
    CLogGL();
    
    int charsPerLine = 28;
    int fontHeight = 30;
    int yOffset = 415;
    
    // Draw the text on the bottom half of the world if the hero is located above row 7
    if (self.hero.dataRow < 7) {
        yOffset = (SCREEN_HEIGHT - SCREEN_WORLD_HEIGHT) + SCREEN_WORLD_HEIGHT / 2 - fontHeight - 20;
    }
    
    // We split the string into an array of words so we can seperate it into
    // several lines without splitting it in the middle of a word
    NSArray* words = [item.feedback componentsSeparatedByString:@" "];
    NSString* line = [[NSString alloc] init];
    int currentWord = 0;
    int currentLine = 0;
    int charsProcessed = 0;
    BOOL lastLine = NO;
    
    // Draw the words on lines until we have drawn them all
    while ([words count] - currentWord > 0)
    {
        NSString* word = [words objectAtIndex:currentWord];
        if (line.length + word.length <= charsPerLine)
        {
            // Add current word to the current line string
            line = [line stringByAppendingFormat:@" %@", word];
            charsProcessed += word.length + 1;
            currentWord++;
        }
        
        if (line.length + word.length > charsPerLine || currentWord == [words count])
        {
            // The current line is full or end of string is reached
            
            // If this is the last line, draw the countdown value
            // that indicates when the feedback will be hidden
            lastLine = currentWord == [words count];
            
            // Draw the line and move on to the next line
            int y = yOffset - currentLine * fontHeight;
            [self drawString:line atPoint:CGPointMake(5, y)];

            if (lastLine) {
                NSString* progress = [self countdownProgressBar];
                [self drawString:[NSString stringWithFormat:@"%@", progress] atPoint:CGPointMake(5, y - fontHeight)];
                [progress release];
            }
            
            line = [NSString stringWithString:@""];
            currentLine++;
        }
    }
}


// Draws a progressbar to indicate how long the feedback message will be displayed
- (NSString*) countdownProgressBar
{
    CLogGL();
    NSString* progress = [[NSString alloc] init];
    
    for (int i=0; i<ceil(secondsUntilFeedbackHide * 10); i++) {
        progress = [progress stringByAppendingString:@"|"];
    }
    
    return [progress retain];
}


// Draw black string with white outer glow
- (void) drawString:(NSString*)string atPoint:(CGPoint)point
{
    CLogGL();
    int x = point.x;
    int y = point.y;
    
    // Draw the string around the point a few time to create a colored background
    [self.fontFeedbackBg drawString:string atPoint:CGPointMake(x + 2, y - 2)];
    [self.fontFeedbackBg drawString:string atPoint:CGPointMake(x - 2, y + 2)];
    [self.fontFeedbackBg drawString:string atPoint:CGPointMake(x + 2, y + 2)];
    [self.fontFeedbackBg drawString:string atPoint:CGPointMake(x - 2, y - 2)];
    
    // Now draw the foreground string
    [self.fontFeedback drawString:string atPoint:point];
}


// Define the feedback texts and on when they must be displayed
- (void) defineFeedback
{
    CLog();
    
    feedbackItemCount = 18;
    feedbackItems = new FeedbackItem*[feedbackItemCount];
    feedbackItems[0] = [[FeedbackItem alloc] initFeedbackItem:@"This is Billy, our hero in this game. You are in control of Billy..." activationPoint:CGPointMake(0, 0) markingPoint:CGPointMake(20, 464)];
    feedbackItems[1] = [[FeedbackItem alloc] initFeedbackItem:@"Touch the left or right half of the screen to make him start walking" activationPoint:CGPointMake(0, 0) markingPoint:CGPointMake(20, 464)];
    feedbackItems[2] = [[FeedbackItem alloc] initFeedbackItem:@"You can collect bombs that can be used to blow up certain blocks. Go grab this bomb!" activationPoint:CGPointMake(3, 0) markingPoint:CGPointMake(208, 464)];
    feedbackItems[3] = [[FeedbackItem alloc] initFeedbackItem:@"Blocks like this one can be blown up by touching the Drop Bomb button. Try it!" activationPoint:CGPointMake(6, 0) markingPoint:CGPointMake(304, 432)];
    feedbackItems[4] = [[FeedbackItem alloc] initFeedbackItem:@"Do you see that switch over there? Switches toggle or convert certain platforms." activationPoint:CGPointMake(9, 2) markingPoint:CGPointMake(108, 400)];
    feedbackItems[5] = [[FeedbackItem alloc] initFeedbackItem:@"Touch the switch to see what is targeted by them. Walk towards the switch to toggle it" activationPoint:CGPointMake(9, 2) markingPoint:CGPointMake(108, 400)];
    feedbackItems[6] = [[FeedbackItem alloc] initFeedbackItem:@"This switch will activate the elevator which allows you to move up and down. Let's try it!" activationPoint:CGPointMake(4, 2) markingPoint:CGPointMake(48, 304)];
    feedbackItems[7] = [[FeedbackItem alloc] initFeedbackItem:@"Look at those awful spikes. They will kill you! Luckily there is a switch nearby..." activationPoint:CGPointMake(1, 4) markingPoint:CGPointMake(192, 304)];
    feedbackItems[8] = [[FeedbackItem alloc] initFeedbackItem:@"When a switch targets spikes, it will convert them into blocks that can be blown up" activationPoint:CGPointMake(2, 4) markingPoint:CGPointMake(102, 336)];
    feedbackItems[9] = [[FeedbackItem alloc] initFeedbackItem:@"This switch targets the bombable blocks we just created. It will blow them up for us!" activationPoint:CGPointMake(4, 4) markingPoint:CGPointMake(272, 336)];
    feedbackItems[10] = [[FeedbackItem alloc] initFeedbackItem:@"That vicious thing over there is your enemy! It will kill you when you run into it." activationPoint:CGPointMake(8, 4) markingPoint:CGPointMake(64, 272)];
    feedbackItems[11] = [[FeedbackItem alloc] initFeedbackItem:@"They have a weakness though; they are just as vulnerable to spikes as you are!" activationPoint:CGPointMake(8, 4) markingPoint:CGPointMake(64, 272)];
    feedbackItems[12] = [[FeedbackItem alloc] initFeedbackItem:@"This switch targets the blocks underneath the enemy. Flip it and make the bastard fall into the spikes!" activationPoint:CGPointMake(8, 4) markingPoint:CGPointMake(272, 272)];
    feedbackItems[13] = [[FeedbackItem alloc] initFeedbackItem:@"BOOYAH! Now blast your way through these two blocks" activationPoint:CGPointMake(8, 6) markingPoint:CGPointMake(140, 260)];
    feedbackItems[14] = [[FeedbackItem alloc] initFeedbackItem:@"This block is a jumping platform. Run over it to jump. Go grab that bomb up there!" activationPoint:CGPointMake(4, 9) markingPoint:CGPointMake(240, 168)];
    feedbackItems[15] = [[FeedbackItem alloc] initFeedbackItem:@"Very good! Now look at that door over there. That's the exit. Reach it to finish the level" activationPoint:CGPointMake(9, 8) markingPoint:CGPointMake(16, 136)];
    feedbackItems[16] = [[FeedbackItem alloc] initFeedbackItem:@"You should be able to figure out how to get there by yourself now. Good luck!" activationPoint:CGPointMake(9, 8) markingPoint:CGPointMake(16, 136)];
    feedbackItems[17] = [[FeedbackItem alloc] initFeedbackItem:@"You finished the tutorial level and are ready for the real deal. Enjoy!" activationPoint:CGPointMake(1, 11) markingPoint:CGPointMake(-100, -100)];
}


// Update the active FeedbackItem according to hero's position
- (void) updateFeedback:(float)gameTime
{
	CLogGL();
    for (int i=0; i<feedbackItemCount; i++) 
    {
        if (feedbackItems[i].activateAtPoint.y == self.hero.dataRow && feedbackItems[i].activateAtPoint.x == self.hero.dataColumn) 
        {
            // There is a feedback item linked to hero's current location
            // If we are currently displaying feedback already, check if it's time to hide it
            BOOL displayTimeElapsed = gameTime * 1000 > feedbackActivationTime + TUTORIAL_FEEDBACK_DURATION;
            if (activeFeedbackItem == i && !feedbackItems[i].wasShown && displayTimeElapsed) 
            {
                // Remember that the feedback was shown so we don't show it again
                feedbackItems[i].wasShown = YES;
                activeFeedbackItem = -1;
                return;
            }
            else if (activeFeedbackItem == -1 && !feedbackItems[i].wasShown)
            {
                // There is no active feedback yet and feedback for this location was not shown before
                activeFeedbackItem = i;
                feedbackActivationTime = gameTime * 1000;
                secondsUntilFeedbackHide = (float)((feedbackActivationTime + TUTORIAL_FEEDBACK_DURATION) - gameTime * 1000) / 1000;
                return;
            }
            else if (activeFeedbackItem > -1) {
                // There is active feedback, tell us how long until it will be hidden
                secondsUntilFeedbackHide = (float)((feedbackActivationTime + TUTORIAL_FEEDBACK_DURATION) - gameTime * 1000) / 1000;
            }
        }
    }
}


#pragma mark -
#pragma mark Properties

- (GLFont*) fontFeedback
{
	if (fontFeedback == nil) 
    {
        CLog();
		fontFeedback = [[GLFont alloc] initWithString:FONT_ALLOCATION_CHARS fontName:TUTORIAL_FONT_NAME
                                            fontSize:21.0f strokeWidth:0 fillColor:[UIColor blackColor] strokeColor:nil];
		[fontFeedback retain];
	}
	return fontFeedback;
}


- (GLFont*) fontFeedbackBg
{
	if (fontFeedbackBg == nil) 
    {
        CLog();
		fontFeedbackBg = [[GLFont alloc] initWithString:FONT_ALLOCATION_CHARS fontName:TUTORIAL_FONT_NAME
                                             fontSize:21.0f strokeWidth:0 fillColor:[UIColor whiteColor] strokeColor:nil];
		[fontFeedbackBg retain];
	}
	return fontFeedbackBg;
}

@end
