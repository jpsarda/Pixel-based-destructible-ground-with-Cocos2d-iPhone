///
//	CCMutableTexture2D extends cocos2D CCTexture2D
//	Created by Lam Hoang Pham.
//
//	Allows for modifications of the texture data. If you load PVR's then you are
//	out of luck. Supported pixelFormats will allow access to bitmap data.
//
//	Support for RGBA_4_4_4_4 and RGBA_5_5_5_1 was copied from:
//	https://devforums.apple.com/message/37855#37855 by a1studmuffin
//
///

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import "cocos2d.h"


#define CCMUTABLETEXTURE2D_LINE_POLY_COUNT 10


@interface CCMutableTexture2D : CCTexture2D
{	
	void	*data_;
	bool	dirty_;
	NSLock	*contextLock_;
	
	//Acceleration vars
	uint* pixelUint;
	GLushort* pixelGLushort;
	GLubyte* pixelGLubyte;
	uint colorUint;
	GLushort colorGLushort;
	GLubyte colorGLubyte;
	CGPoint *poly;
}
@property (readonly) CGPoint *poly;
//	Returns the maximum allowed texture size
+ (int) maxTextureSize;
@end

@interface CCMutableTexture2D(Image)
///
//	Create a texture with an image
///
+ (id) textureWithImage:(UIImage*) image;
- (id) initWithImage:(UIImage*) image;
@end

@interface CCMutableTexture2D(CCTexture2D)
///
//	Create a texture with a CCTexture2D
///
+ (id) textureWithTexture2D:(CCTexture2D*) tex;
- (id) initWithTexture2D:(CCTexture2D*) tex;
@end

@interface CCMutableTexture2D (MutableTexture)
///
//	Create a blank texture with canvas size and default pixel format
///
+ (id) textureWithSize:(CGSize) size;

///
//	Create a blank texture with canvas size and chosen pixel format
///
+ (id) textureWithSize:(CGSize) size pixelFormat:(CCTexture2DPixelFormat) pixelFormat;

///
//	Create a blank texture with canvas size and default pixel format
///
- (id) initWithSize:(CGSize) size pixelFormat:(CCTexture2DPixelFormat) pixelFormat;

///
//	@param pt is a point to get a pixel (0,0) is top-left to (width,height) bottom-right
//	@returns a ccColor4B which is a colour, otherwise it returns Texture2DPixelClear
///
- (ccColor4B) pixelAt:(CGPoint) pt;

///
//	@param pt is a point to get a pixel (0,0) is top-left to (width,height) bottom-right
//	@param c is a ccColor4B which is a colour.
//	Remember to call apply to actually update the texture canvas.
///
- (BOOL) setPixelAt:(CGPoint) pt rgba:(ccColor4B) c;

///
//	Fill with specified colour
///
- (void) fill:(ccColor4B) c;

///
//	Fill a polygon (n points) with specified colour
///
- (void) fillConvexPolygon:(CGPoint*)p :(int)n withColor:(ccColor4B)c;

///
//	Draw an horizontal line
///
- (void) drawHorizontalLine:(float)x0 :(float)x1 :(float)yF withColor:(ccColor4B)c;

///
//	Draw a line with width (not optimized for a 1 pixel width line)
///
-(void) drawLineFrom:(CGPoint)p0 to:(CGPoint)p1 withLineWidth:(float)w andColor:(ccColor4B) c;


///
//	Apply actually updates the texture with any new data we added.
//	If you never call apply then you will never see the texture update but don't
//	call this method too much. Use it sparingly since you can always set a number of pixels
//	before ever needing to apply it.
///
- (Boolean) apply;

///
//	apply actually could slow down app a bit so asynch might have better visual performance
//	Once the apply has finished, it will execute the callback.
//	@param target the address to call the selector
//	@param callbackSel the selector to use
///
- (void) applyAsyncWithCallback:(id) target selector:(SEL) callbackSel;
@end


#ifdef __cplusplus
extern "C" {
#endif	

///
//	Fast find for powers of 2
///
bool IsPow2(uint v);

///
//	Fast round to nearest power of 2 for 32-bit int's.
///
uint RoundToNearestPow2(uint v);
	
#ifdef __cplusplus
}
#endif
