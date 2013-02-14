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
        self->my_items = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [self->my_items release];
    [super dealloc];
}

// -----------------------------------------------------------------------------
-(UserItem *)get_by_id:(UInt64)unique_id
{
    return [self->my_items objectForKey:[NSNumber numberWithInt:unique_id]];
}

-(NSArray*)get_list
{
    NSMutableArray *out_list = [NSMutableArray array];
    for (id item in self->my_items) {
        [out_list addObject:[self->my_items objectForKey:item]];
    }
    return out_list;
}

// -----------------------------------------------------------------------------
// add/remove
-(UInt64)add_item:(UserItem*)user_item
{
    user_item.unique_id = self->last_id;
    self->last_id++;

    [self->my_items setObject:user_item
                       forKey:[NSNumber numberWithInt:user_item.unique_id]];
    return user_item.unique_id;
}

-(void)removeItem:(UInt32)unique_id
{
    return [self->my_items removeObjectForKey:[NSNumber numberWithInt:unique_id]];
}

// -----------------------------------------------------------------------------
-(BOOL)use:(UInt64)unique_item_id
    target:(BlockModel*)block_model 
   dungeon:(DungeonModel*)dungeon_model
{
    UserItem *user_item = [self get_by_id:unique_item_id];
    
    [user_item use:block_model dungeon:dungeon_model];
    [self removeItem:unique_item_id];
    
    return YES;
}

// -----------------------------------------------------------------------------
-(BOOL)equip:(UInt64)unique_item_id dungeon:(DungeonModel*)dungeonModel
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
