//
//  DungeonModel.h
//  Dri
//
//  Created by  on 12/08/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TileMap.h"
#import "BlockModel.h"

#define WIDTH 5
#define HEIGHT 17

@class DungeonModel;
@protocol DungenModelObserver <NSObject>

-(void) notify:(DungeonModel*)_dungeon;
-(void) notify_particle:(BlockModel*)block;

@end

@interface DungeonModel : NSObject
{
    TileMap2 *map;
    TileMap *done_map;
    TileMap *route_map;
    id<DungenModelObserver> observer;
}

-(id) init:(NSArray*)initial;
-(void) add_observer:(id<DungenModelObserver>)observer;
-(void) update_can_tap:(CGPoint)pos;
-(void) update_can_tap_r:(CGPoint)pos;
-(void) update_group_info:(CGPoint)pos group_id:(unsigned int)_group_id;
-(void) update_group_info_r:(CGPoint)pos group_id:(unsigned int)_group_id group_info:(NSMutableArray*)_group_info;
-(void) update_route_map:(DLPoint)pos target:(DLPoint)target;
-(void) update_route_map_r:(DLPoint)pos target:(DLPoint)target level:(int)level;
-(void) hit:(CGPoint)pos;
-(void) set:(CGPoint)pos block:(BlockModel*)block;
-(BlockModel*) get_x:(int)_x y:(int)_y;
-(int) can_tap_x:(int)_x y:(int)_y;
- (void)_setup;

@end
