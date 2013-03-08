//
//  TtileScene.m
//  Dri
//
//  Created by  on 13/03/07.
//  Copyright 2013 Hiromtsu. All rights reserved.
//

#import "TitleScene.h"
#import "SelectQuestScene.h"

@implementation TitleScene

- (void)pressedStart:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[SelectQuestScene scene]];
}

@end
