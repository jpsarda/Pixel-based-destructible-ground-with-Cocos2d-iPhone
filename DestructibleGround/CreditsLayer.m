//
//  CreditsLayer.m
//  DestructibleGround
//
//  Created by Jean-Philippe SARDA on 11/20/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "CreditsLayer.h"
#import "GameLayer.h"
#import "CCMutableTexture2D.h"


// CreditsLayer implementation
@implementation CreditsLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CreditsLayer *layer = [CreditsLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        // ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF *label;
        CCSprite *button;
        CCSprite *buttonSelected;
        
        //Promo Micro Miners :D
        
        float y=size.height; //Top of the screen
        
        

        label= [CCLabelTTF labelWithString:@"This project is part of a technical post on cocos2d blog. It's intended to be a starting point, it's not a full destructible ground engine. It's based on the engine used in the iOS game Micro Miners by @jpsarda. All links below." dimensions:CGSizeMake(size.width-10, 100) alignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeWordWrap fontName:@"Marker Felt" fontSize:15];
        y-=label.contentSize.height*0.5f;
		label.position =  ccp( size.width*0.5f , y  );
		[self addChild: label];
        y-=label.contentSize.height*0.5f;
        y-=10;

        
        
        
        button=[CCSprite spriteWithFile:@"microminers.png"];
        buttonSelected=[CCSprite spriteWithFile:@"microminers.png"];
        buttonSelected.color=ccc3(100, 100, 100);
        CCMenuItem *microminersItem=[CCMenuItemSprite itemFromNormalSprite:button selectedSprite:buttonSelected target:self selector:@selector(goAppstore)];
        y-=microminersItem.contentSize.height*0.5f;
        
        microminersItem.position=ccp(4+microminersItem.contentSize.width*0.5f,y);
        
        label = [CCLabelTTF labelWithString:@"Micro Miners on the appstore" fontName:@"Marker Felt" fontSize:15];
		label.position =  ccp( microminersItem.position.x + microminersItem.contentSize.width*0.5f + 4 + label.contentSize.width*0.5f , y  );
		[self addChild: label];
        y-=microminersItem.contentSize.height*0.5f;
        y-=10;
        
        
        
        
        
        button=[CCSprite spriteWithFile:@"twitter.png"];
        buttonSelected=[CCSprite spriteWithFile:@"twitter.png"];
        buttonSelected.color=ccc3(100, 100, 100);
        CCMenuItem *twitterItem=[CCMenuItemSprite itemFromNormalSprite:button selectedSprite:buttonSelected target:self selector:@selector(goTwitter)];
        y-=twitterItem.contentSize.height*0.5f;
        
        twitterItem.position=ccp(4+twitterItem.contentSize.width*0.5f,y);
        
        label = [CCLabelTTF labelWithString:@"@jpsarda on twitter" fontName:@"Marker Felt" fontSize:15];
		label.position =  ccp( twitterItem.position.x + twitterItem.contentSize.width*0.5f + 4 + label.contentSize.width*0.5f , y  );
		[self addChild: label];
        y-=twitterItem.contentSize.height*0.5f;
        y-=10;
        
        
        
        button=[CCSprite spriteWithFile:@"Icon.png"];
        buttonSelected=[CCSprite spriteWithFile:@"Icon.png"];
        buttonSelected.color=ccc3(100, 100, 100);
        CCMenuItem *blogItem=[CCMenuItemSprite itemFromNormalSprite:button selectedSprite:buttonSelected target:self selector:@selector(goBlog)];
        blogItem.scale=64.0f/blogItem.contentSize.width;
        y-=blogItem.contentSize.height*blogItem.scaleY*0.5f;
        
        blogItem.position=ccp(4+blogItem.contentSize.width*blogItem.scaleX*0.5f,y);
        
        label = [CCLabelTTF labelWithString:@"Article on cocos2d blog" fontName:@"Marker Felt" fontSize:15];
		label.position =  ccp( blogItem.position.x + blogItem.contentSize.width*blogItem.scaleX*0.5f + 4 + label.contentSize.width*0.5f , y  );
		[self addChild: label];
        y-=blogItem.contentSize.height*blogItem.scaleY*0.5f;
        y-=10;
        
        
        
        
        
        
        button=[CCSprite spriteWithFile:@"back.png"];
        buttonSelected=[CCSprite spriteWithFile:@"back.png"];
        buttonSelected.color=ccc3(100, 100, 100);
        CCMenuItem *backItem=[CCMenuItemSprite itemFromNormalSprite:button selectedSprite:buttonSelected target:self selector:@selector(goBack)];
        backItem.scale=64.0f/backItem.contentSize.width;
        backItem.position=ccp(size.width-backItem.contentSize.width*backItem.scaleX*0.5f-4,backItem.contentSize.height*backItem.scaleY*0.5f+4);
        
        
        
        
        CCMenu *menu=[CCMenu menuWithItems:microminersItem, twitterItem, blogItem, backItem, nil];
        menu.position=CGPointZero;
        [self addChild:menu];
	}
	return self;
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc {
	[super dealloc];
}

-(void)goTwitter {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/jpsarda"]];
}
-(void)goAppstore {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/micro-miners/id413240207?mt=8"]];
}
-(void)goBlog {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.cocos2d-iphone.org/archives/2113"]];
}
-(void)goBack {
    [[CCDirector sharedDirector] replaceScene:[GameLayer scene]];
}
@end
