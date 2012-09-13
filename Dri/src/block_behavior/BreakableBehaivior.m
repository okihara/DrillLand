//
//  NormalBehaivior.m
//  Dri
//
//  Created by  on 12/08/28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BreakableBehaivior.h"
#import "DungeonModel.h" // TODO:ここは protocol で解決したい

@implementation BreakableBehaivior

-(void)on_hit:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
    
    DLEvent *e = [DLEvent eventWithType:DL_ON_HIT target:context_];
    [dungeon_ dispatchEvent:e];

    // ---
    [dungeon_.player attack:context_ dungeon:dungeon_];
}

-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
}

-(void)on_damage:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    DLEvent *e = [DLEvent eventWithType:DL_ON_DAMAGE target:context_];
    [dungeon_ dispatchEvent:e];
}

-(void)on_break:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // TODO: ここで behaivior リストも破棄しないといけない
    [context_ clear];
    
    // 2 == ON_DESTROY
    DLEvent *e = [DLEvent eventWithType:DL_ON_DESTROY target:context_];
    [dungeon_ dispatchEvent:e];
}

@end
