//
//  DungeonModel.m
//  Dri
//
//  Created by  on 12/08/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DungeonModel.h"

@implementation DungeonModel

-(id) init:(NSArray*)initial
{
    if (self = [super init]) {
        self->map = [[TileMap alloc] init];
        self->can_map = [[TileMap alloc] init];
        self->done_map = [[TileMap alloc] init];
        [map fill:1];
        [map set_x:2 y:0 value:0];
        [map set_x:2 y:1 value:0];
        [map set_x:2 y:2 value:0];
        [map set_x:2 y:3 value:0];

    }
    return self;
}

-(void) add_observer:(id<DungenModelObserver>)_observer
{
    self->observer = _observer;
}

-(void) erase:(CGPoint)pos
{
    int x = (int)pos.x;
    int y = (int)pos.y;
    
    if ([self->can_map get_x:x y:y] == 0) {
        NSLog(@"can not destroy me!");
        return;
    }
    
    [self set_state:pos type:0];
}

-(void) set_state:(CGPoint)pos type:(int)_type
{
    [self->map set_x:(int)pos.x y:(int)pos.y value:_type];
    [self update_can_tap_map:ccp(2, 0)]; // TODO: プレイヤーの座標を指定しないといけない
    
    [self->observer notify:self];
}

-(void) update_can_tap_map:(CGPoint)pos
{
    // 起点は 0 でなければならない
    if ( [self->map get_x:(int)pos.x y:(int)pos.y] == 1 ) return;
    
    // 操作済み判別テーブルを初期化
    [done_map clear];
    
    // チェック処理本体
    [self check_can_tap_r:pos];
}

-(void) check_can_tap_r:(CGPoint)pos
{
    int x = (int)pos.x;
    int y = (int)pos.y;
    
    if ([self->done_map get_x:x y:y] != 0) {
        return;
    }
    
    [done_map set_x:x y:y value:1];
    if ([self->map get_x:x y:y] == 1) {
        [can_map set_x:x y:y value:1];
    } else if ([self->map get_x:x y:y] == 0) {
        [can_map set_x:x y:y value:0];
        [self check_can_tap_r:ccp(x, y - 1)];
        [self check_can_tap_r:ccp(x, y + 1)];
        [self check_can_tap_r:ccp(x + 1, y)];
        [self check_can_tap_r:ccp(x - 1, y)];
    }
}

-(int) get_x:(int)_x y:(int)_y
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
