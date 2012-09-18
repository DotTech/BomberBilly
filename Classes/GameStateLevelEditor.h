//
//  GameStateLevelEditor.h
//  BomberBilly
//
//  Created by Ruud van Falier on 4/4/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CMMotionManager.h>
#import "ResourceManager.h"
#import "GLESGameState.h"
#import "Tile.h"

@interface GameStateLevelEditor : GLESGameState {
    Tile** controlTiles;
    int selectedTile;
}

@end
