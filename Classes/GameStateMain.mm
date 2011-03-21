//
//  GameStateSpriteTest.m
//  BomberBilly
//
//  Created by Ruud van Falier on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameStateMain.h"
#import "GameStateGameOver.h"
#import "Level.h"

@implementation GameStateMain

@synthesize world;
@synthesize hero;


- (GameStateMain*) initWithFrame:(CGRect)frame andManager:(GameStateManager*)manager
{
	CLog();
	if (self = [super initWithFrame:frame andManager:manager]) 
	{
		// Create game world. We only need to initialize it once!
		self.world = [[World alloc] init];
		
		// Initialize game objects for the first time
		// We'll do this every time we (re)start a level
		currentLevel = 0;
		[self initGameObjects:@selector(loadingStatusUpdate:)];
		
		// Give the hero some lifes
		self.hero.lifes = lifes = HERO_START_LIFES;
	}
	return self;
}


- (void) dealloc
{
	CLog();
	[hero release];
	[world release];
	[super dealloc];
}


#pragma mark -
#pragma mark Game objects initialization

- (void) loadingStatusUpdate:(NSNumber*)percentageDone
{
	CLog();
	
	glClear(GL_COLOR_BUFFER_BIT);
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	
	[resManager.fontMessage drawString:[NSString stringWithFormat:@"Loading... [%d%%]", [percentageDone intValue]] atPoint:CGPointMake(75, 220)];

	NSLog(@"Loading... [%d%%]", [percentageDone intValue]);

	// TODO: Somehow the text is not being displayed...
	
	[self swapBuffers];
}


// Allocate and initialize all game objects (level definition, tiles, sprites)
// callback is invoked during the initialization to keep us informed about the progress
- (void) initGameObjects:(SEL)callback
{
	CLog();
	[self.world loadLevel:currentLevel progressCallback:CreateCallback(self, callback)];
	
	// Initialize our hero
	self.hero = [[Hero alloc] init];
	self.hero.offScreen = NO;
	self.hero.x = self.world.currentLevel.heroSpawnPoint.x;
	self.hero.y = self.world.currentLevel.heroSpawnPoint.y;
	self.hero.walkTowardsX = 0;
	self.hero.flipped = NO;
	self.hero.world = self.world;
	self.hero.bombs = self.world.currentLevel.startBombs;	
}


#pragma mark -
#pragma mark Game state update handlers

- (void) update:(float)gameTime
{
	CLogGL();
	[self updateFps];
	
	if (!restarting)
	{
		[self handleTouch];
		[self.world update:gameTime];
		[self.hero update:gameTime];
		
		// Check if hero is dead and has lifes left
		// Then either restart level or show gameover screen
		[self handleHeroDeath];
		
		// Check if hero reached the finish
		finished = (self.hero.state == DoneCheering);
	}
}


- (void) render
{
	CLogGL();
	
	// Clear anything left over from the last frame, and set background color.
	glClear(GL_COLOR_BUFFER_BIT);
	
	[[resManager getTexture:BACKGROUND] drawInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
	
	if (!restarting)
	{
		if (!gameOver && !finished)
		{
			// Draw text data (bomb/life count)
			[resManager.fontGameInfo drawString:[NSString stringWithFormat:@"%d", self.hero.bombs] atPoint:CGPointMake(113, 5)];
			[resManager.fontGameInfo drawString:[NSString stringWithFormat:@"%d", self.hero.lifes] atPoint:CGPointMake(268, 5)];
			if (DEBUG_SHOW_FPS) {
				[resManager.fontDebugData drawString:[NSString stringWithFormat:@"FPS:%d", fps] atPoint:CGPointMake(5, 460)];
			}
			
			// Draw world
			[self.world draw];
			
			// Draw hero sprite
			[self.hero draw];
		}
		else if (gameOver) {
			// We're game over... change gamestate and end the game
			// TODO: Switching to a new gamestate doesnt work yet when running on the actual hardware
			//		 For now we'll just restart the game
			[gameStateManager changeGameState:[GameStateGameOver class]];
			return;
		}
		else if (finished) {
			// Move on to the next level
			[self restartLevel:YES];
			return;
		}
	}
	
	// Swap working buffer to active buffer
	[self swapBuffers];
}


- (void) handleTouch
{
	CLogGL();
	
	if (touching) 
	{
		if (touchPosition.y > SCREEN_HEIGHT - SCREEN_WORLD_HEIGHT)
		{
			// World area is being touched
			// If we are not jumping, falling or dying then we walk
			if (self.hero.state != Jumping && self.hero.state != Falling && self.hero.state != Dying && self.hero.state != ReachedFinish) 
			{
				if (touchPosition.x <= SCREEN_WIDTH / 2) {
					self.hero.walkTowardsX = 0;
				}
				else {
					self.hero.walkTowardsX = 319;
				}
				self.hero.state = Walking;
			}
		}
		else 
		{
			// Control panel is being touched
			if ((touchPosition.x >= BOMB_BUTTON.origin.x && touchPosition.x <= BOMB_BUTTON.origin.x + BOMB_BUTTON.size.width) &&
				(SCREEN_HEIGHT - touchPosition.y >= BOMB_BUTTON.origin.y && SCREEN_HEIGHT - touchPosition.y <= BOMB_BUTTON.origin.y + BOMB_BUTTON.size.height))
			{
				if (gameOver) {
					currentLevel = 0;
					gameOver = NO;
					lifes = 2;
					[self restartLevel:NO];
				}
				
				// Bomb button is being touched
				if (self.hero.state == Idle) {
					self.hero.state = DroppingBomb;
				}
			}
			else if ((touchPosition.x >= KILL_BUTTON.origin.x && touchPosition.x <= KILL_BUTTON.origin.x + KILL_BUTTON.size.width) &&
				(SCREEN_HEIGHT - touchPosition.y >= KILL_BUTTON.origin.y && SCREEN_HEIGHT - touchPosition.y <= KILL_BUTTON.origin.y + KILL_BUTTON.size.height))
			{
				// Suicide button is being touched
				self.hero.state = Dying;
			}
		}
	}
	else 
	{
		if (self.hero.state == Jumping) {
			self.hero.state = Falling;
		}
		else if (self.hero.state != Falling && self.hero.state != Dying && self.hero.state != ReachedFinish) {
			self.hero.state = Idle;
		}
		
		// It's important to set WalkTowardsX to -1 otherwise hero will always
		// try to move to that coordinate during falls
		self.hero.walkTowardsX = -1;
	}
}


- (void) restartLevel:(BOOL)moveToNextLevel
{
	CLog();
	restarting = YES;
	
	if (moveToNextLevel) 
	{
		currentLevel++;
		if (currentLevel >= NUMBER_OF_LEVELS) {
			// Finished the game
			// TODO: Implement ending
			NSLog(@"Game finished");
			currentLevel = 0;
		}
	}
	
	[hero release];
	[self initGameObjects:@selector(loadingStatusUpdate:)];
	self.hero.lifes = lifes;
	finished = NO;
	
	restarting = NO;
}


- (void) handleHeroDeath
{
	CLogGL();
	
	if (self.hero.state == Dead) 
	{
		lifes--;
		self.hero.lifes = lifes;
		if (self.hero.lifes > 0) {
			[self restartLevel:NO];
		}
		else {
			gameOver = YES;
		}
	}
}

@end
