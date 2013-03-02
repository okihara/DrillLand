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

- (int)_getChangedId
{
    int r = rand();

    if (r % 15 == 0) {
        return ID_ITEM_BLOCK_0;
    } else if (r % 15 == 1) {
        return ID_ITEM_BLOCK_2;
    } else if (r% 15 == 2) {
        return ID_ITEM_BLOCK_2;
    } else if (r% 15 == 3) {
        return 11010;
    }
    return 0;
}

- (void)_changeIfNeeded:(BlockModel *)block dungeon_model:(DungeonModel *)dungeon_model
{
    int changedId = [self _getChangedId];
    if (changedId == 0) { return; }
    
    BlockBuilder *builder  = [[[BlockBuilder alloc] init] autorelease];
    BlockModel   *newBlock = [builder buildWithID:changedId];
    if (!newBlock) { return; }
    
    // TODO: set でOK? メモリリークしない？
    DLPoint pos = block.pos;
    [dungeon_model set:pos block:newBlock];
}

-(void)on_break:(BlockModel*)block dungeon:(DungeonModel*)dungeon_
{
    // 必要なら違うブロックに変わる
    [self _changeIfNeeded:block dungeon_model:dungeon_];  
}

@end
