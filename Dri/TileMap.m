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
    NSLog(@"-----------------------");
    
    for (int j = 0; j < 6; j++) {
        for (int i = 0; i < 5; i++) {
            NSLog(@"%d, %d, %d", i, j, test_map[j][i]);
            
            self->tile_map[j][i] = test_map[j][i];
        }
    }
}

-(int)get_value:(int)_x y:(int)_y
{
    return tile_map[_y][_x];
}

-(void)set_value:(int)_x y:(int)_y value:(int)_value
{
    tile_map[_y][_x] = _value;
}

@end
