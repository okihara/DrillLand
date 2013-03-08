//
//  TtileScene.m
//  Dri
//
//  Created by  on 13/03/07.
//  Copyright 2013 Hiromtsu. All rights reserved.
//

#import "TitleScene.h"
#import "SelectQuestScene.h"
#import "CCBReader.h"

@implementation TitleScene

- (void)pressedStart:(id)sender
{
    CCScene *nextScene = [CCBReader sceneWithNodeGraphFromFile:@"select_quest.ccbi"];
    [[CCDirector sharedDirector] replaceScene:nextScene];
}

@end
