//
//  MyItems.h
//  Dri
//
//  Created by  on 12/10/18.
//  Copyright (c) 2012 Hiromitsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserItem;
@class DungeonModel;
@class BlockModel;

@interface MyItems : NSObject
{
    UInt64 last_id;

    NSMutableDictionary *myItems;
    BlockModel *owner;
}

-(id)initWithBlockModel:(BlockModel *)blockModel;

-(NSArray*)getList;
-(UInt64)addItem:(UserItem *)userItem;
-(void)removeItem:(UInt32)unique_id;

-(UserItem*)getById:(UInt64)uniqueId;
-(BOOL)use:(UInt64)uniqueId target:(BlockModel*)blockModel dungeon:(DungeonModel*)dungeonModel;
-(BOOL)equip:(UInt64)uniqueId dungeon:(DungeonModel*)dungeonModel;
-(BOOL)unequip:(UInt64)uniqueId dungeon:(DungeonModel*)dungeonModel;

@end
