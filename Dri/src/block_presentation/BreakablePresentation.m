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

-(void)handle_event:(DungeonView *)ctx event:(DLEvent*)e view:(BlockView *)view_
{
    //BlockModel *b = e.target;
    switch (e.type) {
            
        case DL_ON_HIT:
            [ctx launch_particle:@"hit2" position:view_.position];
            break;
            
        case DL_ON_DESTROY:
            [ctx launch_particle:@"block" position:view_.position];
            view_.is_alive = NO;
            break;
            
        default:
            break;
    }
}

@end
