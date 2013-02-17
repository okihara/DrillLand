//
//  DungeonModel.m
//  Dri
//
//  Created by  on 12/08/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DungeonModel.h"
#import "BlockModel.h"
#import "BlockBuilder.h"
#import "DungeonLoader.h"
#import "DungeonModelCanTapUpdater.h"
#import "DungeonModelGroupInfoUpdater.h"
#import "DungeonModelRouteMap.h"

@implementation DungeonModel

@synthesize player;
@synthesize lowest_empty_y;

- (id)init
{
    if (self = [super init]) {

        self->lowest_empty_y = 5;

        self->observer_list = [[NSMutableArray alloc] init];
        self->block_builder = [[BlockBuilder alloc] init];
        self->player = [block_builder buildWithID:ID_PLAYER];
        self->player.pos = cdp(2,3);

        self->map = [[ObjectXDMap alloc] init];
        
        self->impl =             [[DungeonModelCanTapUpdater alloc] init];
        self->groupInfoUpdater = [[DungeonModelGroupInfoUpdater alloc] init];
        self->routeMap =         [[DungeonModelRouteMap alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [self->routeMap release];
    [self->groupInfoUpdater release];
    [self->impl release];
    [self->map release];
    [self->player release];
    [self->block_builder release];
    [self->observer_list release];
    [super dealloc];
}

-(UInt32)lowest_empty_y
{
    return self->impl.lowestEmptyY;
}

-(NSMutableArray*)routeList
{
    return self->routeMap.route_list;
}

//------------------------------------------------------------------------------
//
// 通知系
//
//------------------------------------------------------------------------------

-(void)addObserver:(id<DungenModelObserver>)observer_
{
    [self->observer_list addObject:observer_];
}

-(void)dispatchEvent:(DLEvent*)e
{
    for (id<DungenModelObserver> observer in self->observer_list) {
        [observer notify:self event:e];
    }
}

//------------------------------------------------------------------------------
//
// 更新系
//
//------------------------------------------------------------------------------

// -- プレイヤーの移動フェイズ
- (void)move_player:(DLPoint)pos
{
    [self->routeMap update:self->map start:pos target:player.pos];
    self->player.pos = [self->routeMap nextPlayerPos:player.pos];
}

// -- ブロックのヒット処理フェイズ
- (void)on_hit_block:(DLPoint)pos
{
    BlockModel* b = [self get:pos];
    
    // TODO: 
    DLEvent *e = [DLEvent eventWithType:DL_ON_ATTACK target:self->player];
    [self dispatchEvent:e];
    // TODO:
    
    if (b.group_info) {
        for (BlockModel* block in b.group_info) {
            [block on_hit:self];
        }
    } else {
        [b on_hit:self];
    }
}

-(void)on_update
{
    for (int j = 0; j < DM_HEIGHT; j++) {
        for (int i = 0; i < DM_WIDTH; i++) {
            BlockModel* b = [self get:cdp(i, j)];
            if (!b.is_dead) {
                [b on_update:self];
            }
        }
    }
}


// =============================================================================

- (BOOL)_executeOneTurn:(DLPoint)pos
{
    BlockModel* target = [self get:pos];
    
    // タップできない（ターン消費無し）
    // このレイヤーでやることか？
    // ここじゃないとするなら、どこよ？
    if (target.block_id == ID_EMPTY || target.can_tap == NO) {
        DLEvent* event = [DLEvent eventWithType:DL_ON_CANNOT_TAP target:target];
        [self dispatchEvent:event];
        return NO;
    }
    
    // プレイヤーの移動
    [self move_player:pos];
    
    // 仲間/敵の移動
    // not implemented yet
    
    // ブロックのヒットフェイズ
    [self on_hit_block:pos];
    
    // ブロック(プレイヤー以外の)のアップデートフェイズ
    [self on_update];
    
    return YES;
}

- (BOOL)executeOneTurn:(DLPoint)pos
{
    // ブロックのヒットフェイズ
    [self on_hit_block:pos];
    
    // ブロック(プレイヤー以外の)のアップデートフェイズ
    [self on_update];
    
    return YES;
}

-(BOOL)onTap:(DLPoint)pos
{
    return [self _executeOneTurn:pos];
}

-(void)_clearAllIfDead
{
    for (int j = 0; j < DM_HEIGHT; j++) {
        for (int i = 0; i < DM_WIDTH; i++) {
            BlockModel* b = [self get:cdp(i, j)];
            if (b.is_dead) {
                [b clear];
            };
        }
    }
}

-(void)postprocess
{
    [self _clearAllIfDead];
    [self->impl updateCanTap:self->map start:self->player.pos];
}


//------------------------------------------------------------------------------
//
// getter/setter
//
//------------------------------------------------------------------------------

// TODO: set は最初だけにしよう、置き換えるんじゃなくて、作成済みのデータを変更しよう
// 上はなぜ？
-(void)set_without_update_can_tap:(DLPoint)pos block:(BlockModel*)block
{
    block.pos = pos;
    [self->map set_x:pos.x y:pos.y value:block];
    [self->groupInfoUpdater updateGroupInfo:self->map start:pos groupId:block.group_id];
}

-(void)set:(DLPoint)pos block:(BlockModel*)block
{
    [self set_without_update_can_tap:pos block:block];

    // この一行いらんかも
    [self->impl updateCanTap:self->map start:self->player.pos];

    // ここで NEW イベント飛ばす
    DLEvent *e = [DLEvent eventWithType:DL_ON_NEW target:block];
    [self dispatchEvent:e];
}

-(BlockModel*)get:(DLPoint)pos
{
    return [self->map get_x:pos.x y:pos.y];
}

//------------------------------------------------------------------------------

-(void)load_from_file:(NSString*)filename
{
    DungeonLoader *loader = [[DungeonLoader alloc] initWithDungeonModel:self];
    [loader load_from_file:filename];
    [self->impl updateCanTap:self->map start:self->player.pos];
    [loader release];
}

-(void)load_random:(UInt16)seed
{
    DungeonLoader *loader = [[DungeonLoader alloc] initWithDungeonModel:self];
    [loader load_random:seed];
    [self->impl updateCanTap:self->map start:self->player.pos];
    [loader release];
}


@end
