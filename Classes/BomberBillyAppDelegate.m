//
//  BomberBillyAppDelegate.m
//  BomberBilly
//
//  Created by ruud on 19/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BomberBillyAppDelegate.h"
#import "BomberBillyViewController.h"
#import "GameStateMain.h"
#import "GameStateGameOver.h"
#import "GameStateTutorial.h"

@implementation BomberBillyAppDelegate

@synthesize window;
@synthesize viewController;


- (void) applicationDidFinishLaunching:(UIApplication *)application
{
	CLog();
	application.statusBarHidden = YES;
	
	// Initialize resourcemanager
	[ResourceManager initialize];
	
	// Set up main loop
	[NSTimer scheduledTimerWithTimeInterval:GAMELOOP_INTERVAL target:self selector:@selector(gameLoop) userInfo:nil repeats:NO];
	
	// Create instance of first GameState
	[self changeGameState:[GameStateTutorial class]];
}

- (void) gameLoop
{
	gameTime += GAMELOOP_INTERVAL;
	
	[((GameState*)viewController.view) update:gameTime];
	[((GameState*)viewController.view) render];
	
	[NSTimer scheduledTimerWithTimeInterval:GAMELOOP_INTERVAL target:self selector:@selector(gameLoop) userInfo:nil repeats:NO];
}

- (void) changeGameState:(Class)state
{
	CLog();
	if (viewController.view != NULL && [viewController.view isKindOfClass:[GameState class]]) 
	{
		[viewController.view removeFromSuperview];
		[viewController.view release];	// Release the gamestate!
	}
	
	viewController.view = [[state alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) andManager:self];
	
	[window addSubview:viewController.view];
	[window makeKeyAndVisible];
}


#pragma mark -
#pragma mark Application lifecycle

/*
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];

    return YES;
}
*/

- (void)applicationWillResignActive:(UIApplication *)application {
	CLog();
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	CLog();
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	CLog();
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	CLog();
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
	CLog();
	[resManager shutdown];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	// TODO: Handle this properly
	CLog();
    [resManager shutdown];
}


- (void)dealloc {
	CLog();
    [viewController release];
    [window release];
    [super dealloc];
}


@end
