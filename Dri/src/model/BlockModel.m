//
//  BlockBase.m
//  Dri
//
//  Created by  on 12/08/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockModel.h"
#import "DungeonModel.h"
#import "UserItem.h"

@implementation BlockModel

@synthesize max_hp;
@synthesize hp;
@synthesize type;
@synthesize atk;
@synthesize def;
@synthesize group_id;
@synthesize group_info;
@synthesize can_tap;
@synthesize pos;
@synthesize exp;
@synthesize gold;

-(id) init
{
	if( (self=[super init]) ) {
        [self clear];
	}
	return self;
}

-(void)clear
{
    // vars
    type = ID_EMPTY;
    hp = 0;
    atk = 0;
    def = 0;
    group_id = 0;
    group_info = NULL;
    can_tap = NO;
        
    // behavior
    if (self->behavior_list) {
        [self->behavior_list release];
    }
    self->behavior_list = [[NSMutableArray alloc] init];
    
    // my_items
    if (self->my_items) {
        [self->my_items release];
    }
    self->my_items = [[MyItems alloc] init];
    self->my_equipment = [[MyEquipment alloc] init];
}

-(void)dealloc
{
    [self->behavior_list release];
    [self->my_items release];
    [super dealloc];
}

// -----------------------------------------------------------------------------
// behavior
-(void)attach_behaivior:(NSObject<BlockBehaivior>*)behaivior_
{
    [self->behavior_list addObject:behaivior_];
}

// -----------------------------------------------------------------------------
// my_item
-(void)add_item:(UserItem*)user_item
{
    [self->my_items add_item:user_item];
}

// -----------------------------------------------------------------------------
// handler
-(void)on_hit:(DungeonModel*)dungeon
{
    for (NSObject<BlockBehaivior>* b in self->behavior_list) {
        [b on_hit:self dungeon:dungeon];
        if (self.type == ID_EMPTY) return;
    }    
}

-(void)on_update:(DungeonModel*)dungeon
{
    for (NSObject<BlockBehaivior>* b in self->behavior_list) {
        [b on_update:self dungeon:dungeon];
    }
}

-(void)on_damage:(DungeonModel*)dungeon damage:(int)damage_
{
    for (NSObject<BlockBehaivior>* b in self->behavior_list) {
        [b on_damage:self dungeon:dungeon damage:damage_];
    }
}

-(void)on_break:(DungeonModel*)dungeon
{
    for (NSObject<BlockBehaivior>* b in self->behavior_list) {
        [b on_break:self dungeon:dungeon];
        if (self.type == ID_EMPTY) return;
    }
}

// -----------------------------------------------------------------------------
// action/command
-(void)attack:(BlockModel*)target dungeon:(DungeonModel *)dungeon
{
    // TODO: ちゃんとして計算式を
    int damage = self.atk - target.def;
    damage += rand() % 3 - 1;
    
    // ---
    target.hp -= damage;
    if (target.hp <= 0) {
        target.hp = 0;
    }
    
    // ---
    [target on_damage:dungeon damage:damage];
    
    // ---
    if (target.hp == 0) {
        [target on_break:dungeon];
        [target clear];
    }
}

-(void)heal:(int)value
{
    self.hp += value;
    if (self.hp > self.max_hp) {
        self.hp = self.max_hp;
    }
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"UpdateHP" object:[NSNumber numberWithInt:self.hp]];
}

@end

