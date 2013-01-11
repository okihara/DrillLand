//
//  UserItem.h
//  Dri
//
//  Created by  on 12/09/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockModel.h"

@class DungeonModel;

@interface UserItem : NSObject
{
    uint master_id;
    UInt16 type;
}

-(BOOL)use_with_dungeon_model:(DungeonModel*)dungeon_model target:(BlockModel*)target;

@property (assign) UInt32 unique_id;

@end
