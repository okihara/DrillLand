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
-(UserItem *)addItem:(UserItem*)userItem
{
    userItem.uniqueId = self->last_id;
    self->last_id++;

    [self->myItems setObject:userItem
                      forKey:[NSNumber numberWithInt:userItem.uniqueId]];
    return userItem;
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

-(NSArray *)_equipedItemList
{
    NSArray *itemList = [self getList];

    NSMutableArray *outList = [NSMutableArray array];
    for (UserItem *userItem in itemList) {
        if (userItem.isEquiped) {
            [outList addObject:userItem];
        }
    }
    return outList;
}

-(NSArray *)_equipedItemListWithType:(UInt32)type
{
    NSArray *equipedItemList = [self _equipedItemList];
    
    NSMutableArray *outList = [NSMutableArray array];
    for (UserItem *userItem in equipedItemList) {
        if (userItem.type == type) {
            [outList addObject:userItem];
        }
    }
    return outList;
}

-(void)calcEquipments
{
    // ソートとか要る？
    NSArray *equipedItemList = [self _equipedItemList];
    
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
    NSAssert(userItem, @"should be not nil");
    
    // 装備可能アイテムか？
    
    // 同じ部位に既に装備しているアイテムがあれば、外す
    NSArray *equipedItemListType = [self _equipedItemListWithType:userItem.type];
    if ([equipedItemListType count] > 0) {
        for (UserItem *userItem in equipedItemListType) {
            [self unequip:userItem.uniqueId dungeon:dungeonModel];
        }
    }
    
    userItem.isEquiped = YES;
    [self calcEquipments];
    
    return YES;
}

-(BOOL)unequip:(UInt64)uniqueId dungeon:(DungeonModel*)dungeonModel
{
    UserItem *userItem = [self getById:uniqueId];
    NSAssert(userItem, @"should be not nil");
    
    userItem.isEquiped = NO;
    [self calcEquipments];
    
    return YES;
}

@end
