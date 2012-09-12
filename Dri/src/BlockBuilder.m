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
    [self setBuilderWithID:ID_PLAYER builder:@selector(build_player)];
    [self setBuilderWithID:ID_NORMAL_BLOCK builder:@selector(build_normal)];
    [self setBuilderWithID:ID_GROUPED_BLOCK_1 builder:@selector(build_grouped_1)];
    [self setBuilderWithID:ID_GROUPED_BLOCK_2 builder:@selector(build_grouped_2)];
    [self setBuilderWithID:ID_GROUPED_BLOCK_3 builder:@selector(build_grouped_3)];
    [self setBuilderWithID:ID_UNBREAKABLE_BLOCK builder:@selector(build_unbreakable)];
    [self setBuilderWithID:ID_ENEMY_BLOCK_0 builder:@selector(build_enemy_0)];
    [self setBuilderWithID:ID_ENEMY_BLOCK_1 builder:@selector(build_enemy_1)];
}

-(void)setBuilderWithID:(enum ID_BLOCK)id_ builder:(SEL)builder_method
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
    b.hp = 7;
    b.atk = 5;
    b.pos = cdp(2, 1);
    
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
    b.hp = 1;
    return b;
}

-(BlockModel*)build_enemy_0
{
    // 生成
    BlockModel* b = [[BlockModel alloc] init];
    b.type = ID_ENEMY_BLOCK_0;
    b.hp =  6;
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
    b.hp =  20;
    b.atk = 3;
    b.def = 3;
    
    // attach Behavior
    [b attach_behaivior:[[[BreakableBehaivior  alloc] init] autorelease]];
    [b attach_behaivior:[[[AggressiveBehaivior alloc] init] autorelease]];
    
    return b;
}


@end
