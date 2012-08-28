//
//  DieableBehavior.m
//  Dri
//
//  Created by  on 12/08/28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DieableBehavior.h"
#import "DungeonModel.h"

@implementation DieableBehavior

-(void)on_hit:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
}

-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
}

-(void)on_damage:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behavior
    NSLog(@"PLAYER DAMAGED P hp=%d", context_.hp);
}

-(void)on_break:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
    NSLog(@"PLAYER DIED P hp=%d", context_.hp);
}

@end
