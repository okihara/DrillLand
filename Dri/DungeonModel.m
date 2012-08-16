//
//  DungeonModel.m
//  Dri
//
//  Created by  on 12/08/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DungeonModel.h"
#import "HelloWorldLayer.h"

@implementation DungeonModel

-(id) init:(NSArray*)initial
{
    if (self = [super init]) {
        self->map = [[TileMap alloc] init];
        self->can_map = [[TileMap alloc] init];
        self->done_map = [[TileMap alloc] init];
        [map fill:1];
        [map set_value:2 y:0 value:0];
        [map set_value:2 y:1 value:0];
        [map set_value:2 y:2 value:0];
        [map set_value:2 y:3 value:0];

    }
    return self;
}

-(void) dealloc
{
    [self->map release];
    [self->can_map release];
    [self->done_map release];
    [super dealloc];
}

-(void) add_observer:(id)_observer
{
    self->observer = _observer;
}

-(void) make_can_destroy_map:(CGPoint)pos
{
    // 起点は 0 でなければならない
    if ( [self->map get_value:(int)pos.x y:(int)pos.y] == 1 ) return;
    
    // 操作済み判別テーブルを初期化
    [done_map clear];
    
    // チェック処理本体
    [self chk_by_recursive:pos];
}

-(void) chk_by_recursive:(CGPoint)pos
{
    int x = (int)pos.x;
    int y = (int)pos.y;
    
    if ([self->done_map get_value:x y:y] != 0) {
        return;
    }
    
    if ([self->map get_value:x y:y] == 1) {
        [can_map set_value:x y:y value:1];
        [done_map set_value:x y:y value:1];
    } else if ([self->map get_value:x y:y] == 0) {
        [can_map set_value:x y:y value:0];
        [done_map set_value:x y:y value:1];
        [self chk_by_recursive:ccp(x, y - 1)];
        [self chk_by_recursive:ccp(x, y + 1)];
        [self chk_by_recursive:ccp(x + 1, y)];
        [self chk_by_recursive:ccp(x - 1, y)];
    }
}

-(void) erase:(CGPoint)pos
{
    int x = (int)pos.x;
    int y = (int)pos.y;
    
    if ([self->can_map get_value:x y:y] == 0) {
        NSLog(@"can not destroy me!");
        return;
    }
    
    [self set_state:pos type:0];
}

-(void) set_state:(CGPoint)pos type:(int)_type
{
    [self->map set_value:(int)pos.x y:(int)pos.y value:_type];
    [self make_can_destroy_map:ccp(2, 0)]; // TODO:

    [self->observer notify:self];
}

-(int) get_value:(int)_x y:(int)_y
{
    return [self->map get_value:_x y:_y];
}

-(int) get_can_value:(int)_x y:(int)_y
{
    return [self->can_map get_value:_x y:_y];
}

@end
