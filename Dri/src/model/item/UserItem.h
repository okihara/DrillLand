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
    UInt32 masterId;
    BOOL   isEquiped;
}

@property (nonatomic, readwrite) UInt32   masterId;
@property (nonatomic, readwrite) UInt32   uniqueId;
@property (nonatomic, readwrite) BOOL     isEquiped;
@property (nonatomic, readonly)  UInt32   type;
@property (nonatomic, readonly)  NSString *name;
@property (nonatomic, readonly)  int      atk;
@property (nonatomic, readonly)  int      def;

+(UserItem *)createWithMasterId:(UInt32)masterId;
-(BOOL)use:(BlockModel*)target dungeon:(DungeonModel*)dungeon;

@end
