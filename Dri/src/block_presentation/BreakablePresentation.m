//
//  BreakablePresentation.m
//  Dri
//
//  Created by  on 12/09/02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BreakablePresentation.h"
#import "DungeonView.h"

@implementation BreakablePresentation

-(CCAction*)handle_event:(DungeonView *)ctx event:(DLEvent*)e view:(BlockView *)view_
{
    BlockModel *block = e.target;
    switch (e.type) {
            
        case DL_ON_HIT:
            return [CCCallBlock actionWithBlock:^{
                [ctx launch_particle:@"hit2" position:view_.position];
            }];
            break;
            
        case DL_ON_DAMAGE:
        {
//            CCFiniteTimeAction *shake = [ctx launch_effect_shake:@"shake" target:view_ params:nil];
//            return [CCSequence actions:shake, [CCDelayTime actionWithDuration:0], nil];
        }
            break;
            
        case DL_ON_DESTROY:
        {
            CCCallBlock *act_0 = [CCCallBlock actionWithBlock:^{
                [ctx launch_particle:@"block" position:view_.position];
            }];
            
            CCMoveBy *act_1 = [CCTargetedAction actionWithTarget:view_ action:[CCJumpBy actionWithDuration:0.5f position:ccp(0, 0) height:60 jumps:3]];

            CCCallBlock *act_2 = [CCCallBlock actionWithBlock:^{
                view_.is_alive = NO;
                [ctx remove_block_view_if_dead:block.pos];
            }];
            
            return [CCSequence actions:act_0, act_1, act_2, nil];
        }
            break;
            
        case DL_ON_CHANGE:
        {
            CCTargetedAction *act_0 =  [CCTargetedAction actionWithTarget:view_ action:[CCBlink actionWithDuration:0.5f blinks:2]];
            CCCallBlock *act_1 = [CCCallBlock actionWithBlock:^{
                
                DungeonModel *dungeon_model = [e.params objectForKey:@"dungeon_model"];
                [ctx remove_block_view:block.pos];
                [ctx update_block:block.pos.y x:block.pos.x dungeon_model:dungeon_model];
            
            }];

            return [CCSequence actions:act_0, act_1, nil];
        }
            break;
            
        default:
            break;
    }
    return nil;
}

@end
