//
//  BomberBillyAppDelegate.h
//  BomberBilly
//
//  Created by ruud on 19/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResourceManager.h"
#import "GameStateManager.h"

@class BomberBillyViewController;

@interface BomberBillyAppDelegate : GameStateManager <UIApplicationDelegate> {
    UIWindow* window;
    BomberBillyViewController* viewController;
	float gameTime;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet BomberBillyViewController* viewController;

- (void) gameLoop;

@end

