//
//  BlockBuilder.m
//  Dri
//
//  Created by  on 12/08/27.
//  Copyright 2012 Hiromitsu. All rights reserved.
//

#import "BlockBuilder.h"
#import "BlockModel.h"
#import "BehaviorFactory.h"
#import "MasterLoader.h"

@implementation BlockBuilder

-(BlockModel*)buildWithID:(enum ID_BLOCK)id_
{
    // get json data from master
    NSDictionary *master = [MasterLoader get_master_by_id:id_];
    
    // setup parameter
    BlockModel* b = [[BlockModel alloc] init];
    
    b.block_id = id_;
    b.type     = [[master objectForKey:@"type"] intValue];
    b.group_id = [[master objectForKey:@"group_id"] intValue];
    b.view_id  = [[master objectForKey:@"view_id"] intValue];
    b.view_type= [[master objectForKey:@"view_type"] intValue];
    b.hp       = [[master objectForKey:@"hp"] intValue];
    b.max_hp   = b.hp;
    b.atk      = [[master objectForKey:@"atk"] intValue];
    b.def      = [[master objectForKey:@"def"] intValue];
    b.exp      = [[master objectForKey:@"exp"] intValue];
    b.gold     = [[master objectForKey:@"gold"] intValue];
    
    // setup behavior
    for (int i = 0; i < 3; ++i) {
        NSString *key = [NSString stringWithFormat:@"behavior_%d", i];
        NSNumber *number = [master objectForKey:key];
        if ([number isKindOfClass:[NSNull class]]) {
            continue;
        }
        uint behavior_id = [number intValue];
        if (!behavior_id) {
            continue;
        }
        NSObject<BlockBehaivior> *behavior = [BehaviorFactory create:behavior_id];
        [b attach_behaivior:behavior];
    }
    
    return b;
}

@end
