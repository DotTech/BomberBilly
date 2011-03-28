//
//  GLESGameState.h
//  BomberBilly
//
//  Created by Ruud van Falier on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "ResourceManager.h"

#import "GameState.h"
//#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>

@interface GLESGameState : GameState {
	EAGLContext* glesContext;
	GLuint glesFrameBuffer;
	GLuint glesRenderBuffer;
}

@property (nonatomic, retain) EAGLContext* glesContext;

- (id) initWithFrame:(CGRect)frame andManager:(GameStateManager*)pManager;
- (void) swapBuffers;
- (BOOL) bindLayer;
- (void) setup2D;
- (void) killContext;

@end
