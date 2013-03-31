//
//  SelectQuestScene.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "SelectQuestScene.h"
#import "DungeonPreloadScene.h"
#import "CCBReader.h"
#import "BasicNotifierView.h"

@implementation SelectQuestScene

- (void)_goto_dungeon_scene:(uint)dungeon_id
{
    CCScene *scene = [DungeonPreloadScene sceneWithDungeonId:dungeon_id];
    CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:0.5f scene:scene withColor:ccc3(0, 0, 0)];
    [[CCDirector sharedDirector] replaceScene:trans];
}

- (void)onEnter
{
    [super onEnter];
    
    [BasicNotifierView setup:self];
//    button_shop.enabled = NO;
}

- (void)didPressButton_0:(CCMenuItem *)sender
{
    uint dungeon_id = 0;
    [self _goto_dungeon_scene:dungeon_id];
}

- (void)didPressButton_1:(CCMenuItem *)sender
{
    uint dungeon_id = 1;
    [self _goto_dungeon_scene:dungeon_id];
}

- (void)didPressButton_2:(CCMenuItem *)sender
{
    [BasicNotifierView notify:@"Dungeon2 still locked." target:self];
    return;

    uint dungeon_id = 2;
    [self _goto_dungeon_scene:dungeon_id];
}

- (void)didPressButton_3:(CCMenuItem *)sender
{
    [BasicNotifierView notify:@"Dungeon3 still locked." target:self];
    return;
    
    uint dungeon_id = 3;
    [self _goto_dungeon_scene:dungeon_id];
}

- (void)didPressButton_status:(CCMenuItem *)sender
{
    CCScene *nextScene = [CCBReader sceneWithNodeGraphFromFile:@"status.ccbi"];
    [[CCDirector sharedDirector] pushScene:nextScene];
}

- (void)didPressButton_shop:(CCMenuItem *)sender
{
    if (YES) {
        // アクション：演出？
        [BasicNotifierView notify:@"Shop still locked." target:self];
    } else {
        CCScene *nextScene = [CCBReader sceneWithNodeGraphFromFile:@"shop.ccbi"];
        [[CCDirector sharedDirector] pushScene:nextScene];
    }
}

@end

