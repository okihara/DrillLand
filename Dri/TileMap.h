//
//  TileMap.h
//  Dri
//
//  Created by  on 12/08/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TileMap : NSObject
{
    int tile_map[10][10];
    int bound_w;
    int bound_h;
}

-(void)copy_array;
-(int)get_value:(int)_x y:(int)_y;
-(void)set_value:(int)_x y:(int)_y value:(int)_value;

@end
