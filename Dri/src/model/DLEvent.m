//
//  DLEvent.m
//  Dri
//
//  Created by  on 12/09/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DLEvent.h"

@implementation DLEvent

@synthesize type;
@synthesize target;
@synthesize params;

-(id) initWithType:(enum DL_EVENT_TYPE)type_ target:(id)target_
{
    if (self = [super init]) {
        self->type   = type_;
        self->target = target_;
        self->params = [[NSMutableDictionary dictionary] retain];
    }
    return self;
}

-(void)dealloc
{
    [self->params release];
    [super dealloc];
}

+(DLEvent*)eventWithType:(enum DL_EVENT_TYPE)type target:(id)target;
{
    return [[[DLEvent alloc] initWithType:type target:target] autorelease];
}


@end
