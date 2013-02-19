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

@synthesize block_id;
@synthesize type;
@synthesize group_id;
@synthesize view_id;
@synthesize view_type;

@synthesize hp;
@synthesize max_hp;
@synthesize str;
@synthesize atk;
@synthesize def;
@synthesize exp;
@synthesize gold;

@synthesize pos;
@synthesize can_tap;
@synthesize group_info;
@synthesize is_dead;

@synthesize my_items;

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
    block_id  = ID_EMPTY;
    type      = 0;
    view_type = 0;
    view_id   = 0;
    hp        = 0;
    atk       = 0;
    def       = 0;
    group_id   = 0;
    group_info = NULL;
    can_tap    = NO;
    is_dead    = NO;
        
    // behavior
    if (self->behavior_list) {
        [self->behavior_list release];
    }
    self->behavior_list = [[NSMutableArray alloc] init];
    
    // my_items
    if (self->my_items) {
        [self->my_items release];
    }
    self->my_items = [[MyItems alloc] initWithBlockModel:self];
}

-(void)dealloc
{
    [self->behavior_list release];
    [self->my_items release];
    [super dealloc];
}

// -----------------------------------------------------------------------------

-(void)setHp:(int)newHp
{
    self->hp = newHp;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"UpdateHP" object:self];
}

// -----------------------------------------------------------------------------
// behavior
-(void)attach_behaivior:(NSObject<BlockBehaivior>*)behaivior_
{
    [self->behavior_list addObject:behaivior_];
}

// -----------------------------------------------------------------------------
// my_item
-(UserItem *)add_item:(UserItem*)user_item
{
    if ([[self->my_items getList] count] >= MAX_NUM_HAS) {
        return nil;
    } else {
        return [self->my_items addItem:user_item];
    }
}

// -----------------------------------------------------------------------------
// handler
-(void)on_hit:(DungeonModel*)dungeon
{
    for (NSObject<BlockBehaivior>* b in self->behavior_list) {
        [b on_hit:self dungeon:dungeon];
        if (self.block_id == ID_EMPTY) return;
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
    for (NSObject<BlockBehaivior> *behavior in self->behavior_list) {
        [behavior on_break:self dungeon:dungeon];
        if (self.block_id == ID_EMPTY) return;
    }
}

// -----------------------------------------------------------------------------
// action/command
// TODO: ダメージ計算を別クラスに
-(void)attack:(BlockModel*)target dungeon:(DungeonModel *)dungeon
{
    // TODO: ちゃんとして計算式を
    float damage = (float)self.atk * pow(0.96f, target.def);
    float r = (112 + rand() % 32) / 128.0f;
    damage *= r; 
    
    // ---
    target.hp -= (uint)damage;
    if (target.hp <= 0) {
        target.hp = 0;
    }
    
    // ---
    [target on_damage:dungeon damage:damage];
    
    // ---
    if (target.hp == 0) {
        [target on_break:dungeon];
        target.is_dead = YES;
    }
}

-(void)heal:(int)value
{
    self.hp += value;
    if (self.hp > self.max_hp) {
        self.hp = self.max_hp;
    }
}

@end

