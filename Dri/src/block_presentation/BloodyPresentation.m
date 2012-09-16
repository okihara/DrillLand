//
//  BloddyPresentation.m
//  Dri
//
//  Created by  on 12/09/02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BloodyPresentation.h"
#import "DungeonView.h"
#import "DamageNumView.h"

@implementation BloodyPresentation

-(CCAction*)handle_event:(DungeonView *)ctx event:(DLEvent*)e view:(BlockView *)view_
{
    switch (e.type) {
            
        case DL_ON_DAMAGE:
        {
            CCCallBlock *act = [CCCallBlock actionWithBlock:^{
                // effect
                BlockModel *b = (BlockModel*)e.target;
                [ctx launch_particle:@"blood" position:view_.position];
                
                // damage num
                NSNumber *num = (NSNumber*)[e.params objectForKey:@"damage"];
                int damage = num ? [num intValue] : 0;
                CGPoint pos = [ctx model_to_local:b.pos];
                [ctx launch_effect:@"damage" position:pos param1:damage];
            }];
            return [CCSequence actions:act, [CCDelayTime actionWithDuration:0.5], nil];
        }   
            break;
            
        default:
            return nil;
            break;
    }
}

@end
