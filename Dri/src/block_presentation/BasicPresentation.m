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
            
        case DL_ON_HIT:
//            return [CCCallBlock actionWithBlock:^{
//                [ctx launch_particle:@"hit2" position:view_.position];
//            }];
            return nil;
            break;
            
        case DL_ON_DESTROY:
        {
            CCCallBlock *act_2 = [CCCallBlock actionWithBlock:^{
                view_.is_alive = NO;
                [ctx remove_block_view_if_dead:block.pos];
            }];
            return act_2;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

@end