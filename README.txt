==============================================================
| BomberBilly - 2D puzzle platform game for iPhone/iPad/iPod |
| ---------------------------------------------------------- |
| Project started on February 22th, 2011                     |
| First release (version x.x.x) on ???                       |
|                                                            |
| ---------------------------------------------------------- |
| Created by Ruud van Falier                                 |
|                                                            |
| E-mail: 	ruud.vanfalier@gmail.com                     |
| Twitter:	BrruuD                                       |
| LinkedIn:	-                                            |
| Blog:		http://ruuddottech.blogspot.com              |
==============================================================


TODOs / Bugs:
-------------
- [prio 1]: New tile: partly penetrable tile, which allows you to walk through from one side, but not from another side
- [prio 1]: Switching gamestates is working fine on simulation, but on hardware (iPad, iPhone not tested yet) it will
  	    take an enormous amount of time for glFinish() to be executed after switching from one gamestate to another.
	    For this reason GameStateGameOver has been disabled for now and the player gets 999 lifes to start with...
- [prio 2]: Loading screen is not showing at initial load, only after level restarts
- [prio 2]: Enemy tile detection seems a little off when they move to the left.
	    They switch to another data column when on screen they did clearly not move into that column ey
- [prio 3]: Level editor
- [prio 3]: Create more levels; i want 10 good levels to test how people like it when they play them
- [prio 4]: A better end-goal must be come up with. Like keeping scores, or finishing levels in fasted time.
	    Highscore lists are a must, so are social network connections to post achievements.
- [prio 5]: Think about payment model (free download and purchase levels? free lite version and paid full version?)
- [prio 5]: Think about how to get someone to make good graphics
- Support for both retina and non-retina displays...


=========================================================================================================================
Version:	0.1.6
Date:		2011-03-28

Added features:
---------------
- When tiles are being targeted by switches, after toggling, the tile will start to blink and then fade out before letting the new tile fade in.
  This way the user can clearly see what tiles are being targeted. The fade-out/fade-in effect is not applied to elevators and tiles that blow up
- Preparations made for functionality that blinks switch targets when user touches the switch, so he can see beforehand what they are meant for.
  This is almost done, just canceling userinput after this is not working yet.
- Extra level added
- Some code optimizations (eg. Entity class added as base for Hero and Enemy)
- Enemies can now avoid falling off edges
- Enemies can now ride with elevators
- New switch action: Destructible tiles can be converted to deadly tiles
  The old action (change to jump tile) has been removed
- TileDebugging level works for Enemy entities too now, we're gonna use this to solve the tile detection problem for them


=========================================================================================================================
Version:	0.1.5
Date:		2011-03-25

Added features:
---------------
- Tutorial mode fully implemented
- "Loading..." screen partly implemented (on first load it does not show yet…)


=========================================================================================================================
Version: 	0.1.4
Date:		2011-03-20

I've decided to keep track of changes for each version.
Because this is the first release notes version, it will list all (or at least most) currently finished features.
For future release notes only the changes will be documented.

Game mechanics and features:
-----------------------------
- GameStateMain is the state that hold the actual game code
  * it manages the World instance
  * it manages the Hero (player) instance
  
- The World object:
  * defines which Level classes are available
  * handles creation of level instances
  * manages the enemy instanes
  * provides tile detection
  * initiates the update and rendering for all game objects
  
- Level definition classes:
  * inherit from the base Level class
  * define which tiles are drawn
  * define how these tiles behave
  * define which tiles are targeted by specific switches
  * create enemies instances
  * create tile instances

- We support tiles that are:
  * destructible (can be destroyed with bombs)
  * indestructible
  * jumping platforms (make player jump when walked over)
  * bombs (can be picked up by player)
  * deadly (kill the player and enemies)
  * finish (mark the end of a level)
  * elevators (tiles that move up and down and allow the player to stand on them)
  * switches (can be switched on/off and change the state of target tiles)
  
- Hero (player) can:
  * walk left and right
  * jump
  * fall 
  * drop bomb (drops a bomb and destroys destructible tiles to the immediate left, right and bottom of the player)
  * die
  * cheer (when he reached the end he makes does happy dance)
  * detect if it collides with any enemies
  
- Enemies can:
  * walk left and right
  * fall
  * die
  
- Switches can target:
  * deadly tiles, when toggled it will change them into destructible tiles
  * indestructible tiles, when toggled it will change them into jumping tiles
  * destructible tile: when toggled, it will blow them up
  
Code features:
--------------
- Constants.h is imported by every source file and contains game parameters and other constant values
- Helpers.h is imported by Constants.h so is also available from every source file and contains old-C style
  helper functions and structs that are required by multiple files in the project
- World.loadLevel and Level.createTilesLayer allow for a callback to be passed as parameter which 
  is called during the loading of game objects to keep the caller informed about the progress
- CLog() can be used to log method calls (see Helpers.h for extensive explanation)
- Setting DEBUG_TILE_DETECTION to 1 will enable a special debug level and some alternative methods
  that will visualize tile detection

