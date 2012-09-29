//
//  ResourceManager.h
//  BomberBilly
//
//  Created by Ruud van Falier on 2/14/11.
//  Copyright 2011 DotTech. All rights reserved.
//

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <Foundation/Foundation.h>
#import "Constants.h"
#import "GLTexture.h"
#import "GLFont.h"

@class ResourceManager;
extern ResourceManager* resManager;

@interface ResourceManager : NSObject
{
@private
    GLFont* fontDebugData;
    GLFont* fontMessage;
    GLFont* fontGameInfo;
}

@property (nonatomic, retain) NSMutableDictionary* textures;
@property (nonatomic, retain) NSMutableDictionary* configuration;
@property (readonly) GLFont* fontDebugData;
@property (readonly) GLFont* fontMessage;
@property (readonly) GLFont* fontGameInfo;

+ (ResourceManager*) instance;
- (void) shutdown;
- (NSDictionary*) loadConfigSection:(NSString*)configSection;
- (GLTexture*) getTexture:(NSString*)filename;

@end
