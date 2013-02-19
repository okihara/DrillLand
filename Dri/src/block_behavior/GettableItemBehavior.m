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

-(void)on_hit:(BlockModel*)block dungeon:(DungeonModel*)dungeonModel
{
    // implement behaivior
}

-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
}

-(void)on_damage:(BlockModel*)block dungeon:(DungeonModel*)dungeonModel damage:(int)damage_
{
    // masterId を決定する部分
    uint masterId;
    switch (block.block_id) {
        case 12001:
            masterId = 100;
            break;
        case 12004:
            masterId = 10000;
            break;
        case 12005:
            masterId = 10001;
            break;
        default:
            masterId = 100;
            break;
    }
    
    // アイテム付加する部分
    UserItem *userItem = [UserItem createWithMasterId:masterId];
    UserItem *resultItem = [dungeonModel.player add_item:userItem];
    
    if (resultItem) {
        DLEvent *e = [DLEvent eventWithType:DL_ON_GET target:block];
        [e.params setObject:userItem forKey:@"UserItem"];
        [dungeonModel dispatchEvent:e];        
    } else {
        block.hp = 1;
    }
}

-(void)on_break:(BlockModel*)block dungeon:(DungeonModel*)dungeonModel
{
    // implement behaivior
}

@end
