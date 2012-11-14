//
//  BlockBase.h
//  Dri
//
//  Created by  on 12/08/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDMap.h"
#import "MyItems.h"
#import "MyEquipment.h"

enum ID_BLOCK {
    ID_EMPTY  = 0,
    ID_NORMAL_BLOCK    = 10000,
    ID_GROUPED_BLOCK_1 = 10001,
    ID_GROUPED_BLOCK_2 = 10002,
    ID_GROUPED_BLOCK_3 = 10003,
    ID_UNBREAKABLE_BLOCK = 10999,
    
    ID_ENEMY_BLOCK_0 = 11000, // BLUE SLIME
    ID_ENEMY_BLOCK_1 = 11001, // RED  SLIME
    
    ID_ITEM_BLOCK_0 = 12000, // POTION
    ID_ITEM_BLOCK_1 = 12001, // DORAYAKI
    ID_ITEM_BLOCK_2 = 12002, // TREASURE BOX
    
    ID_PLAYER = 13000
};

@class DungeonModel;
@class BlockModel;

@protocol BlockBehaivior <NSObject>

-(void)on_hit:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_;
-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_;
-(void)on_break:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_;
-(void)on_damage:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_ damage:(int)damage_;

@end

@interface BlockModel : NSObject
{
    // params
    uint block_id;
    uint type;
    uint group_id;
    uint view_type;
    uint view_id;
    
    int hp;
    int max_hp;
    int atk;
    int def;
    int exp;
    int gold;
    
    
    // 状態
    id group_info;
    BOOL can_tap;

    // TODO: クラス化
    uint direction;
    
    // behavior
    NSMutableArray* behavior_list;
    
    // items/equipment
    MyItems *my_items;
    MyEquipment *my_equipment;
}

-(void)clear;
-(void)on_hit:(DungeonModel*)dungeon;
-(void)on_update:(DungeonModel*)dungeon;
-(void)attach_behaivior:(NSObject<BlockBehaivior>*)behaivior_;
-(void)attack:(BlockModel*)target dungeon:(DungeonModel *)dungeon;
-(void)heal:(int)value;

@property (nonatomic, assign) uint block_id;
@property (nonatomic, assign) uint type;
@property (nonatomic, assign) uint group_id;
@property (nonatomic, assign) uint view_id;
@property (nonatomic, assign) uint view_type;

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int max_hp;
@property (nonatomic, assign) int atk;
@property (nonatomic, assign) int def;
@property (nonatomic, assign) int exp;
@property (nonatomic, assign) int gold;

@property (nonatomic, assign) DLPoint pos;
@property (nonatomic, assign) BOOL can_tap;
@property (nonatomic, assign) NSMutableArray* group_info;

@end
