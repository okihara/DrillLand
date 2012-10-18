//
//  MyItems.m
//  Dri
//
//  Created by  on 12/10/18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyItems.h"
#import "UserItem.h"

@implementation MyItems

-(id)init
{
    if(self=[super init]) {
        self->my_items = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [self->my_items release];
    [super dealloc];
}

// -----------------------------------------------------------------------------
// add/remove
-(void)add_item:(UserItem*)user_item
{
    [self->my_items setObject:user_item forKey:[NSNumber numberWithInt:[user_item unique_id]]];
}

-(void)remove_item:(UInt32)unique_id
{
    return;
}

-(void)use_item:(UInt32)unique_id
{
    return;
}

@end
