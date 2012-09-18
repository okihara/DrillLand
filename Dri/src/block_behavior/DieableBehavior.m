//
//  DieableBehavior.m
//  Dri
//
//  Created by  on 12/08/28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DieableBehavior.h"
#import "DungeonModel.h"
#import "DungeonResultScene.h"
#import "DLEvent.h"

@implementation DieableBehavior

-(void)on_hit:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
//    DLEvent *e = [DLEvent eventWithType:DL_ON_HIT target:context_];
//    [dungeon_ dispatchEvent:e];
}

-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
    // アップデートフェイズで効果が発動するものはここに書く
}

-(void)on_damage:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_ damage:(int)damage_
{
    NSLog(@"PLAYER DAMAGED P hp=%d", context_.hp);
    
    DLEvent *e = [DLEvent eventWithType:DL_ON_DAMAGE target:context_];
    [e.params setObject:[NSNumber numberWithInt:damage_] forKey:@"damage"];
    [dungeon_ dispatchEvent:e];

    // HP 減ったことをオブザーバに通知
    // TODO: Dieable は PLAYER しか装備しないと決めつけてるよね。。。
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"UpdateHP" object:[NSNumber numberWithInt:context_.hp]];
}

-(void)on_break:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    NSLog(@"PLAYER DIED P hp=%d", context_.hp);
    
    DLEvent *e = [DLEvent eventWithType:DL_ON_DESTROY target:context_];
    [dungeon_ dispatchEvent:e];
}

@end
