//
//  MyItems.m
//  Dri
//
//  Created by  on 12/10/18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyItems.h"
#import "UserItem.h"

@implementation MyItems

-(id)init
{
    if(self=[super init]) {
        last_id = 1;
        self->myItems = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [self->myItems release];
    [super dealloc];
}

// -----------------------------------------------------------------------------
-(UserItem *)getById:(UInt64)uniqueId
{
    return [self->myItems objectForKey:[NSNumber numberWithInt:uniqueId]];
}

-(NSArray *)getList
{
    NSMutableArray *out_list = [NSMutableArray array];
    for (id item in self->myItems) {
        [out_list addObject:[self->myItems objectForKey:item]];
    }
    return out_list;
}

// -----------------------------------------------------------------------------
// add/remove
-(UInt64)addItem:(UserItem*)userItem
{
    userItem.unique_id = self->last_id;
    self->last_id++;

    [self->myItems setObject:userItem
                       forKey:[NSNumber numberWithInt:userItem.unique_id]];
    return userItem.unique_id;
}

-(void)removeItem:(UInt32)unique_id
{
    return [self->myItems removeObjectForKey:[NSNumber numberWithInt:unique_id]];
}

// -----------------------------------------------------------------------------
-(BOOL)use:(UInt64)uniqueId
    target:(BlockModel*)blockModel 
   dungeon:(DungeonModel*)dungeonModel
{
    UserItem *user_item = [self getById:uniqueId];
    
    [user_item use:blockModel dungeon:dungeonModel];
    [self removeItem:uniqueId];
    
    return YES;
}

// -----------------------------------------------------------------------------
-(BOOL)equip:(UInt64)uniqueId dungeon:(DungeonModel*)dungeonModel
{
    // 装備可能アイテムか？
    
    // 同じ部位に既に装備しているアイテムがあれば、外す
    
    // 装備する

    // 再計算処理();

    return YES;
}

-(BOOL)unequip:(UInt64)unique_item_id dungeon:(DungeonModel*)dungeonModel
{
    // 装備してる？
    // assert
    
    // 装備外す
    
    // 再計算処理();
    
    return YES;
}

@end
