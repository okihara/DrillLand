//
//  UserItem.m
//  Dri
//
//  Created by  on 12/09/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserItem.h"

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

-(BOOL)use_with_target:(BlockModel*)target
{
    switch (self->type) {
        case 1001:
            target.hp += 12;
            break;
            
        default:
            break;
    }
    return YES;
}

@end
