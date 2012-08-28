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
    // implement
}

-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    BlockModel* p = (BlockModel*)dungeon_.player;
    if ([context_ is_attack_range:dungeon_]) {
        [context_ attack:p dungeon:dungeon_];
    }
}

@end
