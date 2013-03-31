//
//  BasicPresentation.m
//  Dri
//
//  Created by  on 12/09/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BasicPresentation.h"
#import "DungeonView.h"

@implementation BasicPresentation

-(CCAction*)handle_event:(DungeonView *)ctx event:(DLEvent*)e view:(BlockView *)view_
{
    BlockModel *block = e.target;
    
    switch (e.type) {
            
        case DL_ON_NEW:
        {
            CCCallBlock *act_1 = [CCCallBlock actionWithBlock:^{
                
                DungeonModel *dungeon_model = [e.params objectForKey:@"dungeon_model"];
                [ctx remove_block_view_if_dead:block.pos];
                [ctx update_block:block.pos.y x:block.pos.x dungeon_model:dungeon_model];
                BlockView *new_block_view = [ctx get_block_view:block.pos];
                
                // アクション：移動
                CCJumpBy *act_jump = [CCTargetedAction actionWithTarget:new_block_view action:[CCJumpBy actionWithDuration:0.3f position:ccp(0, 0) height:100 jumps:1]];
                [new_block_view runAction:act_jump];
                
            }];
            
            return [CCSequence actions:act_1, nil];
            
        }
            break;
            
        default:
            break;
    }
    return nil;
}

@end