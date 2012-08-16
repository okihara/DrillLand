//
//  TileMap.m
//  Dri
//
//  Created by  on 12/08/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TileMap.h"

static int test_map[6][5] = {
    {1,1,0,1,1},
    {1,1,0,1,1},
    {1,1,1,1,1},
    {1,1,1,1,1},
    {1,1,1,1,1},
    {1,1,1,1,1},
};

@implementation TileMap

-(void)copy_array
{
    for (int j = 0; j < 6; j++) {
        for (int i = 0; i < 5; i++) {
            NSLog(@"%d, %d, %d", i, j, test_map[j][i]);
            
            self->tile_map[j][i] = test_map[j][i];
        }
    }
}

-(void)clear
{
    for (int j = 0; j < 6; j++) {
        for (int i = 0; i < 5; i++) {
            self->tile_map[j][i] = 0;
        }
    }
}

-(int)get_value:(int)_x y:(int)_y
{
    if ([self is_outbound:_x y:_y]) {
        return -1;
    }
    return tile_map[_y][_x];
}

-(void)set_value:(int)_x y:(int)_y value:(int)_value
{
    if ([self is_outbound:_x y:_y]) {
        return;
    }
    tile_map[_y][_x] = _value;
}

-(BOOL)is_outbound:(int)_x y:(int)_y
{
    if (_x <  0) return YES;
    if (_x >= W) return YES;
    if (_y <  0) return YES;
    if (_y >= H) return YES;
    return NO;
}

@end
