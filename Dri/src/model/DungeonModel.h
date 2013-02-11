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


// protocol
@class DungeonModel;
@protocol DungenModelObserver <NSObject>
- (void)notify:(DungeonModel*)dungeon_ event:(DLEvent*)e;
@end

// -
#define DM_WIDTH 7
#define DM_HEIGHT 48

@class BlockBuilder;
@class DungeonModelCanTapUpdater;
@class DungeonModelRouteMap;

@interface DungeonModel : NSObject
{
    // TODO: インスタンス変数 ２つに絞るなら？？
    
    ObjectXDMap *map;
    
    NSMutableArray *observer_list;
    BlockBuilder *block_builder;
    DungeonModelCanTapUpdater  *impl;
    DungeonModelRouteMap *routeMap;

    BlockModel *player;
}

@property (nonatomic, readonly)  BlockModel *player;
@property (nonatomic, readonly)  NSMutableArray *routeList;
@property (nonatomic, readwrite) UInt32 lowest_empty_y;

// Observer
-(void)add_observer:(id<DungenModelObserver>)observer;
-(void)dispatchEvent:(DLEvent*)e;

// これは外から触れる必要ある？
-(void)set:(DLPoint)pos block:(BlockModel*)block;
-(void)set_without_update_can_tap:(DLPoint)pos block:(BlockModel*)block;
-(BlockModel*)get:(DLPoint)pos;
-(int)can_tap:(DLPoint)pos;

// ---
-(BOOL)onTap:(DLPoint)pos;
-(void)postprocess;

// loader json
-(void)load_from_file:(NSString*)filename;
-(void)load_random:(UInt16)seed;

// calc route and grouping
-(void)updateCanTap:(DLPoint)pos;
-(void)update_group_info:(DLPoint)pos group_id:(unsigned int)_group_id;
-(void)update_route_map:(DLPoint)pos target:(DLPoint)target;
-(DLPoint)get_player_pos:(DLPoint)pos;

@end
