//
//  UserItem.m
//  Dri
//
//  Created by  on 12/09/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserItem.h"
#import "DLEvent.h"
#import "DungeonModel.h"

@implementation UserItem

-(id) init
{
	if( (self=[super init]) ) {
        self->type = 1001;
	}
	return self;
}

-(UInt32)unique_id
{
    return UINT_FAST32_MAX;
}

-(BOOL)use_with_dungeon_model:(DungeonModel*)dungeon_model target:(BlockModel*)target;
{
    switch (self->type) {
        case 1001:
            target.hp += 12;
            
            DLEvent *e = [DLEvent eventWithType:DL_ON_HEAL target:target];
            [e.params setObject:[NSNumber numberWithInt:10] forKey:@"damage"];
            [dungeon_model dispatchEvent:e];
            break;
            
        default:
            break;
    }
    return YES;
}

@end
