//
//  DungeonModel.m
//  Dri
//
//  Created by  on 12/08/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DungeonModel.h"
#import "BlockBase.h"

@implementation DungeonModel

-(void)_fill_blocks
{
    int disp_w = 5;
    int disp_h = 10;
    for (int j = 0; j < disp_h; j++) {
        for (int i = 0; i < disp_w; i++) {
            BlockBase* b = [[BlockBase alloc] init];
            b.type = 1;
            [self set:ccp(i, j) type:b];
        }
    }
}

-(id) init:(NSArray*)initial
{
    if (self = [super init]) {

        self->done_map = [[TileMap alloc] init];
        self->map = [[TileMap2 alloc] init];
        self->can_map = [[TileMap alloc] init];
        [self _fill_blocks];
        
        // dummy
        BlockBase* b;
        
        b = [[BlockBase alloc] init];
        b.type = 0;
        [self set:ccp(2, 0) type:(id)b];

        b = [[BlockBase alloc] init];
        b.type = 0;
        [self set:ccp(2, 1) type:(id)b];
        
        b = [[BlockBase alloc] init];
        b.type = 0;
        [self set:ccp(2, 2) type:(id)b];
        
        b = [[BlockBase alloc] init];
        b.type = 0;
        [self set:ccp(2, 3) type:(id)b];
    }
    return self;
}

-(void) add_observer:(id<DungenModelObserver>)_observer
{
    self->observer = _observer;
}

-(void) hit:(CGPoint)pos
{
    int x = (int)pos.x;
    int y = (int)pos.y;
    
    if ([self->can_map get_x:x y:y] == 0) {
        NSLog(@"can not destroy me!");
        return;
    }
    
    BlockBase* b = [[BlockBase alloc] init];
    b.type = 0;
    [self set:pos type:b];
}

-(void) set:(CGPoint)pos type:(id)_type
{
    [self->map set_x:(int)pos.x y:(int)pos.y value:_type];
    [self update_can_tap:ccp(2, 0)]; // TODO: プレイヤーの座標を指定しないといけない
    [self->observer notify:self];
}

-(void) update_can_tap:(CGPoint)pos
{
    int x = (int)pos.x;
    int y = (int)pos.y;
    
    // 起点は 0 でなければならない
    BlockBase* b = [self->map get_x:x y:y]; 
    if ( b.type == 1 ) return;
    
    // 操作済み判別テーブルを初期化
    [done_map clear];
    
    // チェック処理本体
    [self update_can_tap_r:pos];
}

-(void) update_can_tap_r:(CGPoint)pos
{
    int x = (int)pos.x;
    int y = (int)pos.y;
    
    if ([self->done_map get_x:x y:y] != 0) {
        return;
    }
    
    BlockBase* b = [self->map get_x:x y:y];
    if (!b) return;
    
    [done_map set_x:x y:y value:1];
    if (b.type == 1) {
        [can_map set_x:x y:y value:1];
    } else if (b.type == 0) {
        [can_map set_x:x y:y value:0];
        [self update_can_tap_r:ccp(x + 0, y - 1)];
        [self update_can_tap_r:ccp(x + 0, y + 1)];
        [self update_can_tap_r:ccp(x + 1, y + 0)];
        [self update_can_tap_r:ccp(x - 1, y + 0)];
    }
}

-(BlockBase*) get_x:(int)_x y:(int)_y
{
    return [self->map get_x:_x y:_y];
}

-(int) can_tap_x:(int)_x y:(int)_y
{
    return [self->can_map get_x:_x y:_y];
}

-(void) dealloc
{
    [self->map release];
    [self->can_map release];
    [self->done_map release];
    [super dealloc];
}

@end
