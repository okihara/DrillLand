//
//  DungeonPreloadScene.m
//  Dri
//
//  Created by  on 12/08/24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "SBJson.h"
#import "SimpleAudioEngine.h"
#import "DL.h"
#import "GamePreloadScene.h"
#import "DungeonScene.h"
#import "SpriteFrameLoader.h"
#import "AnimationLoader.h"
#import "MasterLoader.h"
#import "DebugBlockScene.h"
#import "HomeScene.h"
#import "DungeonPreloadScene.h"
#import "SelectQuestScene.h"


@implementation GamePreloadScene

+(CCScene*)scene {
	CCScene *scene = [CCScene node];
	GamePreloadScene *layer = [GamePreloadScene node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init]) ) {

        CCLabelTTF *label = [CCLabelTTF labelWithString:@"loading" fontName:DL_FONT_NAME fontSize:20];
        label.position = ccp(160, 440);
        [self addChild:label];

        // ---
        [CCMenuItemFont setFontName:DL_FONT_NAME];

        // ローダーを作る
        SpriteFrameLoader *frame_loader = [[[SpriteFrameLoader alloc] init] autorelease];
        AnimationLoader *animation_loader = [[[AnimationLoader alloc] init] autorelease];
        
        // 主人公キャラ
        [frame_loader load_sprite:@"blk13000.json"];
        [animation_loader load_animation:@"anim13000.json"];
        
        [frame_loader load_sprite:@"blk13000a.json"];
        [animation_loader load_animation:@"anim13000a.json"];
        
        
        // 青スライム
        [frame_loader load_sprite:@"blk11000.json"];
        [animation_loader load_animation:@"anim11000.json"];

        
        // 使っとりゃーせんね
        [frame_loader load_sprite:@"common.json"];
        
        
        // マスターデータをロード
        [MasterLoader load:@"block_master.json"];
        [MasterLoader load:@"item_master.json"];

        // SE
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"skullpile1.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"death3.wav"];
    }
	return self;
}

-(void)goto_dungeon
{
    UInt32 dungeonId = 3;
    CCScene *next_scene = [DungeonPreloadScene sceneWithDungeonId:dungeonId];
    [[CCDirector sharedDirector] replaceScene:next_scene];
}

-(void)goto_debug_block_view
{
    CCScene *next_scene = [DebugBlockScene scene];
    [[CCDirector sharedDirector] replaceScene:next_scene];    
}

-(void)onEnter
{
    [super onEnter];

//    [self goto_debug_block_view];
    [self goto_dungeon];
//    [[CCDirector sharedDirector] replaceScene:[HomeScene scene]];
//    [[CCDirector sharedDirector] replaceScene:[SelectQuestScene scene]];
}

@end
