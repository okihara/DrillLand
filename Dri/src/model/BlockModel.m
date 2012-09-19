//
//  BlockBase.m
//  Dri
//
//  Created by  on 12/08/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockModel.h"
#import "DungeonModel.h"

@implementation BlockModel

@synthesize hp;
@synthesize type;
@synthesize atk;
@synthesize def;
@synthesize group_id;
@synthesize group_info;
@synthesize can_tap;
@synthesize pos;

-(id) init
{
	if( (self=[super init]) ) {
        [self clear];
	}
	return self;
}

-(void)clear
{
    type = ID_EMPTY;
    hp = 0;
    atk = 0;
    def = 0;
    group_id = 0;
    group_info = NULL;
    can_tap = NO;
    if (self->behavior_list) {
        [self->behavior_list release];
    }
    self->behavior_list = [[NSMutableArray alloc] init];
}

-(void)attach_behaivior:(NSObject<BlockBehaivior>*)behaivior_
{
    [self->behavior_list addObject:behaivior_];
}
    
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

// これは武器/敵によってロジックが変わるので、ここに書くべきではない
-(BOOL)in_attack_range:(DungeonModel*)dungeon
{
    // 上下左右
    BlockModel* p = (BlockModel*)dungeon.player;
    if((p.pos.x == self.pos.x + 0 && p.pos.y == self.pos.y - 1) ||
       (p.pos.x == self.pos.x + 0 && p.pos.y == self.pos.y + 1) ||
       (p.pos.x == self.pos.x - 1 && p.pos.y == self.pos.y + 0) ||
       (p.pos.x == self.pos.x + 1 && p.pos.y == self.pos.y + 0)) {
        return YES;
    }
    return NO;
}

-(void)attack:(BlockModel*)target dungeon:(DungeonModel *)dungeon
{
    [self _attack:target dungeon:dungeon];
}

-(void)_attack:(BlockModel*)target dungeon:(DungeonModel *)dungeon
{
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
    }
}

-(void)heal:(int)value
{
    self.hp += value;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"UpdateHP" object:[NSNumber numberWithInt:self.hp]];
}

-(void)dealloc
{
    [self->behavior_list release];
    [super dealloc];
}

@end

