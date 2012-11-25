//
//  BehaviorFactory.m
//  Dri
//
//  Created by  on 12/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BehaviorFactory.h"
#import "BreakableBehaivior.h"
#import "BossBehavior.h"
#import "PotionBehavior.h"
#import "AggressiveBehaivior.h"
#import "DieableBehavior.h"
#import "GettableItemBehavior.h"
#import "TreasureBoxBehavior.h"
#import "ChangeBehavior.h"

@implementation BehaviorFactory

+(NSObject<BlockBehaivior>*)create:(UInt16)behavior_id
{
    NSObject<BlockBehaivior> *behavior = nil;
    
    switch (behavior_id) {
        case BEHAVIOR_BREKABLE:
            behavior = [BreakableBehaivior new];
            break;
        case BEHAVIOR_BOSS:
            behavior = [BossBehavior new];
            break;
        case BEHAVIOR_POTION:
            behavior = [PotionBehavior new];
            break;
        case BEHAVIOR_AGGRESSIVE:
            behavior = [AggressiveBehaivior new];
            break;
        case BEHAVIOR_DIEABLE:
            behavior = [DieableBehavior new];
            break;
        case BEHAVIOR_GETTABLE_ITEM:
            behavior = [GettableItemBehavior new];
            break;
        case BEHAVIOR_TREASURE_BOX:
            behavior = [TreasureBoxBehavior new];
            break;
        case BEHAVIOR_CHANGE:
            behavior = [ChangeBehavior new];
            break;
        default:
            break;
    }
    return behavior;
}

@end
