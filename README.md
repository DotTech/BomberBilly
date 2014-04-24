# BomberBilly - 2D puzzle platformer for iOS  

**Project started on February 22nd, 2011**  
**Status: unreleased, development on hold**  

------------------

This was my first attempt at an iOS game in the beginning of 2011 and also the first time I used Objective-C and XCode.  
The project was build from scratch without the use of an existing game engine.  
Although it was a lot of fun building it, I don't really see a future for the project in its current state.  
Its state being a fully working game engine with quite a few features and some demo levels but still a lot of work left to turn it into a releasable game.  

Should work from iOS 4.3 up until the latest version.  

**Check out the game play demo:** https://www.youtube.com/watch?v=ZyyTdjWcgM0  

**Created by Ruud van Falier**  
E-mail: ruud.vanfalier@gmail.com  
Twitter: BrruuD  
LinkedIn: http://nl.linkedin.com/in/ruudvanfalier  

### TODO's:
- [new] Slow scrolling background image  
- [bug] Loading screen is not showing at initial load, only after level restarts  
- [bug] Enemy tile detection seems a little off when they move to the left.  
        They switch to another data column when on screen they did clearly not move into that column.
- [new] Create more levels for a demo that goes in the App Store;  
        make 10 good levels to test how people like it when they play them			
- [new] Push news and new apps  
- [new] New graphics for free demo in app store  
- [bug] Tutorial mode, touch to end help text  
- [new] Score after level is done, based on time and bombs left  
        Post score to online highscore list  
        Sharing option for scores



### Version: 0.0.4 (2012-09-25)

*Added features:*  
- Added support for scaling (Retina displays)
- Version numbering revised


### Version: 0.0.3 (2011-03-28)

*Added features:*  
- When tiles are being targeted by switches, after toggling, the tile will start to
  blink and then fade out before letting the new tile fade in.
  This way the user can clearly see what tiles are being targeted. The fade-out/
  fade-in effect is not applied to elevators and tiles that blow up
- Preparations made for functionality that blinks switch targets when user touches 
  the switch, so he can see beforehand what they are meant for.
  This is almost done, just canceling userinput after this is not working yet.
- Extra level added
- Some code optimizations (eg. Entity class added as base for Hero and Enemy)
- Enemies can now avoid falling off edges
- Enemies can now ride with elevators
- New switch action: Destructible tiles can be converted to deadly tiles
  The old action (change to jump tile) has been removed
- TileDebugging level works for Enemy entities too now, we're gonna use this to 
  solve the tile detection problem for them


### Version: 0.0.2 (2011-03-25)

*Added features:*  
- Tutorial mode fully implemented
- "Loading..." screen partly implemented (on first load it does not show yet…)


### Version: 0.0.1 (2011-03-20)

I've decided to keep track of changes for each version.
Because this is the first release notes version, it will list all (or at least most
currently finished features.
For future release notes only the changes will be documented.

*Game mechanics and features:*  
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
  * drop bomb (drops a bomb and destroys destructible tiles to the immediate left, 
    right and bottom of the player)  
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

  
*Code features:*  
- Constants.h is imported by every source file and contains game parameters and 
  other constant values  
- Helpers.h is imported by Constants.h so is also available from every source file 
  and contains old-C style helper functions and structs that are required by 
  multiple files in the project  
- World.loadLevel and Level.createTilesLayer allow for a callback to be passed as 
  parameter which is called during the loading of game objects to keep the caller 
  informed about the progress  
- CLog() can be used to log method calls (see Helpers.h for extensive explanation)  
- Setting DEBUG_TILE_DETECTION to 1 will enable a special debug level and some 
  alternative methods that will visualize tile detection

