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
    // アップデートフェイズで効果が発動するものはここに書く
}

-(void)on_damage:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behavior
    [dungeon_ notify:1 params:context_]; // 1 == ON_HIT
    NSLog(@"PLAYER DAMAGED P hp=%d", context_.hp);
    // イベント飛ばす
}

-(void)on_break:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
    NSLog(@"PLAYER DIED P hp=%d", context_.hp);
    // イベント飛ばす
}

@end
