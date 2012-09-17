//
//  TileMap.m
//  Dri
//
//  Created by  on 12/08/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XDMap.h"

@implementation XDMap

-(id) init
{
	if( (self=[super init]) ) {
        bound_w  = 5;
        bound_h =  CAP_H;
    }
    return self;
}

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

-(int)get:(DLPoint)pos
{
    if ([self is_outbound:pos.x y:pos.y]) {
        return -1;
    }
    return tile_map[pos.y][pos.x];
}

-(int)get_x:(int)_x y:(int)_y
{
    return [self get:cdp(_x, _y)];
}    

-(void)set:(DLPoint)pos value:(int)_value
{
    if ([self is_outbound:pos.x y:pos.y]) {
        return;
    }
    tile_map[pos.y][pos.x] = _value;
}

-(void)set_x:(int)_x y:(int)_y value:(int)_value
{
    [self set:cdp(_x, _y) value:_value];
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





/////////////////////////////////////////////////////////////////////




@implementation ObjectXDMap

-(id) init
{
	if( (self=[super init]) ) {
        bound_w  = 5;
        bound_h =  CAP_H;
        [self clear];
    }
    return self;
}

-(void)fill:(id)value
{
    for (int j = 0; j < bound_h; j++) {
        for (int i = 0; i < bound_w; i++) {
            self->tile_map[j][i] = value;
        }
    }
}

-(void)clear
{
    [self fill:NULL];
}

-(id)get_x:(int)_x y:(int)_y
{
    if ([self is_outbound:_x y:_y]) {
        return NULL;
    }
    return tile_map[_y][_x];
}

-(void)set_x:(int)_x y:(int)_y value:(id)_value
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

