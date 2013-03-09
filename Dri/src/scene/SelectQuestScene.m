//
//  SelectQuestScene.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "SelectQuestScene.h"
#import "DungeonPreloadScene.h"
#import "CCBReader.h"

@implementation SelectQuestScene

- (void)goto_dungeon_scene:(uint)dungeon_id
{
    CCScene *scene = [DungeonPreloadScene sceneWithDungeonId:dungeon_id];
    CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:0.5f scene:scene withColor:ccc3(0, 0, 0)];
    [[CCDirector sharedDirector] replaceScene:trans];
}

- (void)didPressButton_0:(CCMenuItem *)sender
{
    uint dungeon_id = 0;
    [self goto_dungeon_scene:dungeon_id];
}

- (void)didPressButton_1:(CCMenuItem *)sender
{
    uint dungeon_id = 1;
    [self goto_dungeon_scene:dungeon_id];
}

- (void)didPressButton_2:(CCMenuItem *)sender
{
    uint dungeon_id = 2;
    [self goto_dungeon_scene:dungeon_id];
}

- (void)didPressButton_3:(CCMenuItem *)sender
{
    uint dungeon_id = 3;
    [self goto_dungeon_scene:dungeon_id];
}

- (void)didPressButton_status:(CCMenuItem *)sender
{
    CCScene *nextScene = [CCBReader sceneWithNodeGraphFromFile:@"status.ccbi"];
    [[CCDirector sharedDirector] pushScene:nextScene];
}

//- (void)didPressButtonHome:(CCMenuItem *)sender
//{
//    CCScene *scene = [HomeScene scene];
//    [[CCDirector sharedDirector] replaceScene:scene];    
//}

@end

