//
//  TileMap.m
//  Dri
//
//  Created by  on 12/08/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TileMap.h"

//static int test_map[6][5] = {
//    {1,1,0,1,1},
//    {1,1,0,1,1},
//    {1,1,1,1,1},
//    {1,1,1,1,1},
//    {1,1,1,1,1},
//    {1,1,1,1,1},
//};

@implementation TileMap

-(id) init
{
	if( (self=[super init]) ) {
        bound_w  = 5;
        bound_h =  10;
    }
    return self;
}
    
//-(void)copy_array
//{
//    for (int j = 0; j < bound_h; j++) {
//        for (int i = 0; i < bound_w; i++) {
//            self->tile_map[j][i] = test_map[j][i];
//        }
//    }
//}

-(void)fill:(int)value
{
    for (int j = 0; j < bound_h; j++) {
        for (int i = 0; i < bound_w; i++) {
            self->tile_map[j][i] = value;
        }
    }
}

-(void)clear
{
    [self fill:0];
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
    if (_x >= bound_w) return YES;
    if (_y <  0) return YES;
    if (_y >= bound_h) return YES;
    return NO;
}

@end
