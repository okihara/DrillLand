//
//  BlockBuilder.m
//  Dri
//
//  Created by  on 12/08/27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockBuilder.h"
#import "BlockModel.h"
#import "BreakableBehaivior.h"
#import "AggressiveBehaivior.h"
#import "DieableBehavior.h"
#import "PotionBehavior.h"
#import "BossBehavior.h"
#import "GettableItemBehavior.h"

@implementation BlockBuilder

-(id)init
{
    if(self=[super init]) {
        builder_map = [[NSMutableDictionary alloc] init];
        [self setupBuilders];
    }
    return self;
}

-(void)setupBuilders
{
    [self registerBuilderWithID:ID_PLAYER builder:@selector(build_player)];
    [self registerBuilderWithID:ID_NORMAL_BLOCK builder:@selector(build_normal)];
    [self registerBuilderWithID:ID_GROUPED_BLOCK_1 builder:@selector(build_grouped_1)];
    [self registerBuilderWithID:ID_GROUPED_BLOCK_2 builder:@selector(build_grouped_2)];
    [self registerBuilderWithID:ID_GROUPED_BLOCK_3 builder:@selector(build_grouped_3)];
    [self registerBuilderWithID:ID_UNBREAKABLE_BLOCK builder:@selector(build_unbreakable)];
    [self registerBuilderWithID:ID_ENEMY_BLOCK_0 builder:@selector(build_enemy_0)];
    [self registerBuilderWithID:ID_ENEMY_BLOCK_1 builder:@selector(build_enemy_1)];
    [self registerBuilderWithID:ID_ITEM_BLOCK_0 builder:@selector(build_item_0)];
    [self registerBuilderWithID:ID_ITEM_BLOCK_1 builder:@selector(build_item_1)];
}

-(void)registerBuilderWithID:(enum ID_BLOCK)id_ builder:(SEL)builder_method
{
    [builder_map setObject:[NSValue valueWithPointer:builder_method] forKey:[NSNumber numberWithInt:id_]];
}

-(BlockModel*)buildWithID:(enum ID_BLOCK)id_
{
    NSValue* value = [builder_map objectForKey:[NSNumber numberWithInt:id_]];
    if (!value) return nil;
    SEL sel = [value pointerValue];
    if (!sel) return nil;
    return [self performSelector:sel];
}

-(void)dealloc
{
    [builder_map release];
    [super dealloc];
}

// ---------------------------------------------------------------------

-(BlockModel*)build_player
{
    BlockModel* b = [[BlockModel alloc] init];
    b.type = ID_PLAYER;
    b.hp = b.max_hp = 10;
    b.atk = 5;
    b.pos = cdp(2, 3);
    
    // attach Behavior
    [b attach_behaivior:[[[DieableBehavior alloc] init] autorelease]];
    
    return b;
}

-(BlockModel*)build_normal
{
    // 生成
    BlockModel* b = [[BlockModel alloc] init];
    b.type = ID_NORMAL_BLOCK;
    b.hp = 1;
    
    // attach Behavior
    [b attach_behaivior:[[[BreakableBehaivior alloc] init] autorelease]];
    
    return b;
}

-(BlockModel*)build_unbreakable
{
    // 生成
    BlockModel* b = [[BlockModel alloc] init];
    b.type = ID_UNBREAKABLE_BLOCK;
    b.hp = 9999;
    
    // attach Behavior
    [b attach_behaivior:[[[BreakableBehaivior alloc] init] autorelease]];
    
    return b;
}

-(BlockModel*)build_grouped:(enum ID_BLOCK)id_
{
    // 生成
    BlockModel* b = [[BlockModel alloc] init];
    b.type = id_;
    b.group_id = id_;
    b.hp = 1;
    
    // attach Behavior
    [b attach_behaivior:[[[BreakableBehaivior alloc] init] autorelease]];
    
    return b;   
}

-(BlockModel*)build_grouped_1
{
    return [self build_grouped:ID_GROUPED_BLOCK_1];
}

-(BlockModel*)build_grouped_2
{
    return [self build_grouped:ID_GROUPED_BLOCK_2];
}

-(BlockModel*)build_grouped_3
{
    BlockModel* b = [self build_grouped:ID_GROUPED_BLOCK_3];
    b.hp = b.max_hp = 1;
    return b;
}

-(BlockModel*)build_enemy_0
{
    // 生成
    BlockModel* b = [[BlockModel alloc] init];
    b.type = ID_ENEMY_BLOCK_0;
    b.hp = b.max_hp = 4;
    b.atk = 3;
    b.def = 3;
    
    // attach Behavior
    [b attach_behaivior:[[[BreakableBehaivior  alloc] init] autorelease]];
    [b attach_behaivior:[[[AggressiveBehaivior alloc] init] autorelease]];

    return b;
}

-(BlockModel*)build_enemy_1
{
    // 生成
    BlockModel* b = [[BlockModel alloc] init];
    b.type = ID_ENEMY_BLOCK_1;
    b.hp = b.max_hp = 17;
    b.atk = 4;
    b.def = 3;
    
    // attach Behavior
    [b attach_behaivior:[[[BossBehavior alloc] init] autorelease]];
    [b attach_behaivior:[[[BreakableBehaivior  alloc] init] autorelease]];
    [b attach_behaivior:[[[AggressiveBehaivior alloc] init] autorelease]];
    
    return b;
}

-(BlockModel*)build_item_0
{
    // 生成
    BlockModel* b = [[BlockModel alloc] init];
    b.type = ID_ITEM_BLOCK_0;
    b.hp =  1;
    b.atk = 0;
    b.def = 0;
    
    // attach Behavior
    [b attach_behaivior:[[[PotionBehavior  alloc] init] autorelease]];
    [b attach_behaivior:[[[BreakableBehaivior  alloc] init] autorelease]];
    
    return b;
}

-(BlockModel*)build_item_1
{
    // 生成
    BlockModel* b = [[BlockModel alloc] init];
    b.type = ID_ITEM_BLOCK_1;
    b.hp =  1;
    b.atk = 0;
    b.def = 0;
    
    // attach Behavior
    [b attach_behaivior:[[[GettableItemBehavior alloc] init] autorelease]];
    
    return b;    
}



@end
