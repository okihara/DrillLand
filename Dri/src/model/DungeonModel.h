//
//  DungeonModel.h
//  Dri
//
//  Created by  on 12/08/15.
//  Copyright (c) 2012 Hiromitsu. All rights reserved.
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

#define DM_WIDTH 7
#define DM_HEIGHT 48

@class BlockBuilder;
@class DungeonModelCanTapUpdater;
@class DungeonModelRouteMap;
@class DungeonModelGroupInfoUpdater;

@interface DungeonModel : NSObject
{
    // TODO: インスタンス変数 ２つに絞るなら？？
    
    ObjectXDMap    *map;
    NSMutableArray *observer_list;
    BlockBuilder   *block_builder;
    
    // inner implements
    DungeonModelCanTapUpdater    *impl;
    DungeonModelGroupInfoUpdater *groupInfoUpdater;
    DungeonModelRouteMap         *routeMap;

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

// ハンドラ 外から呼ばれる
-(BOOL)onTap:(DLPoint)pos;
-(void)postprocess;

// loader json
-(void)load_from_file:(NSString*)filename;
-(void)load_random:(UInt16)seed;

@end
