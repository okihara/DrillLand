//
//  DungeonModel.m
//  Dri
//
//  Created by  on 12/08/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DungeonModel.h"
#import "BlockModel.h"

@implementation DungeonModel

-(void)_fill_blocks
{
    int disp_w = 5;
    int disp_h = 10;
    for (int j = 0; j < disp_h; j++) {
        for (int i = 0; i < disp_w; i++) {
            BlockModel* b = [[BlockModel alloc] init];
            b.type = 1;
            [self set:ccp(i, j) block:b];
        }
    }
}

-(void)_clear_can_tap
{
    int disp_w = 5;
    int disp_h = 10;
    for (int j = 0; j < disp_h; j++) {
        for (int i = 0; i < disp_w; i++) {
            BlockModel* b = [self->map get_x:i y:j];
            b.can_tap = NO;
        }
    }   
}

-(id) init:(NSArray*)initial
{
    if (self = [super init]) {

        self->done_map = [[TileMap alloc] init];
        self->map = [[TileMap2 alloc] init];
        [self _fill_blocks];
        
        // dummy
        BlockModel* b;

        // 消えない
        b = [[BlockModel alloc] init];
        b.type = 99;
        b.hp = -1;
        [self set:ccp(0, 7) block:(id)b];
        b = [[BlockModel alloc] init];
        b.type = 99;
        b.hp = -1;
        [self set:ccp(1, 7) block:(id)b];
        
        b = [[BlockModel alloc] init];
        b.type = 99;
        b.hp = -1;
        [self set:ccp(2, 7) block:(id)b];
        
        //
        b = [[BlockModel alloc] init];
        b.type = 0;
        [self set:ccp(2, 0) block:(id)b];

        b = [[BlockModel alloc] init];
        b.type = 0;
        [self set:ccp(2, 1) block:(id)b];
        
        b = [[BlockModel alloc] init];
        b.type = 0;
        [self set:ccp(2, 2) block:(id)b];
        
        b = [[BlockModel alloc] init];
        b.type = 0;
        [self set:ccp(2, 3) block:(id)b];

        // グループ消しサンプル
        b = [[BlockModel alloc] init];
        b.type = 2;
        b.group_id = 1;
        [self set:ccp(1, 2) block:(id)b];
        
        b = [[BlockModel alloc] init];
        b.type = 2;
        b.group_id = 1;
        [self set:ccp(2, 2) block:(id)b];
        
        b = [[BlockModel alloc] init];
        b.type = 2;
        b.group_id = 1;
        [self set:ccp(2, 3) block:(id)b];

        // グループ消しサンプル2
        b = [[BlockModel alloc] init];
        b.type = 3;
        b.group_id = 1;
        [self set:ccp(3, 4) block:(id)b];
        
        b = [[BlockModel alloc] init];
        b.type = 3;
        b.group_id = 1;
        [self set:ccp(3, 5) block:(id)b];
        
        b = [[BlockModel alloc] init];
        b.type = 3;
        b.group_id = 1;
        [self set:ccp(3, 6) block:(id)b];
        
        b = [[BlockModel alloc] init];
        b.type = 3;
        b.group_id = 1;
        [self set:ccp(3, 7) block:(id)b];
        
        // グループ消しサンプル3
        b = [[BlockModel alloc] init];
        b.type = 4;
        b.group_id = 2;
        [self set:ccp(0, 8) block:(id)b];
        
        b = [[BlockModel alloc] init];
        b.type = 4;
        b.group_id = 2;
        [self set:ccp(1, 8) block:(id)b];
        
        b = [[BlockModel alloc] init];
        b.type = 4;
        b.group_id = 2;
        [self set:ccp(2, 8) block:(id)b];
        
        b = [[BlockModel alloc] init];
        b.type = 4;
        b.group_id = 2;
        b.hp = 2;
        [self set:ccp(3, 8) block:(id)b];
        
        b = [[BlockModel alloc] init];
        b.type = 4;
        b.group_id = 2;
        [self set:ccp(4, 8) block:(id)b];    
    }
    return self;
}

-(void) add_observer:(id<DungenModelObserver>)_observer
{
    self->observer = _observer;
}

-(void) _hit:(BlockModel*)b
{
    [b hit];
    
    [self update_group_info:ccp(b.x, b.y) group_id:b.group_id];
    [self update_can_tap:ccp(2, 0)]; // TODO: プレイヤーの座標を指定しないといけない
    [self->observer notify_particle:b];
    [self->observer notify:self];
}


-(void) hit:(CGPoint)pos
{
    int x = (int)pos.x;
    int y = (int)pos.y;

    BlockModel* b = [self get_x:x y:y];
    
    if (b.can_tap == NO) {
        NSLog(@"can not destroy me!");
        return;
    }

    if (b.group_info) {
        for (id block in b.group_info) {
            [self _hit:block];
        }
    } else {
        [self _hit:b];
    }

}

// TODO: set は最初だけにしよう、置き換えるんじゃなくて、作成済みのデータを変更しよう
-(void) set:(CGPoint)pos block:(BlockModel*)block
{
    int x = (int)pos.x;
    int y = (int)pos.y;
    
    block.x = x;
    block.y = y;
    
    [self->map set_x:x y:y value:block];
    [self update_group_info:pos group_id:block.group_id];
    [self update_can_tap:ccp(2, 0)]; // TODO: プレイヤーの座標を指定しないといけない
    [self->observer notify:self];
}

-(void) update_can_tap:(CGPoint)pos
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

-(void) update_can_tap_r:(CGPoint)pos
{
    int x = (int)pos.x;
    int y = (int)pos.y;
    
    if ([self->done_map get_x:x y:y] != 0) return;
    
    BlockModel* b = [self->map get_x:x y:y];
    if (!b) return;
    
    [done_map set_x:x y:y value:1];
    if (b.type > 0) {
        b.can_tap = YES;
    } else if (b.type == 0) {
        b.can_tap = NO;
        [self update_can_tap_r:ccp(x + 0, y + 1)];
        [self update_can_tap_r:ccp(x + 0, y - 1)];
        [self update_can_tap_r:ccp(x + 1, y + 0)];
        [self update_can_tap_r:ccp(x - 1, y + 0)];
    } else {
        // マイナスの時は？？
    }
}

-(void) update_group_info:(CGPoint)pos group_id:(unsigned int)_group_id
{
    // group_id=0 の時はグループ化しない
    if (_group_id == 0) return;
    [self->done_map clear];
    NSMutableArray* group_info = [[NSMutableArray alloc] init];
    [self update_group_info_r:pos group_id:_group_id group_info:group_info];
    NSLog(@"group_info %d %@", _group_id, group_info);
}

-(void) update_group_info_r:(CGPoint)pos group_id:(unsigned int)_group_id group_info:(NSMutableArray*)_group_info
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
    
    [self update_group_info_r:ccp(x + 0, y + 1) group_id:_group_id group_info:_group_info];
    [self update_group_info_r:ccp(x + 0, y - 1) group_id:_group_id group_info:_group_info];
    [self update_group_info_r:ccp(x + 1, y + 0) group_id:_group_id group_info:_group_info];
    [self update_group_info_r:ccp(x - 1, y + 0) group_id:_group_id group_info:_group_info];
}

-(BlockModel*) get_x:(int)_x y:(int)_y
{
    return [self->map get_x:_x y:_y];
}

-(int) can_tap_x:(int)_x y:(int)_y
{
    BlockModel* b = [self->map get_x:_x y:_y];
    return b.can_tap;
}

-(void) dealloc
{
    [self->map release];
    [self->done_map release];
    [super dealloc];
}

@end
