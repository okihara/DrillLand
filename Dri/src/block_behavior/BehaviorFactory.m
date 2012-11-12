//
//  BehaviorFactory.m
//  Dri
//
//  Created by  on 12/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BehaviorFactory.h"
#import "BreakableBehaivior.h"

@implementation BehaviorFactory

+(NSObject<BlockBehaivior>*)create:(UInt16)behavior_id
{
    NSObject<BlockBehaivior> *behavior = nil;
    
    switch (behavior_id) {
        case BEHAVIOR_BREKABLE:
            behavior = [BreakableBehaivior new];
            break;
            
        default:
            break;
    }
    return behavior;
}

@end
