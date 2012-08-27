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
    hp = 1;
    atk = 1;
    def = 1;
    type = 0;
    group_id = 0;
    group_info = NULL;
    can_tap = NO;
    pos = cdp(0, 0);
}

-(void)attach_behaivior:(NSObject<BlockBehaivior>*)behaivior_
{
    [self->behavior_list addObject:behaivior_];
}
    
// TODO:あとでポリモる
-(void)on_hit:(DungeonModel*)dungeon
{
    // 1 == ON_HIT
    [dungeon notify:1 params:self];
    
    [dungeon.player attack:self dungeon:dungeon];
}

-(BOOL)is_attack_range:(DungeonModel*)dungeon
{
    BlockModel* p = (BlockModel*)dungeon.player;
    if((p.pos.x == self.pos.x + 0 && p.pos.y == self.pos.y - 1) ||
       (p.pos.x == self.pos.x + 0 && p.pos.y == self.pos.y + 1) ||
       (p.pos.x == self.pos.x - 1 && p.pos.y == self.pos.y + 0) ||
       (p.pos.x == self.pos.x + 1 && p.pos.y == self.pos.y + 0)) {
        return YES;
    }
    return NO;
}

-(void)on_update:(DungeonModel*)dungeon
{
    for (NSObject<BlockBehaivior>* b in self->behavior_list) {
        [b on_update:self dungeon:dungeon];
    }
}

-(void)attack:(BlockModel*)target dungeon:(DungeonModel *)dungeon
{
    int damage = self.atk - target.def;
    target.hp -= damage;
    if (target.hp <= 0) {
        
        target.hp = 0;
        // タイプを変更
        target.type = 0;
        
        // fire MSG_HP_0
        // 2 == ON_DESTROY
        [dungeon notify:2 params:target];
        //[dungeon notify:3 params:self];
    }
}

-(void)on_after_updte
{
    // 死んでなかったら
    // プレイヤーに攻撃
}

@end

