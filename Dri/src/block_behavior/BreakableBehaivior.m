//
//  NormalBehaivior.m
//  Dri
//
//  Created by  on 12/08/28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BreakableBehaivior.h"
#import "DungeonModel.h"
#import "BlockBuilder.h"

@implementation BreakableBehaivior

-(void)on_hit:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    DLEvent *e = [DLEvent eventWithType:DL_ON_HIT target:context_];
    [dungeon_ dispatchEvent:e];

    [dungeon_.player attack:context_ dungeon:dungeon_];
}

-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
}

-(void)on_damage:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_ damage:(int)damage_
{
    DLEvent *e = [DLEvent eventWithType:DL_ON_DAMAGE target:context_];
    [e.params setObject:[NSNumber numberWithInt:damage_] forKey:@"damage"];
    [dungeon_ dispatchEvent:e];
}

-(void)on_break:(BlockModel*)block dungeon:(DungeonModel*)dungeon_
{
    // TODO: ここで behaivior リストも破棄しないといけない
    // どういう意味？？

    DLPoint pos = block.pos;
    
    [block clear];
    
    if (rand() % 30 == 0) {

        // TODO: 無理矢理書き換えてる
        BlockBuilder *builder = [[[BlockBuilder alloc] init] autorelease];
        block = [builder buildWithID:ID_ITEM_BLOCK_0];
        [dungeon_ _set:pos block:block];
        
        DLEvent *e = [DLEvent eventWithType:DL_ON_CHANGE target:block];
        [dungeon_ dispatchEvent:e];
        
    } else {
        
        DLEvent *e = [DLEvent eventWithType:DL_ON_DESTROY target:block];
        [dungeon_ dispatchEvent:e];
        
    }
}

@end
