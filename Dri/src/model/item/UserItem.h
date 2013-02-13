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
@property (nonatomic, assign) UInt32 unique_id;
@property (nonatomic, readonly, assign) NSString *name;

-(BOOL)use:(BlockModel*)target dungeon:(DungeonModel*)dungeon;

@end
