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

    // TODO: ここプレイヤー固定になってるなあ。。。
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
    // イベント飛ばす
    DLEvent *e = [DLEvent eventWithType:DL_ON_DESTROY target:block];
    [dungeon_ dispatchEvent:e];

    // モデルの情報書き換える。初期化。
//    [block clear];
}

@end
