//
//  BossBehavior.m
//  Dri
//
//  Created by  on 12/09/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BossBehavior.h"
#import "DLEvent.h"
#import "DungeonModel.h"

@implementation BossBehavior

-(void)on_hit:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behavior
}

-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behavior
}

-(void)on_damage:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_ damage:(int)damage_
{
    // implement behavior
}

-(void)on_break:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // TODO: ここではなく、QuestCondition に書く
    DLEvent *e = [DLEvent eventWithType:DL_ON_CLEAR target:nil];
    [dungeon_ dispatchEvent:e];
}

@end
