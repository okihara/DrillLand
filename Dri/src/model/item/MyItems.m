//
//  MyItems.m
//  Dri
//
//  Created by  on 12/10/18.
//  Copyright (c) 2012 Hiromitsu. All rights reserved.
//

#import "MyItems.h"
#import "UserItem.h"
#import "BlockModel.h"
#import "DungeonModel.h"


@implementation MyItems

-(id)initWithBlockModel:(BlockModel *)blockModel
{
    if(self=[super init]) {
        last_id = 1;
        self->myItems = [[NSMutableDictionary alloc] init];
        self->owner = blockModel;
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
    userItem.uniqueId = self->last_id;
    self->last_id++;

    [self->myItems setObject:userItem
                      forKey:[NSNumber numberWithInt:userItem.uniqueId]];
    return userItem.uniqueId;
}

-(void)removeItem:(UInt32)unique_id
{
    return [self->myItems removeObjectForKey:[NSNumber numberWithInt:unique_id]];
}

// -----------------------------------------------------------------------------
-(BOOL)use:(UInt64)uniqueId
    target:(BlockModel *)blockModel 
   dungeon:(DungeonModel *)dungeonModel
{
    UserItem *user_item = [self getById:uniqueId];
    
    BOOL used = [user_item use:blockModel dungeon:dungeonModel];
    
    if (used) {
        [dungeonModel executeOneTurn:dungeonModel.player.pos];
    }
    
    return used;
}

-(void)calcEquipments
{
    // ソートとか要る？
    NSArray *itemList = [self getList];
    NSArray *equipedItemList = [itemList copy];
    
    int totalAtk = 0;
    int totalDef = 0;
    for (UserItem *userItem in equipedItemList) {
        totalAtk += userItem.atk;
        totalDef += userItem.def;
    }
    
    // オーナーの atk を更新
    self->owner.atk = self->owner.str + totalAtk;
    self->owner.def = totalDef;
}

// -----------------------------------------------------------------------------
-(BOOL)equip:(UInt64)uniqueId dungeon:(DungeonModel*)dungeonModel
{
    UserItem *userItem = [self getById:uniqueId];
    
    // もってるのか？
    NSAssert(userItem, @"should be not nil");
    
    // 装備可能アイテムか？
    
    // 同じ部位に既に装備しているアイテムがあれば、外す
    
    // 装備する
    userItem.isEquiped = YES;

    // 再計算処理();
    [self calcEquipments];
    
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
