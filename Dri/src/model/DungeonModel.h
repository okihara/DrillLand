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

////////////////////////////////////////////////////////////////////////////////
// protocol
////////////////////////////////////////////////////////////////////////////////
@class DungeonModel;
@protocol DungenModelObserver <NSObject>
- (void)notify:(DungeonModel*)dungeon_ event:(DLEvent*)e;
@end


////////////////////////////////////////////////////////////////////////////////
// Class Definition
////////////////////////////////////////////////////////////////////////////////

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
-(void)addObserver:(id<DungenModelObserver>)observer;
-(void)dispatchEvent:(DLEvent*)e;


////////////////////////////////////////////////////////////////////////////////
// ハンドラ 外から呼ばれる
////////////////////////////////////////////////////////////////////////////////

-(BOOL)onTap:(DLPoint)pos;


////////////////////////////////////////////////////////////////////////////////
// ???
////////////////////////////////////////////////////////////////////////////////

-(void)postprocess;
// ターンを進める
-(BOOL)executeOneTurn:(DLPoint)pos;
-(void)move_player:(DLPoint)pos;


////////////////////////////////////////////////////////////////////////////////
// ブロックを set/get
// TODO: これは外から触れる必要ある？
////////////////////////////////////////////////////////////////////////////////

-(void)set:(DLPoint)pos block:(BlockModel*)block;
-(void)set_without_update_can_tap:(DLPoint)pos block:(BlockModel*)block;
-(BlockModel*)get:(DLPoint)pos;


////////////////////////////////////////////////////////////////////////////////
// マップ生成・読み込み
////////////////////////////////////////////////////////////////////////////////

-(void)loadFile:(NSString*)filename;
-(void)loadRandom:(UInt16)seed;

@end
