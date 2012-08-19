//
//  Player.m
//  Dri
//
//  Created by  on 12/08/18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerModel.h"

@implementation PlayerModel

@synthesize pos;

-(id) init
{
	if( (self=[super init]) ) {
        self->pos = cdp(0, 2);
 	}
	return self;
}

@end
