//
//  HomeScene.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "HomeScene.h"
#import "DungeonScene.h"
#import "SelectQuestScene.h"

@implementation HomeScene

- (id)init
{
    if( (self=[super init]) ) {
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"HOME" fontName:DL_FONT_NAME fontSize:20];
        label.position = ccp(160, 440);
        [self addChild:label];

        // enable touch
        self.isTouchEnabled = YES;

        // IMPLEMENT:
        CCSprite *town_banner = [CCSprite spriteWithFile:@"town000.png"];
        town_banner.position = ccp(160, 390);
        [self addChild:town_banner];
        
        
        CCMenuItemFont *item_quest = [CCMenuItemFont itemWithString:@"QUEST" target:self selector:@selector(didPressButton:)];
        CCMenuItemFont *item_item = [CCMenuItemFont itemWithString:@"ITEM" target:self selector:@selector(didPressButton_null:)];
        CCMenuItemFont *item_mail = [CCMenuItemFont itemWithString:@"MAIL" target:self selector:@selector(didPressButton_null:)];
        CCMenuItemFont *item_status = [CCMenuItemFont itemWithString:@"STATUS" target:self selector:@selector(didPressButton_null:)];
        CCMenuItemFont *item_info = [CCMenuItemFont itemWithString:@"INFO" target:self selector:@selector(didPressButton_null:)];
        CCMenuItemFont *item_config = [CCMenuItemFont itemWithString:@"CONFIG" target:self selector:@selector(didPressButton_null:)];
        
        CCMenu *menu = [CCMenu menuWithItems:
                        item_quest,
                        item_item,
                        item_mail,
                        item_status,
                        item_info,
                        item_config,
                        nil];
        menu.position = ccp(160, 160);
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    // IMPLEMENT:
    // EXAMPLE:
    //[[CCDirector sharedDirector] replaceScene:[DungeonScene scene]];
}

- (void)didPressButton_null:(CCMenuItem *)sender
{
}

- (void)didPressButton:(CCMenuItem *)sender
{
    // TODO: fade の処理が散らばるなあ。。。
    // CCDirector に protocol でトランジッション指定できる replaceScene 作ったらいいかも
    CCScene *scene = [SelectQuestScene scene];
    CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:0.5f scene:scene withColor:ccc3(0, 0, 0)];
    [[CCDirector sharedDirector] replaceScene:trans];
}

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [HomeScene node];
    [scene addChild:layer];
    return scene;
}

@end

