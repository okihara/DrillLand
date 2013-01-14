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

@synthesize unique_id;

-(id) init
{
	if( (self=[super init]) ) {
        self->type = 1001;
	}
	return self;
}

-(BOOL)use:(BlockModel*)target dungeon:(DungeonModel*)dungeon
{
    switch (self->type) {
        case 1001:
        {
            UInt32 up_hp = 12;
            
            target.hp += up_hp;
            
            DLEvent *e = [DLEvent eventWithType:DL_ON_HEAL target:target];
            [e.params setObject:[NSNumber numberWithInt:up_hp] forKey:@"damage"];
            [dungeon dispatchEvent:e];
            
            break;
        }
            
        default:
            break;
    }
    return YES;
}

@end
