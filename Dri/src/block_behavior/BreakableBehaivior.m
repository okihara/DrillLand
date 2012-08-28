//
//  NormalBehaivior.m
//  Dri
//
//  Created by  on 12/08/28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BreakableBehaivior.h"
#import "DungeonModel.h" // TODO:ここは protocol で解決したい

@implementation BreakableBehaivior

-(void)on_hit:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // 1 == ON_HIT
    [dungeon_ notify:1 params:context_];
    
    [dungeon_.player attack:context_ dungeon:dungeon_];
}

-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    //    BlockModel* p = (BlockModel*)dungeon.player;
    //    if ([self is_attack_range:dungeon]) {
    //        [self attack:p dungeon:dungeon];
    //    }
}

@end
