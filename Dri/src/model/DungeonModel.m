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


@implementation DungeonModel

@synthesize route_map;
@synthesize player;
@synthesize route_list;
@synthesize lowest_empty_y;

- (id)init
{
    if (self = [super init]) {
        self->block_builder = [[BlockBuilder alloc] init];
        self->player = [block_builder buildWithID:ID_PLAYER];
        self->done_map = [[XDMap alloc] init];
        self->route_map = [[XDMap alloc] init];
        self->route_list = [[NSMutableArray alloc] init];
        self->map = [[ObjectXDMap alloc] init];
        [self _fill_blocks];
        
        self->lowest_empty_y = 5;
    }
    return self;
}

-(void) dealloc
{
    [self->map release];
    [self->route_map release];
    [self->route_list release];
    [self->done_map release];
    [self->player release];
    [self->block_builder release];
    [super dealloc];
}

//-----------------------------------------------------------------------------------------------------------------
//
// 通知系
//
//-----------------------------------------------------------------------------------------------------------------

-(void) add_observer:(id<DungenModelObserver>)observer_
{
    self->observer = observer_;
}

-(void)on_update
{
    for (int j = 0; j < HEIGHT; j++) {
        for (int i = 0; i < WIDTH; i++) {
            BlockModel* b = [self get:cdp(i, j)];
            [b on_update:self];
        }
    }
}

- (void)on_hit_block:(DLPoint)pos
{
    // -- ブロックのヒット処理フェイズ
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

- (void)move_player:(DLPoint)pos
{
    // -- プレイヤーの移動フェイズ
    [self update_route_map:pos target:player.pos];
    DLPoint next_pos = [self get_player_pos:player.pos];
    self->player.pos = next_pos;
}

-(BOOL) on_hit:(DLPoint)pos
{
    BlockModel* target = [self get:pos];
    
    // タップできない（ターン消費無し）
    if (target.type == ID_EMPTY) {
        return NO;
    }
    if (target.can_tap == NO) {
        DLEvent* event = [DLEvent eventWithType:DL_ON_CANNOT_TAP target:target];
        [self->observer notify:self event:event];
        return NO;
    }
    
    // PLAYER の移動
    [self move_player:pos];

    // ブロックのヒットフェイズ
    [self on_hit_block:pos];
    
    // ブロックのアップデートフェイズ
    [self on_update];
    
    // ここはシーンから呼ぶほうがいいか
    // フロアの情報が変わったので更新＆通知
    [self update_can_tap:self->player.pos]; // TODO: プレイヤーの座標を指定しないといけない
    
    return YES;
}

-(void) dispatchEvent:(DLEvent*)e
{
    [self->observer notify:self event:e];
}

//-----------------------------------------------------------------------------------------------------------------
//
// getter/setter
//
//-----------------------------------------------------------------------------------------------------------------

// TODO: set は最初だけにしよう、置き換えるんじゃなくて、作成済みのデータを変更しよう
-(void) _set:(DLPoint)pos block:(BlockModel*)block
{
    block.pos = pos;
    [self->map set_x:pos.x y:pos.y value:block];
    [self update_group_info:pos group_id:block.group_id];
}

-(void) set:(DLPoint)pos block:(BlockModel*)block
{
    [self _set:pos block:block];
    [self update_can_tap:self->player.pos]; // TODO: プレイヤーの座標を指定しないといけない
}

-(BlockModel*)get:(DLPoint)pos
{
    return [self->map get_x:pos.x y:pos.y];
}

-(int)can_tap:(DLPoint)pos
{
    BlockModel* b = [self->map get_x:pos.x y:pos.y];
    return b.can_tap;
}

//---------------------------------------------------

-(void)load_from_file:(NSString*)filename
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
    NSString *jsonData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    id jsonItem = [jsonData JSONValue];
    NSArray* layers = [(NSDictionary*)jsonItem objectForKey:@"layers"];
    NSArray* data = [[layers objectAtIndex:0] objectForKey:@"data"];
    
    NSArray *tilesets = [(NSDictionary*)jsonItem objectForKey:@"tilesets"];
    NSDictionary* tileset = [tilesets objectAtIndex:0];
    NSDictionary* tileproperties = [tileset objectForKey:@"tileproperties"];
    
    int width  = [[jsonItem objectForKey:@"width"] integerValue];
    //int height = [[jsonItem objectForKey:@"height"] integerValue];

    for (int j = 0; j < HEIGHT; j++) {
        for (int i = 0; i < width; i++) {
            
            BlockModel* b;
            int b_ind = [[data objectAtIndex:i + j * width] integerValue];
            if (b_ind == 0 || b_ind == 1) {
                b = [block_builder buildWithID:ID_NORMAL_BLOCK];
                b.type = 0;
            } else {
                NSDictionary* prop = [tileproperties objectForKey:[NSString stringWithFormat:@"%d", b_ind-1]];
                int type_id = [[prop objectForKey:@"type"] intValue];
                b = [block_builder buildWithID:type_id];
            }
            [self _set:cdp(i, j) block:b];
            
        }
    }
 
    [self update_can_tap:self->player.pos]; // TODO: プレイヤーの座標を指定しないといけない
}

