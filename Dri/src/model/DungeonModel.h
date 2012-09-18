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
#import "DLEvent.h"


#define WIDTH 5
#define HEIGHT 48

@class DungeonModel;


@protocol DungenModelObserver <NSObject>
- (void)notify:(DungeonModel*)dungeon_ event:(DLEvent*)e;
@end


@class BlockBuilder;

@interface DungeonModel : NSObject
{
    BlockBuilder *block_builder;
    BlockModel* player;
    ObjectXDMap *map;
    XDMap *done_map;
    XDMap *route_map;
    NSMutableArray *route_list;
    id<DungenModelObserver> observer;
}

-(id) init:(NSArray*)initial;

// ---
-(void) set:(DLPoint)pos block:(BlockModel*)block;
-(void) on_hit:(DLPoint)pos;
-(BlockModel*)get:(DLPoint)pos;
-(int) can_tap:(DLPoint)pos;
-(void) _fill_blocks;
-(void) _clear_can_tap;

// loader json
-(void) load_from_file:(NSString*)filename;

// calc route and grouping
-(void) update_can_tap:(DLPoint)pos;
-(void) update_can_tap_r:(DLPoint)pos;
-(void) update_group_info:(DLPoint)pos group_id:(unsigned int)_group_id;
-(void) update_group_info_r:(DLPoint)pos group_id:(unsigned int)_group_id group_info:(NSMutableArray*)_group_info;
-(void) update_route_map:(DLPoint)pos target:(DLPoint)target;
-(void) update_route_map_r:(DLPoint)pos target:(DLPoint)target level:(int)level;
-(DLPoint) get_player_pos:(DLPoint)pos;

// Observer
-(void) add_observer:(id<DungenModelObserver>)observer;
-(void) dispatchEvent:(DLEvent*)e;

@property (nonatomic, readonly) XDMap *route_map;
@property (nonatomic, readonly) BlockModel *player;
@property (nonatomic, retain) NSMutableArray* route_list;

@end
