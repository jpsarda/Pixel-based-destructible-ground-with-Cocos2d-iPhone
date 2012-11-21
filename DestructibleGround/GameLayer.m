//
//  GameLayer.m
//  DestructibleGround
//
//  Created by Jean-Philippe SARDA on 11/20/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "GameLayer.h"
#import "CreditsLayer.h"
#import "CCMutableTexture2D.h"


#define GROUND_SCALE 2
#define DRAW_WIDTH 6.5f
#define MINERS_COUNT 20
#define SHOW_DRAWN_GROUND_STRIPES


@interface GameLayer(Private)
-(void)appendNewGround;
-(void)resetGroundColors;
@end

// GameLayer implementation
@implementation GameLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
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
        
        //Enable touches
        self.isTouchEnabled=YES;
        
        grounds=[[NSMutableArray arrayWithCapacity:4] retain];
        miners=[[NSMutableArray arrayWithCapacity:MINERS_COUNT] retain];
        
        [self appendNewGround];
        [self appendNewGround];
        [self appendNewGround];
        [self appendNewGround];
        
#ifdef SHOW_DRAWN_GROUND_STRIPES
        [self resetGroundColors];
#endif
        
        //Add miners
        for (int i=0;i<MINERS_COUNT;i++) {
            CCSprite *miner=[CCSprite spriteWithFile:@"miner.png"];
            miner.position=ccp(20+(size.width-40)*((float)i+1.0f)/((float)(MINERS_COUNT+1)),size.height-60);
            [self addChild:miner];
            [miners addObject:miner];
        }
        
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Dig with your finger" fontName:@"Marker Felt" fontSize:24];
		label.position =  ccp( size.width /2 , size.height-14 );
		[self addChild: label];
        
        
        //Promo Micro Miners :D
        CCSprite *microminersIcon=[CCSprite spriteWithFile:@"info.png"];
        CCSprite *microminersIconSelected=[CCSprite spriteWithFile:@"info.png"];
        microminersIconSelected.color=ccc3(100, 100, 100);
        CCMenuItem *microminersItem=[CCMenuItemSprite itemFromNormalSprite:microminersIcon selectedSprite:microminersIconSelected target:self selector:@selector(info)];
        microminersItem.position=ccp(size.width-microminersItem.contentSize.width*0.5f-4,microminersItem.contentSize.height*0.5f+4);
        CCMenu *menu=[CCMenu menuWithItems:microminersItem, nil];
        menu.position=CGPointZero;
        [self addChild:menu];
        
        lastDigTime=0;
        touchActiveLocationOK=NO;
        
        [self schedule:@selector(tick:)];
	}
	return self;
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc {
    [miners release];
	[grounds release];
	[super dealloc];
}


-(void)appendNewGround {
    CGSize size = [[CCDirector sharedDirector] winSize];
    float y=size.height;
    
    UIImage *image = [UIImage imageNamed:@"ground_vertical.png"];
    CCMutableTexture2D *groundMutableTexture = [[CCMutableTexture2D alloc] initWithImage:image];
    [groundMutableTexture setAliasTexParameters];
    CCSprite *groundSprite = [CCSprite spriteWithTexture:groundMutableTexture];
    groundSprite.scale=GROUND_SCALE;
    if (grounds.count!=0) {
        y=((CCSprite*)([grounds lastObject])).position.y-groundSprite.contentSize.height*groundSprite.scaleY;
    } else {
        y-=groundSprite.contentSize.height*groundSprite.scaleY*0.5f;
    }
    groundSprite.position=ccp(size.width*0.5f,y);
    [self addChild:groundSprite];
    [grounds addObject:groundSprite];
    
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"grounds [ %d ]",grounds.count-1] fontName:@"Marker Felt" fontSize:13];
    label.rotation=90;
    label.position =  ccp( label.contentSize.height*0.5f +2, groundSprite.position.y);
    [self addChild: label];
}





-(void)tick:(ccTime)dt {
    CGSize size = [[CCDirector sharedDirector] winSize];
    for (int i=0;i<miners.count;i++) {
        CCSprite *miner=[miners objectAtIndex:i];
        
        CGPoint minerPosition=miner.position;
        minerPosition.y-=2;
        
        //Check if hits the ground
        
        CCSprite *sprite=[grounds objectAtIndex:0];
        
        //Found corresponding stripe of ground
        float groundHeight=sprite.contentSize.height*sprite.scaleY;
        int idxGround=(size.height - minerPosition.y)/groundHeight;
        if ((idxGround>=0)&&(idxGround<grounds.count)) {
            sprite=[grounds objectAtIndex:idxGround];
            CCMutableTexture2D* groundMutableTexture=(CCMutableTexture2D*)(sprite.texture);
            //Transform real world position into texture position
            // Top border of the texture y = sprite.position.y+groundHeight*0.5f
            ccColor4B pixel = [groundMutableTexture pixelAt:ccp((int)(minerPosition.x/GROUND_SCALE),(int)( ((sprite.position.y+groundHeight*0.5f)-minerPosition.y)/GROUND_SCALE ))];
            
            if (pixel.a==0) {
                //No hit, we update the miners position
                miner.position=minerPosition;
            }
        }
    }
}





- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch=[touches anyObject];
    currentColor=ccc4(0,0,0,0); //Transparent >> Draw holes (dig)
	CGPoint touchLocation = [touch locationInView:nil];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];

	activeLocation=touchLocation;
    touchActiveLocationOK=YES;
}
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch;
	NSArray *allTouches = [[event allTouches] allObjects];

	double now=[NSDate timeIntervalSinceReferenceDate];
    //Draw only every 0.05 seconds to preserve the perfs
	if (now-lastDigTime>0.05f) {
		touch=[touches anyObject];
        
		CGPoint touchLocation = [touch locationInView:nil];
		touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
        
        if (touchActiveLocationOK) {
            [self fingerAction:activeLocation :touchLocation];
            lastDigTime=now;
		}
		activeLocation=touchLocation;
        touchActiveLocationOK=YES;
	}
}

-(void) resetGroundColors {
    for (int i=0; i<grounds.count; i++) {
        CCSprite *sprite=[grounds objectAtIndex:i];
        if (i%2==0) {
            sprite.color=ccc3(255, 210, 230);
        } else {
            sprite.color=ccc3(255, 230, 210);
        }
    }
}

-(void)fingerAction:(CGPoint)p0 :(CGPoint)p1 {
    CCSprite *sprite=[grounds objectAtIndex:0];
    
    //Find which stripes of ground are invovled
    float maxY,minY;
    
    if (p1.y<p0.y) {
        minY=p1.y-(int)(DRAW_WIDTH*GROUND_SCALE+0.5f);
        maxY=p0.y+(int)(DRAW_WIDTH*GROUND_SCALE+0.5f);
    } else {
        minY=p0.y-(int)(DRAW_WIDTH*GROUND_SCALE+0.5f);
        maxY=p1.y+(int)(DRAW_WIDTH*GROUND_SCALE+0.5f);
    }
    
    float groundHeight=sprite.contentSize.height*sprite.scaleY;
    float offsetMin=(sprite.position.y+groundHeight/2)-minY;
    int idxMin=offsetMin/groundHeight;
    if (idxMin<0) idxMin=0;
    if (idxMin>=grounds.count) idxMin=grounds.count-1;
    
    float offsetMax=(sprite.position.y+groundHeight/2)-maxY;
    int idxMax=offsetMax/groundHeight;
    if (idxMax<0) idxMax=0;
    if (idxMax>=grounds.count) idxMax=grounds.count-1;
    
    
    //This for a visual representation of impacted grounds
#ifdef SHOW_DRAWN_GROUND_STRIPES
    [self resetGroundColors];
#endif
    
    for (int i=idxMax; i<=idxMin; i++) {
        sprite=[grounds objectAtIndex:i];
        
#ifdef SHOW_DRAWN_GROUND_STRIPES
        if (i%2==0) {
            sprite.color=ccc3(255, 110, 130);
        } else {
            sprite.color=ccc3(255, 130, 110);
        }
#endif
        
        CGPoint local=ccp(p1.x/GROUND_SCALE,(p1.y-sprite.position.y)/GROUND_SCALE+sprite.contentSize.height/2);
        local.y=sprite.contentSize.height-local.y;
        
        CGPoint activeLocal=ccp(p0.x/GROUND_SCALE,(p0.y-sprite.position.y)/GROUND_SCALE+sprite.contentSize.height/2);
        activeLocal.y=sprite.contentSize.height-activeLocal.y;
        
        CCMutableTexture2D* groundMutableTexture=(CCMutableTexture2D*)(sprite.texture);
        [groundMutableTexture drawLineFrom:activeLocal to:local withLineWidth:DRAW_WIDTH andColor:currentColor];
        [groundMutableTexture apply]; //Redraw texture
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
#ifdef SHOW_DRAWN_GROUND_STRIPES
    [self resetGroundColors];
#endif
}
- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self ccTouchesEnded:touches withEvent:event];
}

-(void)info {
    [[CCDirector sharedDirector] replaceScene:[CreditsLayer scene]];
}
@end
