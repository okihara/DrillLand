//
//  BlockBase.m
//  Dri
//
//  Created by  on 12/08/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockBase.h"

@implementation BlockBase

@synthesize hp;
@synthesize type;
@synthesize group_id;
@synthesize group_info;
@synthesize can_tap;
@synthesize x;
@synthesize y;


-(id) init
{
	if( (self=[super init]) ) {
        hp = 1;
        type = 0;
        group_id = 0;
        group_info = NULL;
        can_tap = NO;
        x = 0;
        y = 0;
	}
	return self;
}

// TODO:あとでポリモる
-(void)hit
{
    if (--hp == 0) {
        type = 0;
    }
}

@end
