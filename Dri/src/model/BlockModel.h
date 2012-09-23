//
//  BlockBase.h
//  Dri
//
//  Created by  on 12/08/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDMap.h"


@class DungeonModel;

@class BlockModel;
@protocol BlockBehaivior <NSObject>

-(void)on_hit:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_;
-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_;
-(void)on_break:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_;
-(void)on_damage:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_ damage:(int)damage_;

@end


enum ID_BLOCK {
    ID_EMPTY  = 0,
    ID_NORMAL_BLOCK    = 1000,
    ID_GROUPED_BLOCK_1 = 1001,
    ID_GROUPED_BLOCK_2 = 1002,
    ID_GROUPED_BLOCK_3 = 1003,
    ID_UNBREAKABLE_BLOCK = 1999,
    
    ID_ENEMY_BLOCK_0 = 2000, // BLUE SLIME
    ID_ENEMY_BLOCK_1 = 2001, // RED  SLIME
    
    ID_ITEM_BLOCK_0 = 3000, // POTION
    
    ID_PLAYER = INT16_MAX
};


@interface BlockModel : NSObject
{
    int hp;
    int max_hp;
    int type;
    int exp;
    int atk;
    int def;
    unsigned int group_id;
    id group_info;
    BOOL can_tap;
    NSMutableArray* behavior_list;
}

-(void)clear;
-(void)on_hit:(DungeonModel*)dungeon;
-(void)on_update:(DungeonModel*)dungeon;
-(BOOL)in_attack_range:(DungeonModel*)dungeon;
-(void)attack:(BlockModel*)target dungeon:(DungeonModel *)dungeon;
-(void)_attack:(BlockModel*)target dungeon:(DungeonModel *)dungeon;
-(void)attach_behaivior:(NSObject<BlockBehaivior>*)behaivior_;

-(void)heal:(int)value;

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int max_hp;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int atk;
@property (nonatomic, assign) int def;
@property (nonatomic, assign) unsigned int group_id;
@property (nonatomic, assign) NSMutableArray* group_info;
@property (nonatomic, assign) BOOL can_tap;
@property (nonatomic, readwrite, assign) DLPoint pos;

@end
