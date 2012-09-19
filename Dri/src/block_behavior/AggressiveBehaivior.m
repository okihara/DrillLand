//
//  EnemyBehaivior.m
//  Dri
//
//  Created by  on 12/08/28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AggressiveBehaivior.h"
#import "DungeonModel.h"

@implementation AggressiveBehaivior

-(void)on_hit:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behavior
}

-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    BlockModel* p = (BlockModel*)dungeon_.player;
    if ([context_ in_attack_range:dungeon_]) {
        // TODO: 
        DLEvent *e = [DLEvent eventWithType:DL_ON_ATTACK target:context_];
        [dungeon_ dispatchEvent:e];
        // TODO:
        [context_ attack:p dungeon:dungeon_];
    }
}

-(void)on_damage:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_ damage:(int)damage_
{
    // implement behavior
}

-(void)on_break:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behavior
}

@end
