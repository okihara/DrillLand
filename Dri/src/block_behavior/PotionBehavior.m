//
//  PotionBehavior.m
//  Dri
//
//  Created by  on 12/09/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PotionBehavior.h"
#import "DungeonModel.h"

@implementation PotionBehavior

-(void)on_hit:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behavior
}

-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behavior
}

-(void)on_damage:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_ damage:(int)damage_
{
    // implement behavior
}

-(void)on_break:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // TODO: 10 って決め打ちかーい
    // TODO: player って決め打ちかーい
    [dungeon_.player heal:10];
    
    DLEvent *e = [DLEvent eventWithType:DL_ON_HEAL target:dungeon_.player];
    [e.params setObject:[NSNumber numberWithInt:10] forKey:@"damage"];
    [dungeon_ dispatchEvent:e];
}

@end
