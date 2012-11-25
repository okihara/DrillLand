//
//  BehaviorFactory.h
//  Dri
//
//  Created by  on 12/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockModel.h"

enum ID_BEHAVIOR {
    BEHAVIOR_BREKABLE      = 10000,
    BEHAVIOR_BOSS          = 10001,
    BEHAVIOR_POTION        = 10002,
    BEHAVIOR_AGGRESSIVE    = 10003,
    BEHAVIOR_DIEABLE       = 10004,
    BEHAVIOR_GETTABLE_ITEM = 10005,
    BEHAVIOR_TREASURE_BOX  = 10006,
    BEHAVIOR_CHANGE        = 10007,
};

@interface BehaviorFactory : NSObject

+(NSObject<BlockBehaivior>*)create:(UInt16)behavior_id;

@end
