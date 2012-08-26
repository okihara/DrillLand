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
@synthesize group_id;
@synthesize group_info;
@synthesize can_tap;
@synthesize x;
@synthesize y;


-(id) init
{
	if( (self=[super init]) ) {
        hp = 1;
        type = 0;
        group_id = 0;
        group_info = NULL;
        can_tap = NO;
        x = 0;
        y = 0;
	}
	return self;
}
    
// TODO:あとでポリモる
-(void)on_hit:(DungeonModel*)dungeon
{
    // 1 == ON_HIT
    [dungeon notify:1 params:self];
    if (--hp == 0) {
        
        // タイプを変更
        type = 0;
        
        // fire MSG_HP_0
        // TODO: notify
        // 2 == ON_DESTROY
        [dungeon notify:2 params:self];
    }
}

-(void)on_updage
{
}

-(void)on_after_updte
{
    // 死んでなかったら
    // プレイヤーに攻撃
}

@end

