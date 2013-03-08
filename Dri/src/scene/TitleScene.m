//
//  TtileScene.m
//  Dri
//
//  Created by  on 13/03/07.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "TitleScene.h"
#import "FontFactory.h"
#import "SelectQuestScene.h"

@implementation TitleScene

-(id) init
{
	if( (self=[super init]) ) {
        
        self.isTouchEnabled = YES;

        CCSprite *title = [CCSprite spriteWithFile:@"title.png"];
        title.position = ccp(160, 240);
        [self addChild:title];
        
        CCLabelBMFont *hp = [FontFactory makeLabel:@"START"];
//        hp.anchorPoint = ccp(0, 0);
        hp.position = ccp(160, 100);
        hp.scale = 1.0;
        [self addChild:hp];
    }
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [[CCDirector sharedDirector] replaceScene:[SelectQuestScene scene]];
}

+(CCScene*)scene {
	CCScene *scene = [CCScene node];
	CCLayer *layer = [TitleScene node];
	[scene addChild: layer];
	return scene;
}

@end
