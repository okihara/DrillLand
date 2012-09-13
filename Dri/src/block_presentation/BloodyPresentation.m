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

-(void)handle_event:(DungeonView *)ctx event:(DLEvent*)e view:(BlockView *)view_
{
    BlockModel *b = (BlockModel*)e.target;
    switch (e.type) {
            
        case DL_ON_DAMAGE:
            
            [ctx launch_particle:@"blood" position:view_.position];
            
            NSNumber *num = (NSNumber*)[e.params objectForKey:@"damage"];
            int damage = num ? [num intValue] : 0;
            CGPoint pos = [ctx model_to_local:b.pos];
            [ctx launch_effect:@"damage" position:pos param1:damage];
            
            break;
            
        default:
            break;
    }
}

@end
