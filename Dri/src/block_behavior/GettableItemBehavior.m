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
#import "UserItem.h"

@implementation GettableItemBehavior

-(void)on_hit:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
}

-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
}

-(void)on_damage:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_ damage:(int)damage_
{
    // implement behaivior
}

-(void)on_break:(BlockModel*)block dungeon:(DungeonModel*)dungeonModel
{
    // attacker のアイテムに、UserItem を挿入するよ
    // ほとんどが Player だよ
    // TODO: Player
    int r = rand() % 3;
    UInt32 masterId =  r == 0 ? 100 : r == 1 ? 10000 : 10001;
    UserItem *userItem = [UserItem createWithMasterId:masterId];
    [dungeonModel.player add_item:userItem];
    
    // イベント飛ばす
    DLEvent *e = [DLEvent eventWithType:DL_ON_GET target:block];
    // TODO: タイプ決め打ちすぎィ！
    [e.params setObject:[NSNumber numberWithInt:ID_ITEM_BLOCK_1] 
                 forKey:@"type"];
    [dungeonModel dispatchEvent:e];
}

@end
