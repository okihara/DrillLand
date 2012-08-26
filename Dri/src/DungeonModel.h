//
//  DungeonModel.h
//  Dri
//
//  Created by  on 12/08/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "XDMap.h"
#import "BlockModel.h"

#define WIDTH 5
#define HEIGHT 28

@class DungeonModel;
@protocol DungenModelObserver <NSObject>

-(void) notify:(int)type dungeon:(DungeonModel*)_dungeon params:(id)params;

@end

@class PlayerModel;

@interface DungeonModel : NSObject
{
    PlayerModel* player;
    ObjectXDMap *map;
    XDMap *done_map;
    XDMap *route_map;
    id<DungenModelObserver> observer;
}

-(id) init:(NSArray*)initial;
-(void) load_from_file:(NSString*)filename;
-(void) add_observer:(id<DungenModelObserver>)observer;
-(void) update_can_tap:(CGPoint)pos;
-(void) update_can_tap_r:(CGPoint)pos;
-(void) update_group_info:(CGPoint)pos group_id:(unsigned int)_group_id;
-(void) update_group_info_r:(CGPoint)pos group_id:(unsigned int)_group_id group_info:(NSMutableArray*)_group_info;
-(void) update_route_map:(DLPoint)pos target:(DLPoint)target;
-(void) update_route_map_r:(DLPoint)pos target:(DLPoint)target level:(int)level;
-(DLPoint) get_player_pos:(DLPoint)pos;
-(void) hit:(CGPoint)pos;
-(void) _hit:(BlockModel*)b;
-(void) set:(CGPoint)pos block:(BlockModel*)block;
-(BlockModel*) get_x:(int)_x y:(int)_y;
-(int) can_tap_x:(int)_x y:(int)_y;
-(void) _fill_blocks;
-(void) _clear_can_tap;

-(void) notify:(int)type params:(id)params;

@property (nonatomic, readonly) XDMap *route_map;
@property (nonatomic, readonly) PlayerModel *player;

@end
