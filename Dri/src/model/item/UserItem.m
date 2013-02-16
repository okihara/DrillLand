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
#import "ItemMaster.h"
#import "MasterLoader.h"


@implementation UserItem

@synthesize masterId;
@synthesize type;
@synthesize uniqueId;
@synthesize isEquiped;

-(id) init
{
	if( (self=[super init]) ) {
        self->masterId  = 0;
        self->type      = 0;
        self->isEquiped = NO;
	}
	return self;
}

-(NSString *)name
{
    NSDictionary *master = [MasterLoader getMaster:@"item_master" primaryId:self->masterId];
    return [master valueForKey:@"name"];
}

-(UInt32)type
{
    NSDictionary *master = [MasterLoader getMaster:@"item_master" primaryId:self->masterId];
    return [[master valueForKey:@"type"] intValue];
}

-(int)atk
{
    NSDictionary *master = [MasterLoader getMaster:@"item_master" primaryId:self->masterId];
    return [[master valueForKey:@"atk"] intValue];
}

-(int)def
{
    NSDictionary *master = [MasterLoader getMaster:@"item_master" primaryId:self->masterId];
    return [[master valueForKey:@"def"] intValue];
}

-(BOOL)use:(BlockModel*)target dungeon:(DungeonModel*)dungeon
{
    switch (self.type) {
        case 1000:
        {
            UInt32 up_hp = 12;
            
            [target heal:up_hp];
            
            DLEvent *e = [DLEvent eventWithType:DL_ON_HEAL target:target];
            [e.params setObject:[NSNumber numberWithInt:up_hp] forKey:@"damage"];
            [dungeon dispatchEvent:e];
            
            [target.my_items removeItem:self.uniqueId];
            
            break;
        }
        case 2000:
        {
            // 装備
            [target.my_items equip:self.uniqueId dungeon:dungeon];
            
            break;
        }
            
        default:
            break;
    }
    return YES;
}

+(UserItem *)createWithMasterId:(UInt32)masterId
{
    UserItem *userItem = [[UserItem alloc] init];
    userItem.masterId = masterId;
    return userItem;
}

@end
