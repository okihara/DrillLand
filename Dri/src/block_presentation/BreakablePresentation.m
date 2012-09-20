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
    //BlockModel *b = e.target;
    switch (e.type) {
            
        case DL_ON_HIT:
            return [CCCallBlock actionWithBlock:^{
                [ctx launch_particle:@"hit2" position:view_.position];
            }];
            break;
            
        case DL_ON_DAMAGE:
        {
            CCFiniteTimeAction *shake = [ctx launch_effect_shake:@"shake" target:view_ params:nil];
            return [CCSequence actions:shake, [CCDelayTime actionWithDuration:0], nil];
        }
            break;
            
        case DL_ON_DESTROY:
        {
            CCCallBlock *act = [CCCallBlock actionWithBlock:^{
                [ctx launch_particle:@"block" position:view_.position];
                view_.is_alive = NO;
            }];
            return [CCSequence actions:act, [CCDelayTime actionWithDuration:0.10], nil];
        }
            break;
            
        case DL_ON_CHANGE:
        {
            view_.is_change = YES;
            return nil;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

@end
