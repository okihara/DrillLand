//
//  TreasureBoxBehavior.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "TreasureBoxBehavior.h"
#import "BlockModel.h"
#import "BlockBuilder.h"
#import "DungeonModel.h"

@implementation TreasureBoxBehavior

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

-(void)on_break:(BlockModel*)block dungeon:(DungeonModel*)dungeon_model
{
    DLPoint pos = block.pos;

    // モデルの情報書き換える      
    // TODO: 無理矢理書き換えてる
    BlockBuilder *builder = [[[BlockBuilder alloc] init] autorelease];
    block = [builder buildWithID:ID_ITEM_BLOCK_1];
    // TODO: set でOK? メモリリークしない？
    [dungeon_model set:pos block:block];
}

@end

