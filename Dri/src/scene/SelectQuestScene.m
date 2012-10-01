//
//  SelectQuestScene.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "SelectQuestScene.h"
#import "DungeonScene.h"
#import "HomeScene.h"
#import "DungeonPreloadScene.h"

@implementation SelectQuestScene

- (id)init
{
    if( (self=[super init]) ) {
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"SELECTQUEST" fontName:DL_FONT_NAME fontSize:20];
        label.position =  ccp(160, 440);
        [self addChild:label];

        // enable touch
        self.isTouchEnabled = YES;

        // IMPLEMENT:
        CCSprite *town_banner = [CCSprite spriteWithFile:@"guild000.png"];
        town_banner.position = ccp(160, 390);
        [self addChild:town_banner];
        
        CCMenuItemFont *item_quest_1 = [CCMenuItemFont itemWithString:@"QUEST<1>" target:self selector:@selector(didPressButton:)];
        CCMenuItemFont *item_quest_2 = [CCMenuItemFont itemWithString:@"QUEST<2>" target:self selector:@selector(didPressButton:)];
        CCMenuItemFont *item_quest_3 = [CCMenuItemFont itemWithString:@"QUEST<3>" target:self selector:@selector(didPressButton:)];
        CCMenuItemFont *item_home    = [CCMenuItemFont itemWithString:@"HOME" target:self selector:@selector(didPressButtonHome:)];
        CCMenu *menu = [CCMenu menuWithItems:
                        item_quest_1,
                        item_quest_2,
                        item_quest_3,
                        item_home,
                        nil];
        menu.position = ccp(160, 200);
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    // IMPLEMENT:
    // EXAMPLE:
    // [[CCDirector sharedDirector] replaceScene:[DungeonScene scene]];
}

- (void)didPressButton:(CCMenuItem *)sender
{
    CCScene *scene = [DungeonPreloadScene scene];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)didPressButtonHome:(CCMenuItem *)sender
{
    CCScene *scene = [HomeScene scene];
    [[CCDirector sharedDirector] replaceScene:scene];    
}

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [SelectQuestScene node];
    [scene addChild:layer];
    return scene;
}

@end

