//
//  GLESGameState.m
//  BomberBilly
//
//  Initially created by Joe Hogue and Paul Zirkle
//  Rewritten by Ruud van Falier on 2/14/11.
//

#import "GLESGameState.h"
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>
#import "ResourceManager.h"

// Primary context for all OpenGL calls.  Set in setup2D, should be cleared in teardown.
EAGLContext* glesContext;
GLuint glesFrameBuffer;
GLuint glesRenderBuffer;

@implementation GLESGameState

// Override UIView's layerClass method so it returns the right class for OpenGL ES to draw to
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

-(id) initWithFrame:(CGRect)frame andManager:(GameStateManager*)pManager;
{
	CLog();
    if (self = [super initWithFrame:frame andManager:pManager]) {
		// Tells the glesContext that we have a new layer to render to
		[self bindLayer];
    }
    return self;
}

// Initialize is called automatically before the class gets any other message ( http://stackoverflow.com/questions/145154/what-does-your-objective-c-singleton-look-like )
+ (void)initialize {
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
		[GLESGameState setup2D];
    }
}


// Initialize opengles, and set up the camera for 2d rendering.  
// This should be called before any other opengl calls.
+ (void) setup2D 
{
	CLog();
	
	// Create and set the gles context.  All opengl calls are done relative to a context, 
	// so it is important to set the context before anything else.  
	glesContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	[EAGLContext setCurrentContext:glesContext];
	
	glGenRenderbuffersOES(1, &glesRenderBuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, glesRenderBuffer);
	
	glGenFramebuffersOES(1, &glesFrameBuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, glesFrameBuffer);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, glesRenderBuffer);
	
	// Initialize OpenGL states
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND); // Most 2d games will want alpha-blending on by default.
	glEnable(GL_TEXTURE_2D);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	// TODO (joe): this was originally done in bindToState, since that is where we would get sizing information.
	// But I couldn't get it to work right when switching between states; I think it messed up the camera.  
	// So it's here for now. 
	CGSize newSize = CGSizeMake(SCREEN_WIDTH * SCREEN_SCALE, SCREEN_HEIGHT * SCREEN_SCALE);
	newSize.width = roundf(newSize.width);
	newSize.height = roundf(newSize.height);
	
	glViewport(0, 0, newSize.width, newSize.height);
	glScissor(0, 0, newSize.width, newSize.height);
	
	// Set up OpenGL projection matrix
	glMatrixMode(GL_PROJECTION);
	glOrthof(0, newSize.width, 0, newSize.height, -1, 1);
	glMatrixMode(GL_MODELVIEW);
}


// Set our opengl context's output to the underlying gl layer of this gamestate.
// This should be called during the construction of any state that wants to do opengl rendering.
// Only the most recent caller will get opengl rendering.
- (BOOL) bindLayer 
{
	CLog();
	CAEAGLLayer* eaglLayer = (CAEAGLLayer*)[self layer];
	
	// Set up a few drawing properties.  
	// The app will run and display without this line, but the properties here should make it go faster.
	[eaglLayer setDrawableProperties:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat, nil]];
	
	if(![EAGLContext setCurrentContext:glesContext]) {
		return NO;
	}
	
	// Disconnect any existing render storage.  Has no effect if there is no existing storage.
	// I have no idea if this leaks.  I'm pretty sure that this class shouldn't be responsible for
	// freeing the previous eaglLayer, as that should be handled by the view which contains that layer.
	[glesContext renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:nil];
	
	// Connect our renderbuffer to the eaglLayer's storage.  This allows our opengl stuff to be drawn to
	// the presented layer (and thus, the screen) when presentRenderbuffer is called.
	if(![glesContext renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:eaglLayer]) 
	{
		NSLog(@"Failed to bind layer to glesContext");
		glDeleteRenderbuffersOES(1, &glesRenderBuffer);
		return NO;
	}

	return YES;
}


// Finish opengl calls and send the results to the screen.  
// Should be called to end the rendering of a frame.
- (void) swapBuffers 
{
	CLogGL();
	
	if ([EAGLContext currentContext] != glesContext) {
		[EAGLContext setCurrentContext:glesContext];
	}
	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, glesRenderBuffer);
	glFinish();

	if(![glesContext presentRenderbuffer:GL_RENDERBUFFER_OES]) {
		printf("Failed to swap renderbuffer in %s\n", __FUNCTION__);
	}
}

-(void) teardown {
	CLog();
	[glesContext release];
}

@end
