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

// これは武器/敵によってロジックが変わるので、ここに書くべきではない
-(BOOL)in_attack_range:(BlockModel*)context_ dungeon_model:(DungeonModel*)dungeon
{
    // 上下左右
    BlockModel* p = (BlockModel*)dungeon.player;
    if((p.pos.x == context_.pos.x + 0 && p.pos.y == context_.pos.y - 1) ||
       (p.pos.x == context_.pos.x + 0 && p.pos.y == context_.pos.y + 1) ||
       (p.pos.x == context_.pos.x - 1 && p.pos.y == context_.pos.y + 0) ||
       (p.pos.x == context_.pos.x + 1 && p.pos.y == context_.pos.y + 0)) {
        return YES;
    }
    return NO;
}

-(void)on_hit:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behavior
}

-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    BlockModel* player = (BlockModel*)dungeon_.player;
    if ([self in_attack_range:context_ dungeon_model:dungeon_]) {
        
        DLEvent *e = [DLEvent eventWithType:DL_ON_ATTACK target:context_];
        [dungeon_ dispatchEvent:e];
        
        [context_ attack:player dungeon:dungeon_];
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
