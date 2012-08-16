//
//  DungeonModel.h
//  Dri
//
//  Created by  on 12/08/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TileMap.h"

//#define H 6
//#define W 5

@interface DungeonModel : NSObject
{
    TileMap *map;
    TileMap *can_map;
    TileMap *done_map;
    
    id observer;
}

-(id) init:(NSArray*)initial;
-(void) add_observer:(id)observer;
-(void) make_can_destroy_map:(CGPoint)pos;
-(void) chk_by_recursive:(CGPoint)pos;
-(void) erase:(CGPoint)pos;
-(void) set_state:(CGPoint)pos type:(int)_type;
-(int) get_value:(int)_x y:(int)_y;
-(int) get_can_value:(int)_x y:(int)_y;

@end
