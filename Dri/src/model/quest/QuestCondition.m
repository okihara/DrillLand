//
//  QuestCondition.m
//  Dri
//
//  Created by  on 12/10/02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestCondition.h"

@implementation QuestCondition

- (void)notify:(DungeonModel*)dungeon_ event:(DLEvent*)e
{
}

-(BOOL)judge:(void*)environment
{
    // クリア条件に達していたら
    // イベント投げる
    return NO;
}

@end
