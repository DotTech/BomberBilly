//
//  Sprite.h
//  BomberBilly
//
//  Created by Ruud van Falier on 2/15/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animation.h"
#import "Constants.h"

@interface Sprite : NSObject {
	Animation* animation;
	float lastUpdateTime;
	int x;
	int y;
	BOOL flipped;
	BOOL offScreen;
}

@property (nonatomic, retain) Animation* animation;
@property int x;
@property int y;
@property BOOL flipped;
@property BOOL offScreen;

// Location of sprite in the world tilesLayer array
@property (readonly) int dataRow;
@property (readonly) int dataColumn;
@property (readonly) int dataColumnMin;
@property (readonly) int dataColumnMax;

- (Sprite*) initSprite:(NSString*)spriteName;
- (CGRect) getCurrentFrame;
- (void) draw;
- (void) drawAtPoint:(CGPoint)point;
- (void) update:(float)gameTime;

@end
