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


#define WIDTH 7
#define HEIGHT 48

@class DungeonModel;


@protocol DungenModelObserver <NSObject>
- (void)notify:(DungeonModel*)dungeon_ event:(DLEvent*)e;
@end


@class BlockBuilder;

@interface DungeonModel : NSObject
{
    // TODO: インスタンス変数 ２つに絞るなら？？
    
    ObjectXDMap *map;
    XDMap *done_map;
    XDMap *route_map;

    // TODO: クラス化
    NSMutableArray *route_list;

    // observer
    NSMutableArray *observer_list;

    // ファイルから読む部分で使ってる
    // load_from_file 別クラス化できそう
    BlockBuilder *block_builder;
    BlockModel *player;
}

-(id) init;

// Observer
-(void)add_observer:(id<DungenModelObserver>)observer;
//-(void)remove_observer:(id<DungenModelObserver>)observer;
-(void)dispatchEvent:(DLEvent*)e;

// ---
-(void)set:(DLPoint)pos block:(BlockModel*)block;
-(void)set_without_update_can_tap:(DLPoint)pos block:(BlockModel*)block;
-(BlockModel*)get:(DLPoint)pos;
-(int)can_tap:(DLPoint)pos;

// ---
-(BOOL)on_hit:(DLPoint)pos;
-(void)postprocess;

// loader json
-(void)load_from_file:(NSString*)filename;
-(void)load_random:(UInt16)seed;

// calc route and grouping
-(void)_clear_can_tap;
-(void)update_can_tap:(DLPoint)pos;
-(void)update_can_tap_r:(DLPoint)pos;
-(void)update_group_info:(DLPoint)pos group_id:(unsigned int)_group_id;
-(void)update_group_info_r:(DLPoint)pos group_id:(unsigned int)_group_id group_info:(NSMutableArray*)_group_info;
-(void)update_route_map:(DLPoint)pos target:(DLPoint)target;
-(void)update_route_map_r:(DLPoint)pos target:(DLPoint)target level:(int)level;
-(DLPoint)get_player_pos:(DLPoint)pos;

@property (nonatomic, readonly) XDMap *route_map;
@property (nonatomic, readonly) BlockModel *player;
@property (nonatomic, retain) NSMutableArray* route_list;
@property (nonatomic, readwrite) int lowest_empty_y;

@end
