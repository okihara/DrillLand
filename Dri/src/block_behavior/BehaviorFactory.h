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
    BEHAVIOR_BREKABLE = 10000,
};

@interface BehaviorFactory : NSObject

+(NSObject<BlockBehaivior>*)create:(UInt16)behavior_id;

@end