-(void)_fill_blocks
{
    for (int j = 0; j < HEIGHT; j++) {
        for (int i = 0; i < WIDTH; i++) {
            BlockModel* b = [[BlockModel alloc] init];
            b.type = ID_NORMAL_BLOCK;
            [self set:cdp(i, j) block:b];
        }
    }
}

-(void)_clear_can_tap
{
    for (int j = 0; j < HEIGHT; j++) {
        for (int i = 0; i < WIDTH; i++) {
            BlockModel* b = [self->map get_x:i y:j];
            b.can_tap = NO;
        }
    }
}


//===========================================================================================
// ダンジョンのブロックの状態や経路探索の結果を更新するメソッド群
// インターフェイスは、ほぼ変更されることはないだろう
// 高速化くらいはやる
//===========================================================================================

-(void) update_can_tap:(DLPoint)pos
{
    int x = (int)pos.x;
    int y = (int)pos.y;
    
    // 起点は 0 でなければならない
    BlockModel* b = [self->map get_x:x y:y]; 
    if ( b.type > 0 ) return;
    
    // 操作済み判別テーブルを初期化
    [done_map clear];
    
    // タップ可能かどうかを初期化
    [self _clear_can_tap];
    
    // チェック処理本体
    [self update_can_tap_r:pos];
}

-(void) update_can_tap_r:(DLPoint)pos
{
    int x = (int)pos.x;
    int y = (int)pos.y;
    
    if ([self->done_map get_x:x y:y] != 0) return;
    
    BlockModel* b = [self->map get_x:x y:y];
    if (!b) return;
    
    [done_map set_x:x y:y value:1];
    if (b.type != ID_EMPTY) {
        b.can_tap = YES;
    } else if (b.type == ID_EMPTY) {
        b.can_tap = NO;
        [self update_can_tap_r:cdp(x + 0, y + 1)];
        [self update_can_tap_r:cdp(x + 0, y - 1)];
        [self update_can_tap_r:cdp(x + 1, y + 0)];
        [self update_can_tap_r:cdp(x - 1, y + 0)];
        

        // スクロール用に 一番下の 空ブロックを記録しておく
        if (b.pos.y > self->lowest_empty_y) {
            self->lowest_empty_y = b.pos.y;
        }
        
        
    } else {
        // マイナスの時は？？
    }
}

-(void) update_group_info:(DLPoint)pos group_id:(unsigned int)_group_id
{
    // group_id=0 の時はグループ化しない
    if (_group_id == 0) return;
    
    [self->done_map clear];
    NSMutableArray* group_info = [[NSMutableArray alloc] init];
    [self update_group_info_r:pos group_id:_group_id group_info:group_info];
    //NSLog(@"group_info %d %@", _group_id, group_info);
}

-(void) update_group_info_r:(DLPoint)pos group_id:(unsigned int)_group_id group_info:(NSMutableArray*)_group_info
{
    int x = (int)pos.x;
    int y = (int)pos.y;
    
    // もうみた
    if ([done_map get_x:x y:y] != 0) return;
    
    // おかしい
    BlockModel* b = [map get_x:x y:y];
    if (b == NULL) return;
    
    // みたよ
    [done_map set_x:x y:y value:1];
    
    // 同じじゃないならなにもしない
    if (b.group_id != _group_id) return;
    
    //
    if(b.group_info != NULL) {
        // TODO:メモリリーク
        //[b.group_info release];
    }
    [_group_info addObject:b];
    b.group_info = _group_info;
    
    [self update_group_info_r:cdp(x + 0, y + 1) group_id:_group_id group_info:_group_info];
    [self update_group_info_r:cdp(x + 0, y - 1) group_id:_group_id group_info:_group_info];
    [self update_group_info_r:cdp(x + 1, y + 0) group_id:_group_id group_info:_group_info];
    [self update_group_info_r:cdp(x - 1, y + 0) group_id:_group_id group_info:_group_info];
}

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
    if (b.type != ID_EMPTY && level != 0) return;
    
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
