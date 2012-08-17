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

@class DungeonModel;
@protocol DungenModelObserver <NSObject>

- (void) notify:(DungeonModel*)_dungeon;

@end

@interface DungeonModel : NSObject
{
    TileMap *map;
    TileMap *can_map;
    TileMap *done_map;
    id<DungenModelObserver> observer;
}

-(id) init:(NSArray*)initial;
-(void) add_observer:(id<DungenModelObserver>)observer;
-(void) update_can_tap_map:(CGPoint)pos;
-(void) check_can_tap_r:(CGPoint)pos;
-(void) erase:(CGPoint)pos;
-(void) set_state:(CGPoint)pos type:(int)_type;
-(int) get_x:(int)_x y:(int)_y;
-(int) can_tap_x:(int)_x y:(int)_y;

@end
