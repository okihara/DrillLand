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

-(void)_attachBehavior:(BlockModel *)block master:(NSDictionary *)master
{
    for (int i = 0; i < 3; ++i) {
        NSString *key = [NSString stringWithFormat:@"behavior_%d", i];
        NSNumber *number = [master objectForKey:key];
        if ([number isKindOfClass:[NSNull class]]) {
            continue;
        }
        uint behavior_id = [number unsignedIntValue];
        if (!behavior_id) {
            continue;
        }
        NSObject<BlockBehaivior> *behavior = [BehaviorFactory create:behavior_id];
        [block attach_behaivior:behavior];
    }
}

- (void)_attachParams:(BlockModel *)b master:(NSDictionary *)master
{
    b.type      = [[master objectForKey:@"type"] intValue];
    b.group_id  = [[master objectForKey:@"group_id"] intValue];
    b.view_id   = [[master objectForKey:@"view_id"] intValue];
    b.view_type = [[master objectForKey:@"view_type"] intValue];
    b.hp        = [[master objectForKey:@"hp"] intValue];
    b.max_hp    = b.hp;
    b.atk       = [[master objectForKey:@"atk"] intValue];
    b.def       = [[master objectForKey:@"def"] intValue];
    b.exp       = [[master objectForKey:@"exp"] intValue];
    b.gold      = [[master objectForKey:@"gold"] intValue];
}

-(BlockModel*)buildWithID:(enum ID_BLOCK)id_
{
    // get json data from master
    NSDictionary *master = [MasterLoader getMaster:@"block_master" primaryId:id_];
    
    BlockModel *block = [[BlockModel alloc] init];
    block.block_id = id_;
    
    [self _attachParams:  block master:master];
    [self _attachBehavior:block master:master];
    
    return block;
}

@end
