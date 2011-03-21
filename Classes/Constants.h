//
//  Constants.h
//  BomberBilly
//
//  Created by ruud on 21/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Sprite sheets
#define SPRITE_HERO @"sprites_hero.png"
#define SPRITE_ENEMIES @"sprites_enemies.png"
#define TILES @"tiles.png"
#define BACKGROUND @"background.png"
#define BACKGROUND_GAMEOVER @"gameover.png"
#define BACKGROUND_FINISHED @"finished.png"

// Animation sequences
#define ANIMATION_HERO_IDLE @"hero_idle"
#define ANIMATION_HERO_WALKING @"hero_walking"
#define ANIMATION_HERO_JUMP_UP @"hero_jump_up"
#define ANIMATION_HERO_JUMP_HANG @"hero_jump_hang"
#define ANIMATION_HERO_JUMP_TOUCHDOWN @"hero_jump_touchdown"
#define ANIMATION_HERO_DYING @"hero_dying"
#define ANIMATION_HERO_CHEERING @"hero_cheering"
#define ANIMATION_ENEMY_DEVILCAR @"enemy_devilcar"
#define ANIMATION_ENEMY_DYING @"enemy_dying"
#define ANIMATION_TILE_DEFAULT @"default"
#define ANIMATION_TILE_EXPLOSION @"explosion"
#define ANIMATION_TILE_DEBUGDETECTION @"debugtiledetection"

// Hero parameters
#define HERO_UPDATE_INTERVAL 30
#define HERO_WALK_ACCELERATION 5
#define HERO_JUMP_ACCELERATION 12
#define HERO_JUMP_MAXHEIGHT 75
#define HERO_START_BOMBS 10
#define HERO_START_LIFES 999

// Elevator parameters
#define ELEVATOR_ACCELERATION 4
#define ELEVATOR_UPDATE_INTERVAL 25
#define ELEVATOR_WAITING_INTERVAL 500

#define SWITCH_SEQUENCE_ON @"switchedon"
#define SWITCH_SEQUENCE_OFF @"default"

// Enemy parameters
#define ENEMY_UPDATE_INTERVAL 30
#define ENEMY_WALK_ACCELERATION 2

// Gamestates
#define GAMESTATE_MAIN 1
#define GAMESTATE_GAMEOVER 2

// Game parameters
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 480
#define SCREEN_WORLD_HEIGHT 416
#define TILE_WIDTH 32
#define TILE_HEIGHT 32
#define NUMBER_OF_LEVELS 3
#define PI 3.141592f
#define GAMELOOP_INTERVAL 0.033f
#define FONT_ALLOCATION_CHARS @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890,.?!@/:- []%"
#define FONT_DEFAULT_NAME @"Helvetica"

// Location of game control buttons
extern const CGRect BOMB_BUTTON;
extern const CGRect KILL_BUTTON;

// Debugging options
#define DEBUG_ENEMIES_DONT_KILL 0
#define DEBUG_DEADLYTILES_DONT_KILL 0
#define DEBUG_SHOW_FPS 1
#define DEBUG_ENABLE_CALL_LOGGING 1
#define DEBUG_ENABLE_CALL_LOGGING_GAMELOOP_ALL 0
#define DEBUG_ENABLE_CALL_LOGGING_GAMELOOP_UPDATES 0
#define DEBUG_CALL_LOGGING_FILTER @""
#define DEBUG_TILE_DETECTION 0	// Set to 1 to enable tile detection debugging.
								// This will load a special level with 2 rows of tiles with the hero in between them.
								// On the first row, tiles that are detected left and right from the hero will light up.
								// On the second row, tiles that are detected underneath hero will light up.

// Import global helper functions
// This MUST be done after the definitions, since they are required for some helper functions
#import "Helpers.h"


@interface Constants : NSObject {

}

@end
