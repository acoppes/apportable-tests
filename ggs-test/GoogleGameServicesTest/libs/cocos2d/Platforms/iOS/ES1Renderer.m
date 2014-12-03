/*
* cocos2d for iPhone: http://www.cocos2d-iphone.org
*
* Copyright (c) 2010 Ricardo Quesada
* Copyright (c) 2011 Zynga Inc.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
*
* File autogenerated with Xcode. Adapted for cocos2d needs.
*/

// Only compile this code on iOS. These files should NOT be included on your Mac project.
// But in case they are included, it won't be compiled.
#import <Availability.h>
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

#import "ES1Renderer.h"
#import "../../Support/OpenGL_Internal.h"
#import "../../ccMacros.h"


@interface ES1Renderer (private)

- (GLenum) convertPixelFormat:(int) pixelFormat;

@end

@implementation ES1Renderer

@synthesize context=context_;

- (id) initWithDepthFormat:(unsigned int)depthFormat withPixelFormat:(unsigned int)pixelFormat withSharegroup:(EAGLSharegroup*)sharegroup withMultiSampling:(BOOL) multiSampling withNumberOfSamples:(unsigned int) requestedSamples
{
    if ((self = [super init]))
    {
		if ( sharegroup == nil )
		{
			context_ = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		}
		else
		{
			context_ = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1 sharegroup:sharegroup];
		}
		
		if (!context_ || ![EAGLContext setCurrentContext:context_])
		{
			[self release];
			return nil;
		}
		
		backingWidth_ = backingHeight_ = 0;
		depthBuffer_ = colorRenderBuffer_ = defaultFrameBuffer_ = msaaColorBuffer_ = msaaFrameBuffer_ = 0;
		
		depthFormat_ = depthFormat;
		
		pixelFormat_ = pixelFormat;
		multiSampling_ = multiSampling;

		if (multiSampling_)
		{
			GLint maxSamplesAllowed;
			glGetIntegerv(GL_MAX_SAMPLES_APPLE, &maxSamplesAllowed);
			samplesToUse_ = MIN(maxSamplesAllowed,requestedSamples);
		}
		
		//[self createFrameBuffer:(CAEAGLLayer*) self.layer];
    }

    return self;
}

- (void) destroyFrameBuffer
{
// Tear down GL
    if(defaultFrameBuffer_)
    {
        glDeleteFramebuffersOES(1, &defaultFrameBuffer_);
        defaultFrameBuffer_ = 0;
    }

    if(colorRenderBuffer_)
    {
        glDeleteRenderbuffersOES(1, &colorRenderBuffer_);
        colorRenderBuffer_ = 0;
    }

	if( depthBuffer_ )
	{
		glDeleteRenderbuffersOES(1, &depthBuffer_);
		depthBuffer_ = 0;
	}
	
	if ( msaaColorBuffer_)
	{
		glDeleteRenderbuffersOES(1, &msaaColorBuffer_);
		msaaColorBuffer_ = 0;
	}
	
	if ( msaaFrameBuffer_)
	{
		glDeleteRenderbuffersOES(1, &msaaFrameBuffer_);
		msaaFrameBuffer_ = 0;
	}
}

- (void) createFrameBuffer:(CAEAGLLayer *)layer
{
#ifdef APPORTABLE
    CCLOG(@"cocos2d - APPORTABLE - createFrameBuffer disabled by Apportable.");
    return;
#endif
	glGenFramebuffersOES(1, &defaultFrameBuffer_);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFrameBuffer_);
	
	NSAssert( defaultFrameBuffer_, @"Can't create default frame buffer");
	
	glGenRenderbuffersOES(1, &colorRenderBuffer_);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderBuffer_);
	
	NSAssert( colorRenderBuffer_, @"Can't create default render buffer");

	
	
	// Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
	if (![context_ renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer])
	{
		CCLOG(@"failed to call context");
	}
	
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderBuffer_);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth_);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight_);
	
	if (multiSampling_)
	{
		/* Create the offscreen MSAA color buffer.
		After rendering, the contents of this will be blitted into ColorRenderbuffer */
		
		glGenFramebuffersOES(1, &msaaFrameBuffer_);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, msaaFrameBuffer_);
		
		glGenRenderbuffersOES(1, &msaaColorBuffer_);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, msaaColorBuffer_);
		
		glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER_OES, samplesToUse_,pixelFormat_ , backingWidth_, backingHeight_);
		
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, msaaColorBuffer_);
		
		if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
			CCLOG(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
	}

	if (depthFormat_)
	{
		glGenRenderbuffersOES(1, &depthBuffer_);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthBuffer_);
	
		if( multiSampling_ )
			glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER_OES, samplesToUse_, depthFormat_,backingWidth_, backingHeight_);
		else
			glRenderbufferStorageOES(GL_RENDERBUFFER_OES, depthFormat_, backingWidth_, backingHeight_);
		
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthBuffer_);
		
		// bind color buffer
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderBuffer_);
		
	}

	glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFrameBuffer_);

	if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
		CCLOG(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));

	CHECK_GL_ERROR();
}

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer
{
	//issue #1254, destroy and recreate OpenGL buffers completely
	if (colorRenderBuffer_)
	{
		[self destroyFrameBuffer];
		[self createFrameBuffer:layer];

		CCLOG(@"cocos2d: surface size: %dx%d, resizing buffers", (int)backingWidth_, (int)backingHeight_);
	}
	else
	{//first time
		[self createFrameBuffer:layer];
		CCLOG(@"cocos2d: surface size: %dx%d", (int)backingWidth_, (int)backingHeight_);
	}

	return YES;
}

-(CGSize) backingSize
{
	return CGSizeMake( backingWidth_, backingHeight_);
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %@ | size = %ix%i>", [self class], self, backingWidth_, backingHeight_];
}


- (void)dealloc
{
	CCLOGINFO(@"cocos2d: deallocing %@", self);

    [self destroyFrameBuffer];

    // Tear down context
    if ([EAGLContext currentContext] == context_)
        [EAGLContext setCurrentContext:nil];

    [context_ release];
    context_ = nil;

    [super dealloc];
}

- (unsigned int) colorRenderBuffer
{
	return colorRenderBuffer_;
}

- (unsigned int) defaultFrameBuffer
{
	return defaultFrameBuffer_;
}

- (unsigned int) msaaFrameBuffer
{
	return msaaFrameBuffer_;
}

- (unsigned int) msaaColorBuffer
{
	return msaaColorBuffer_;
}

@end

#endif // __IPHONE_OS_VERSION_MAX_ALLOWED