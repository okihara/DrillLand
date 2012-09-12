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

-(void)handle_event:(DungeonView *)ctx event:(int)event model:(BlockModel*)model_ view:(BlockView *)view_
{
    switch (event) {
            
        case 0:
            break;
        case 1:
            [ctx launch_particle:@"blood"  position:view_.position];
            
            CGPoint pos = [ctx model_to_local:model_.pos];
            [ctx launch_effect:@"damage" position:pos];
            break;
        default:
            break;
    }
}

@end
