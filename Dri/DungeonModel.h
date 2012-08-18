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
#import "BlockBase.h"

@class DungeonModel;
@protocol DungenModelObserver <NSObject>

- (void) notify:(DungeonModel*)_dungeon;

@end

@interface DungeonModel : NSObject
{
    TileMap2 *map;
    TileMap *done_map;
    id<DungenModelObserver> observer;
}

-(id) init:(NSArray*)initial;
-(void) add_observer:(id<DungenModelObserver>)observer;
-(void) update_can_tap:(CGPoint)pos;
-(void) update_can_tap_r:(CGPoint)pos;
-(void) update_group_info:(CGPoint)pos group_id:(unsigned int)_group_id;
-(void) update_group_info_r:(CGPoint)pos group_id:(unsigned int)_group_id group_info:(NSMutableArray*)_group_info;
-(void) hit:(CGPoint)pos;
-(void) set:(CGPoint)pos type:(BlockBase*)_type;
-(BlockBase*) get_x:(int)_x y:(int)_y;
-(int) can_tap_x:(int)_x y:(int)_y;

@end
