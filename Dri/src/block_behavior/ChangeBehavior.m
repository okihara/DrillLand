//
//  ChangeBehavior.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "ChangeBehavior.h"
#import "BlockModel.h"
#import "BlockBuilder.h"
#import "DungeonModel.h"

@implementation ChangeBehavior

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

- (void)change_if_needed:(BlockModel *)block dungeon_model:(DungeonModel *)dungeon_model
{
    // TODO: とりあえずすぎる
    
    int r = rand();
    
    DLPoint pos = block.pos;
    
    if (r % 15 == 0) {
        
        // モデルの情報書き換える      
        // TODO: 無理矢理書き換えてる
        BlockBuilder *builder = [[[BlockBuilder alloc] init] autorelease];
        block = [builder buildWithID:ID_ITEM_BLOCK_0];
        // TODO: set でOK? メモリリークしない？
        [dungeon_model set:pos block:block];
        
    } else if (r % 15 == 1) {
        
        // モデルの情報書き換える      
        // TODO: 無理矢理書き換えてる
        BlockBuilder *builder = [[[BlockBuilder alloc] init] autorelease];
        block = [builder buildWithID:ID_ITEM_BLOCK_2];
        // TODO: set でOK? メモリリークしない？
        [dungeon_model set:pos block:block];
        
    } else if (r% 15 == 2) {
        
        // モデルの情報書き換える      
        // TODO: 無理矢理書き換えてる
        BlockBuilder *builder = [[[BlockBuilder alloc] init] autorelease];
        block = [builder buildWithID:ID_ITEM_BLOCK_2];
        // TODO: set でOK? メモリリークしない？
        [dungeon_model set:pos block:block];
        
    }
}

-(void)on_break:(BlockModel*)block dungeon:(DungeonModel*)dungeon_
{
    // 必要なら違うブロックに変わる
    [self change_if_needed:block dungeon_model:dungeon_];  
}

@end

