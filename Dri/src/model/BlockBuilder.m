//
//  BlockBuilder.m
//  Dri
//
//  Created by  on 12/08/27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockBuilder.h"
#import "BlockModel.h"
#import "BehaviorFactory.h"
#import "MasterLoader.h"

@implementation BlockBuilder

-(id)init
{
    if(self=[super init]) {
    }
    return self;
}

-(BlockModel*)build_by_id:(enum ID_BLOCK)id_
{
    // get json data from master
    NSDictionary *master = [MasterLoader get_master_by_id:id_];
    
    // setup parameter
    BlockModel* b = [[BlockModel alloc] init];
    
    b.block_id = id_;
    b.type     = id_;
    b.group_id = [[master objectForKey:@"group_id"] intValue];
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

-(BlockModel*)buildWithID:(enum ID_BLOCK)id_
{
    return [self build_by_id:id_];
}

-(void)dealloc
{
    [super dealloc];
}

@end
