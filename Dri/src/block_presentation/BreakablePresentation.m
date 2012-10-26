//
//  BreakablePresentation.m
//  Dri
//
//  Created by  on 12/09/02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BreakablePresentation.h"
#import "DungeonView.h"
#import "GetExpView.h"
#import "GetGoldView.h"

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
            
            CCMoveBy *act_1 = [CCDelayTime actionWithDuration:0.05f];

            CCCallBlock *act_2 = [CCCallBlock actionWithBlock:^{
                
                // coin
                [GetGoldView spawn:ctx.effect_layer position:view_.position num_exp:10];

                // exp
                [GetExpView spawn:ctx.effect_layer position:view_.position num_exp:3];
                
                // --
                view_.is_alive = NO;
                [ctx remove_block_view_if_dead:block.pos];
            }];
            
            return [CCSequence actions:act_0, act_1, act_2, nil];
        }
            break;
            
        default:
            break;
    }
    return nil;
}

@end
