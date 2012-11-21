//
//  GameLayer.h
//  DestructibleGround
//
//  Created by Jean-Philippe SARDA on 11/20/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// GameLayer
@interface GameLayer : CCLayer
{
    NSMutableArray *grounds,*miners;
    CGPoint activeLocation;
    BOOL touchActiveLocationOK;
    ccColor4B currentColor;
    double lastDigTime;
}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

@end

