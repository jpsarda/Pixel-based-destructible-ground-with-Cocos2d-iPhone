//
//  AsyncObject.m
//  PixelPile
//
//  Created by Lam Pham on 1/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AsyncObject.h"

@implementation AsyncObject
@synthesize selector = selector_;
@synthesize target = target_;
@synthesize data = data_;
- (void) dealloc
{
	[target_ release];
	[data_ release];
	[super dealloc];
}
@end

