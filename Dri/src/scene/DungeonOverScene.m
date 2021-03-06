//
//  DungeonResultScene.m
//  Dri
//
//  Created by  on 12/08/29.
//  Copyright 2012 Hiromitsu. All rights reserved.
//

#import "DungeonOverScene.h"
#import "CCBReader.h"

@implementation DungeonOverScene

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	CCLayer *layer = [DungeonOverScene node];
	[scene addChild:layer];
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init]) ) {
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"GAMEOVER" fontName:DL_FONT_NAME fontSize:20];
        label.position =  ccp(160, 440);
        [self addChild:label];
        
		// enable touch
        self.isTouchEnabled = YES;
	}
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
//    [[CCDirector sharedDirector] replaceScene:[HomeScene scene]];
//    [[CCDirector sharedDirector] replaceScene:[SelectQuestScene scene]];
    CCScene *nextScene = [CCBReader sceneWithNodeGraphFromFile:@"select_quest.ccbi"];
    [[CCDirector sharedDirector] replaceScene:nextScene];
}

@end
