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
}

-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
    // アップデートフェイズで効果が発動するものはここに書く
}

-(void)on_damage:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    DLEvent *e = [DLEvent eventWithType:DL_ON_DAMAGE target:context_];
    [e.params setObject:[NSNumber numberWithInt:8] forKey:@"damage"];
    [dungeon_ dispatchEvent:e];
    
    NSLog(@"PLAYER DAMAGED P hp=%d", context_.hp);
}

-(void)on_break:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // TODO: ここで直接シーン切り替えするのではなく、もっと上位に情報を伝える
    DLEvent *e = [DLEvent eventWithType:DL_ON_DESTROY target:context_];
    [dungeon_ dispatchEvent:e];
    
    //[[CCDirector sharedDirector] replaceScene:[DungeonResultScene scene]];
    
    NSLog(@"PLAYER DIED P hp=%d", context_.hp);
}

@end
