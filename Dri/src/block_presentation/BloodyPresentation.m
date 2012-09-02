//
//  BloddyPresentation.m
//  Dri
//
//  Created by  on 12/09/02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BloodyPresentation.h"
#import "DungeonView.h"

@implementation BloodyPresentation

-(void)handle_event:(DungeonView *)ctx event:(int)event model:(BlockView *)me
{
    switch (event) {
            
        case 0:
            break;
        case 1:
            [ctx launch_particle:@"blood" position:me.position];
            break;
        default:
            break;
    }
}

@end
