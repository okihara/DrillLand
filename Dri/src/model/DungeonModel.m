//
//  DungeonModel.m
//  Dri
//
//  Created by  on 12/08/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DungeonModel.h"
#import "BlockModel.h"
#import "SBJson.h"
#import "BlockBuilder.h"
#import "DungeonLoader.h"
#import "DungeonModelCanTapUpdater.h"
#import "DungeonModelGroupInfoUpdater.h"


@implementation DungeonModel

@synthesize route_map;
@synthesize player;
@synthesize route_list;
@synthesize lowest_empty_y;

- (id)init
{
    if (self = [super init]) {

        self->lowest_empty_y = 5;

        self->observer_list = [[NSMutableArray array] retain];
        self->block_builder = [[BlockBuilder alloc] init];
        self->player = [block_builder buildWithID:ID_PLAYER];
        self->player.pos = cdp(2,3);
        self->route_map = [[XDMap alloc] init];
        self->route_list = [[NSMutableArray alloc] init];
        self->map = [[ObjectXDMap alloc] init];
        
        self->impl = [[DungeonModelCanTapUpdater alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [self->impl release];
    [self->map release];
    [self->route_map release];
    [self->route_list release];
    [self->player release];
    [self->block_builder release];
    [super dealloc];
}

//-----------------------------------------------------------------------------------------------------------------
//
// 通知系
//
//-----------------------------------------------------------------------------------------------------------------

-(void)add_observer:(id<DungenModelObserver>)observer_
{
    [self->observer_list addObject:observer_];
}

-(void)dispatchEvent:(DLEvent*)e
{
    for (id<DungenModelObserver> observer in self->observer_list) {
        [observer notify:self event:e];
    }
}

//-----------------------------------------------------------------------------------------------------------------
//
// 更新系
//
//-----------------------------------------------------------------------------------------------------------------

// -- プレイヤーの移動フェイズ
- (void)move_player:(DLPoint)pos
{
    [self update_route_map:pos target:player.pos];
    DLPoint next_pos = [self get_player_pos:player.pos];
    self->player.pos = next_pos;
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

- (BOOL)execute_one_turn:(DLPoint)pos
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

// -- おおもとのやつ
-(BOOL)on_hit:(DLPoint)pos
{
    return [self execute_one_turn:pos]; // TODO: プレイヤーの座標を指定しないといけない
}

-(void)_clear_if_dead
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
    [self _clear_if_dead];
    [self updateCanTap:self->player.pos];
}


//-----------------------------------------------------------------------------------------------------------------
//
// getter/setter
//
//-----------------------------------------------------------------------------------------------------------------

// TODO: set は最初だけにしよう、置き換えるんじゃなくて、作成済みのデータを変更しよう
// 上はなぜ？
-(void)set_without_update_can_tap:(DLPoint)pos block:(BlockModel*)block
{
    block.pos = pos;
    [self->map set_x:pos.x y:pos.y value:block];
    [self update_group_info:pos group_id:block.group_id];
}

-(void)set:(DLPoint)pos block:(BlockModel*)block
{
    [self set_without_update_can_tap:pos block:block];

    // この一行いらんかも
    [self updateCanTap:self->player.pos]; // TODO: プレイヤーの座標を指定しないといけない
    
    // ここで NEW イベント飛ばす
    DLEvent *e = [DLEvent eventWithType:DL_ON_NEW target:block];
    [self dispatchEvent:e];
}

// 完璧
-(BlockModel*)get:(DLPoint)pos
{
    return [self->map get_x:pos.x y:pos.y];
}

// 完璧
-(int)can_tap:(DLPoint)pos
{
    BlockModel* b = [self->map get_x:pos.x y:pos.y];
    return b.can_tap;
}

-(void)load_from_file:(NSString*)filename
{
    DungeonLoader *loader = [[DungeonLoader alloc] initWithDungeonModel:self];
    [loader load_from_file:filename];
    [self updateCanTap:self->player.pos];
}

//------------------------------------------------------------------------------
static int max_num = 12;

static int block_id_list[] = {
    ID_EMPTY,
    ID_NORMAL_BLOCK,
    ID_GROUPED_BLOCK_1,
    ID_GROUPED_BLOCK_2,
    ID_GROUPED_BLOCK_3,
    ID_UNBREAKABLE_BLOCK,
    
    ID_ENEMY_BLOCK_0, // BLUE SLIME
    ID_ENEMY_BLOCK_1, // RED  SLIME
    
    ID_ITEM_BLOCK_0, // POTION
    ID_ITEM_BLOCK_1, // DORAYAKI
    ID_ITEM_BLOCK_2, // TREASURE
    
    ID_PLAYER
};

-(void)load_random:(UInt16)seed
{
    for (int j = 0; j < DM_HEIGHT; j++) {
        for (int i = 0; i < DM_WIDTH; i++) {
            
            BlockModel *b;
            // ４列目までは空ならのでスキップ
        if (j < 4) {
                b = [self->block_builder buildWithID:ID_EMPTY];
            } else if (j == 4) {
                if (i == 3) {
                    b = [self->block_builder buildWithID:ID_EMPTY];
                } else {
                    b = [self->block_builder buildWithID:ID_UNBREAKABLE_BLOCK];
                }
            } else if (i == 0 || i == (DM_WIDTH -1)) {
                b = [self->block_builder buildWithID:ID_UNBREAKABLE_BLOCK];
            } else {
                int index = random() % (max_num - 2);
                int type_id = block_id_list[index];
                b = [self->block_builder buildWithID:type_id];
            }
            
            [self set_without_update_can_tap:cdp(i, j) block:b];
        }
    }
    [self updateCanTap:self->player.pos];
}



// ここからはほぼ変更なし ========================================================================




//===========================================================================================
// TODO: 別クラス化
// ダンジョンのブロックの状態や経路探索の結果を更新するメソッド群
// インターフェイスは、ほぼ変更されることはないだろう
// 高速化くらいはやる
//===========================================================================================

//===========================================================================================
//
// タップ可能ブロックの情報を更新
//
//===========================================================================================

-(void)updateCanTap:(DLPoint)pos
{
    [self->impl updateCanTap:self->map start:pos];
    self->lowest_empty_y = self->impl.lowestEmptyY;
}

//===========================================================================================
//
// ブロック同士のグループ情報を更新
//
//===========================================================================================

-(void)update_group_info:(DLPoint)pos group_id:(unsigned int)_group_id;
{
    DungeonModelGroupInfoUpdater *groupUpdater = [DungeonModelGroupInfoUpdater new];
    [groupUpdater updateGroupInfo:self->map start:pos groupId:_group_id];
    [groupUpdater release];
}

//===========================================================================================
//
// 移動ルート情報を更新
//
//===========================================================================================

-(void) update_route_map:(DLPoint)pos target:(DLPoint)target
{
    [self->route_map fill:999];
    [self update_route_map_r:pos target:target level:0];
}

-(void) update_route_map_r:(DLPoint)pos target:(DLPoint)target level:(int)level
{
    // ゴール以降は探索しない
    //    if (pos.x == target.x && pos.y == target.y) {
    //        [self->route_map set_x:pos.x y:pos.y value:level];
    //        return;
    //    }
    
    // ブロックの場合はそれ以上探索しない
    // ただし level = 0 （最初の一回目は）例外
    BlockModel* b = [self->map get_x:pos.x y:pos.y];
    if (b.block_id != ID_EMPTY && level != 0) return;
    
    int cost = [self->route_map get_x:pos.x y:pos.y];
    
    // 画面外は -1 が返る
    // 画面外なら、それ以上探索しない
    if (cost < 0) return;
    
    // 計算済みの cost が同じか小さい場合探索しない
    if (cost <= level) return;
    
    [self->route_map set_x:pos.x y:pos.y value:level];
    
    [self update_route_map_r:cdp(pos.x + 0, pos.y - 1) target:target level: level + 1];
    [self update_route_map_r:cdp(pos.x + 0, pos.y + 1) target:target level: level + 1];
    [self update_route_map_r:cdp(pos.x - 1, pos.y + 0) target:target level: level + 1];
    [self update_route_map_r:cdp(pos.x + 1, pos.y + 0) target:target level: level + 1];
}


//===========================================================================================
//
// 移動ルート情報から実際に辿るブロックのリストを作る
//
//===========================================================================================

// かならず 1 に辿り着けることを期待してるね
// TODO: ここの実装ひどい
-(DLPoint) _get_player_pos:(DLPoint)pos
{
    //# ゴールなので座標を返す
    int cost = [self->route_map get:pos];
    if (cost == 1) return pos;
    // 移動なし
    // TODO: マジックナンバー(>_<)
    if (cost == 999) return pos;
    
    DLPoint u_pos = cdp(pos.x + 0, pos.y - 1);
    DLPoint d_pos = cdp(pos.x + 0, pos.y + 1);
    DLPoint l_pos = cdp(pos.x - 1, pos.y + 0);
    DLPoint r_pos = cdp(pos.x + 1, pos.y + 0);
    int u_cost = [self->route_map get:u_pos];
    int d_cost = [self->route_map get:d_pos];
    int l_cost = [self->route_map get:l_pos];
    int r_cost = [self->route_map get:r_pos];
    u_cost = u_cost < 0 ? 999 : u_cost;
    d_cost = d_cost < 0 ? 999 : d_cost;
    l_cost = l_cost < 0 ? 999 : l_cost;
    r_cost = r_cost < 0 ? 999 : r_cost;
    
    NSArray *cost_list = [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:l_cost],
                          [NSNumber numberWithInt:r_cost],
                          [NSNumber numberWithInt:d_cost],
                          [NSNumber numberWithInt:u_cost],
                          nil];
    
    int min_cost = l_cost;
    int index = 0;
    for (int i = 1; i < 4; i++) {
        int cost = [[cost_list objectAtIndex:i] intValue];
        if (cost < min_cost) {
            min_cost = cost;
            index = i;
        }
    }
    
    DLPoint out_pos;
    switch (index) {
        case 0:
            out_pos = l_pos;
            break;
        case 1:
            out_pos = r_pos;
            break;
        case 2:
            out_pos = d_pos;
            break;
        case 3:
            out_pos = u_pos;
            break;
        default:
            break;
    }
    
    [self->route_list addObject:[NSValue valueWithBytes:&out_pos objCType:@encode(DLPoint)]];
    
    return [self _get_player_pos:out_pos];
}

-(DLPoint) get_player_pos:(DLPoint)pos
{
    [self->route_list removeAllObjects];
    return [self _get_player_pos:pos];
}

@end
