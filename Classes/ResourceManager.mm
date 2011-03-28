//
//  ResourceManager.m
//  BomberBilly
//
//  Created by Ruud van Falier on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResourceManager.h"
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>
#import "BomberBillyAppDelegate.h"
#import "GameStateMain.h"
#import "GameStateGameOver.h"

ResourceManager* resManager;

@implementation ResourceManager

@synthesize textures;
@synthesize configuration;
@synthesize fontDebugData;
@synthesize fontMessage;


#pragma mark -
#pragma mark ResourceManager initialization

// Initialize is called automatically before the class gets any other message ( http://stackoverflow.com/questions/145154/what-does-your-objective-c-singleton-look-like )
+ (void) initialize
{
	CLog();
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
        resManager = [[ResourceManager alloc] init];
    }
}


+ (ResourceManager*) instance
{
	return resManager;
}


- (ResourceManager*) init
{
	CLog();
	[super init];
	
	self.textures = [NSMutableDictionary dictionary];
	self.configuration = [NSMutableDictionary dictionary];
	
	return self;
}


- (void) shutdown
{
	CLog();
	[textures removeAllObjects];
	[configuration removeAllObjects];
	[fontDebugData release];
	[fontMessage release];
}


#pragma mark -
#pragma mark Resource helper methods

- (NSDictionary*) loadConfigSection:(NSString*)configSection
{
	CLog();
	
	// Check if config section was resolved before
	NSDictionary* result = [self.configuration valueForKey:configSection];
	if (result != nil) {
		return result;
	}
	
	// Load config section, buffer and return it
	NSString* error;
	NSPropertyListFormat format;
	
	NSString* pListFilePath = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
	NSData* pList = [NSData dataWithContentsOfFile:pListFilePath];
	
	result = [NSPropertyListSerialization propertyListFromData:pList 
											  mutabilityOption:NSPropertyListImmutable 
														format:&format 
											  errorDescription:&error];
	
	result = [result objectForKey:configSection];
	
	// Note: setValue method does NOT retain the object
	[self.configuration setValue:[result retain] forKey:configSection];
	
	return result;
}


// Creates and returns a texture for the given image file.
// The texture is buffered, so the first call to getTexture will create the texture, 
// and subsequent calls will simply return the same texture object.
- (GLTexture*) getTexture:(NSString*)filename
{
	GLTexture* result = [self.textures valueForKey:filename];
	if (result != nil) {
		return result;
	}

	// Texture was not buffered. Load it from disk
	NSString* fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
	UIImage* loadImage = [UIImage imageWithContentsOfFile:fullpath];
	result = [[GLTexture alloc] initWithImage:loadImage];
	[self.textures setValue:[result retain] forKey:filename];
	
	return result;
}


#pragma mark -
#pragma mark Font initialisation

- (GLFont*) fontDebugData 
{
	if (fontDebugData == nil) 
	{
		fontDebugData = [[GLFont alloc]	initWithString:FONT_ALLOCATION_CHARS fontName:FONT_DEFAULT_NAME 
										fontSize:11.0f strokeWidth:0.0f fillColor:[UIColor whiteColor] strokeColor:nil];
		[fontDebugData retain];
	}
	return fontDebugData;
}


- (GLFont*) fontMessage
{
	if (fontMessage == nil) 
	{
		fontMessage = [[GLFont alloc] initWithString:FONT_ALLOCATION_CHARS fontName:FONT_DEFAULT_NAME 
									  fontSize:21.0f strokeWidth:0 fillColor:[UIColor whiteColor] strokeColor:nil];
		[fontMessage retain];
	}
	return fontMessage;
}

- (GLFont*) fontGameInfo
{
	if (fontGameInfo == nil) 
	{
		fontGameInfo = [[GLFont alloc] initWithString:FONT_ALLOCATION_CHARS fontName:FONT_DEFAULT_NAME 
											fontSize:16.0f strokeWidth:0 fillColor:[UIColor blackColor] strokeColor:nil];
		[fontGameInfo retain];
	}
	return fontGameInfo;
}

@end
