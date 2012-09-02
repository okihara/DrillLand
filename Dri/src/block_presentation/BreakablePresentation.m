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

-(void)handle_event:(DungeonView *)ctx event:(int)event model:(BlockView *)me
{
    switch (event) {
        case 0:
            break;
        case 1:
            [ctx launch_particle:@"hit2" position:me.position];
            break;
        case 2:
            [ctx launch_particle:@"block" position:me.position];
            break;
        default:
            break;
    }
}

@end
