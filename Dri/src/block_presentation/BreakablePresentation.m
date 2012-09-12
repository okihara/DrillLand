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

-(void)handle_event:(DungeonView *)ctx event:(int)event model:(BlockModel*)model_ view:(BlockView *)view_
{
    switch (event) {
        case 0:
            break;
        case 1:
            [ctx launch_particle:@"hit2" position:view_.position];
            break;
        case 2:
            [ctx launch_particle:@"block" position:view_.position];
            view_.is_alive = NO;
            break;
        default:
            break;
    }
}

@end
