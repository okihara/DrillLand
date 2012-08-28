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
    // implement behaivior
    [dungeon_ notify:1 params:context_]; // 1 == ON_HIT
    
    [dungeon_.player attack:context_ dungeon:dungeon_];
}

-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
}

-(void)on_damage:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behavior
}

-(void)on_break:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
    // TODO: ここで behaivior リストも破棄しないといけない
    [context_ clear];
    
    // 2 == ON_DESTROY
    [dungeon_ notify:2 params:context_];
}

@end
