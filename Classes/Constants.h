//
//  Constants.h
//  BomberBilly
//
//  Created by Ruud van Falier on 21/02/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import <Foundation/Foundation.h>

// Sprite/tile sheets
#define SPRITE_HERO @"sprites_hero.png"         // Sprite sheet file for hero animations
#define SPRITE_ENEMIES @"sprites_enemies.png"   // Sprite sheet file for enemy animations
#define TILES @"tiles.png"                      // Tile sheet file
#define BACKGROUND @"background.png"            // Game world background
#define TILE_MARKER @"tilemarker.png"         
#define BACKGROUND_GAMEOVER @"gameover.png"
#define BACKGROUND_FINISHED @"finished.png"
#define BACKGROUND_MENU @"menu.png"
#define BACKGROUND_LEVELEDITOR @"background_leveleditor.png"

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
#define ANIMATION_SWITCH_ON @"switchedon"
#define ANIMATION_SWITCH_OFF @"default"

// Hero parameters
#define HERO_WALK_ACCELERATION 5    // Pixels added to position when hero moves one step
#define HERO_JUMP_ACCELERATION 10   // Pixels added to position for each step when hero jumps.
                                    // the acceleration will be lowered during the jump so it
                                    // slows down when moving up and it speeds up when moving down
#define HERO_JUMP_MAXHEIGHT 60      // Maximum height in pixels that the player is allowed to jump
#define HERO_UPDATE_INTERVAL 30
#define HERO_START_LIFES 999

// Elevator parameters
#define ELEVATOR_ACCELERATION 4         // Pixels added to position when elevator moves one step
#define ELEVATOR_WAITING_INTERVAL 500   // Let the elevator wait when it has reached the top or bottom
#define ELEVATOR_UPDATE_INTERVAL 25


// Enemy parameters
#define ENEMY_UPDATE_INTERVAL 30
#define ENEMY_WALK_ACCELERATION 2   // Pixels added to position when enemy moves one step

// Gamestates
#define GAMESTATE_MAIN 1
#define GAMESTATE_GAMEOVER 2
#define GAMESTATE_TUTORIAL 3

// Game parameters
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 480
#define SCREEN_WORLD_HEIGHT 416 // Available height for world tiles
#define PI 3.141592f
#define GAMELOOP_INTERVAL 0.033f    // Interval at which the gameloop method is called
#define FONT_ALLOCATION_CHARS @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890,.?!@/:- []%'|"
#define FONT_DEFAULT_NAME @"Helvetica"
#define TILE_WIDTH 32
#define TILE_HEIGHT 32
#define TILE_BLINKING_INTERVAL 50
#define SWITCH_TARGETMARKER_DURATION 1.0f   // How long to mark target tiles before executing the switch action (seconds)

// Level parameters
#define NUMBER_OF_LEVELS 5          // This includes the tiledebug and tutorial level
#define LEVELINDEX_DEBUGTILES 0
#define LEVELINDEX_TUTORIAL 1
#define LEVELINDEX_PLAYLEVELS_START 2

// Tutorial parameters
#define TUTORIAL_FONT_NAME @"Helvetica-Bold"    // Font used for tutorial feedback messages
#define TUTORIAL_MARKER @"marker.png"           // Image used to mark the game objects during tutorial
#define TUTORIAL_FEEDBACK_DURATION 3000         // How long to display feedback messages before hiding them

// Debugging options
#define DEBUG_ENEMIES_DONT_KILL 0       // Disables enemy kill ability
#define DEBUG_DEADLYTILES_DONT_KILL 0   // Disabled deadly tiles kill ability
#define DEBUG_SHOW_FPS 0                // Display frames-per-second counter
#define DEBUG_ENABLE_CALL_LOGGING 0     // See CallLogging.h for explanation
#define DEBUG_ENABLE_CALL_LOGGING_GAMELOOP_ALL 0
#define DEBUG_ENABLE_CALL_LOGGING_GAMELOOP_UPDATES 0
#define DEBUG_CALL_LOGGING_FILTER @""
#define DEBUG_TILE_DETECTION 0	// Set to 1 to enable tile detection debugging.
								// This will load a special level with 2 rows of tiles with the hero in between them.
								// On the first row, tiles that are detected left and right from the hero will light up.
								// On the second row, tiles that are detected underneath hero will light up.
#define DEBUG_TILE_DETECTION_ENEMIES 0  // Runs tile detection debugging with an Enemy entity instead of a Hero entity

// Location of game control buttons (value defined in Constants.m)
extern const CGRect BOMB_BUTTON;
extern const CGRect KILL_BUTTON;

// Screen scale (set in BomberBillyAppDelegate.m)
// This is used during all texture drawing
extern short SCREEN_SCALE;

// Import global helper functions
// This MUST be done after the definitions, since they are required for some helper functions
#import "Common.h"


@interface Constants : NSObject {

}

@end
