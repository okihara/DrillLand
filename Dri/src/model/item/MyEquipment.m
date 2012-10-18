//
//  MyEquipment.m
//  Dri
//
//  Created by  on 12/10/18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyEquipment.h"

@implementation MyEquipment

-(id)init
{
    if(self=[super init]) {
        self->my_equipment = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [self->my_equipment release];
    [super dealloc];
}

@end
