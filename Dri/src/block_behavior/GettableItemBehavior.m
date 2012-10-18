//
//  GettableItemBehavior.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "GettableItemBehavior.h"
#import "BlockModel.h"
#import "DLEvent.h"
#import "DungeonModel.h"

@implementation GettableItemBehavior

-(void)on_hit:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
    [dungeon_.player attack:context_ dungeon:dungeon_];
}

-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
}

-(void)on_damage:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_ damage:(int)damage_
{
    // implement behaivior
}

-(void)on_break:(BlockModel*)block dungeon:(DungeonModel*)dungeon_
{
    // attacker のアイテムに、UserItem を挿入するよ
    // ほとんどが Player だよ
    // [player_model add_tem:[block get_item_info]];
    
    // イベント飛ばす
    {
        DLEvent *e = [DLEvent eventWithType:DL_ON_GET target:block];
        // TODO: タイプ決め打ちすぎ
        [e.params setObject:[NSNumber numberWithInt:ID_ITEM_BLOCK_1] forKey:@"type"];
        [dungeon_ dispatchEvent:e];
    }
 
    {
        DLEvent *e = [DLEvent eventWithType:DL_ON_DESTROY target:block];
        [dungeon_ dispatchEvent:e];
    }
    
    // TODO: イベント飛ばした後で clear しないといけないのを直す（クエストコンディションの中で block の type 見ている）
    [block clear];
}

@end

