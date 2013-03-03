//
//  DungeonPreloadScene.m
//  Dri
//
//  Created by Okihara on 12/08/24.
//  Copyright 2012 Hiromitsu. All rights reserved.
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

uint blockIdList[] = {
    13000,
    11000,
};

- (void)_loadModel:(int)blockId frame_loader:(SpriteFrameLoader *)frame_loader animation_loader:(AnimationLoader *)animation_loader
{
    [frame_loader     load_sprite:    [NSString stringWithFormat:@"blk%05d.json",  blockId]];
    [animation_loader load_animation: [NSString stringWithFormat:@"anim%05d.json", blockId]];
}

- (void)_loadDungeonData
{
    // ローダーを作る
    SpriteFrameLoader *frame_loader     = [[[SpriteFrameLoader alloc] init] autorelease];
    AnimationLoader   *animation_loader = [[[AnimationLoader alloc] init] autorelease];
    
    // 大前提: このダンジョンで必要なものだけをロードすべき
    int num = sizeof(blockIdList) / sizeof(blockIdList[0]);
    for (int i = 0; i < num; i++) {
        [self _loadModel:blockIdList[i] frame_loader:frame_loader animation_loader:animation_loader];
    }

    // 主人公キャラの追加データ
    // TODO: １っこでええやろ
    [frame_loader     load_sprite:@"blk13000a.json"];
    [animation_loader load_animation:@"anim13000a.json"];

    // 使ってた(´・ω・｀)
    [frame_loader load_sprite:@"common.json"];
}

-(id) init
{
	if( (self=[super init]) ) {
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"loading" fontName:DL_FONT_NAME fontSize:20];
        label.position = ccp(160, 440);
        [self addChild:label];
        
        // ---
        [self _loadDungeonData];
        
        
        // マスターデータをロード
        [MasterLoader load:@"block_master.json"];
        [MasterLoader load:@"item_master.json"];
        
        // SE
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"skullpile1.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"death3.wav"];
        
        // ---
        [CCMenuItemFont setFontName:DL_FONT_NAME];
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
