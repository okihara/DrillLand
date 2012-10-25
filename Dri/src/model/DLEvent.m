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

//DL_ON_ATTACK,
//DL_ON_CANNOT_TAP,
//DL_ON_HIT,
//DL_ON_DAMAGE,
//DL_ON_DESTROY,
//DL_ON_HEAL,
//DL_ON_CLEAR,
//DL_ON_CHANGE
-(NSString*)get_event_text
{
    switch (self->type) {
        case DL_ON_ATTACK:
            return @"DL_ON_ATTACK";
            break;
        case DL_ON_CANNOT_TAP:
            return @"DL_ON_CANNOT_TAP";
            break;
        case DL_ON_HIT:
            return @"DL_ON_HIT";
            break;
        case DL_ON_DAMAGE:
            return @"DL_ON_DAMAGE";
            break;
        case DL_ON_DESTROY:
            return @"DL_ON_DESTROY";
            break;
        case DL_ON_HEAL:
            return @"DL_ON_HEAL";
            break;
        case DL_ON_CLEAR:
            return @"DL_ON_CLEAR";
            break;
        case DL_ON_CHANGE:
            return @"DL_ON_CHANGE";
            break;
        case DL_ON_GET:
            return @"DL_ON_GET";
            break;
        case DL_ON_NEW:
            return @"DL_ON_NEW";
            break;
        default:
            return @"UNKOWN";
            break;
    }
}

+(DLEvent*)eventWithType:(enum DL_EVENT_TYPE)type target:(id)target;
{
    return [[[DLEvent alloc] initWithType:type target:target] autorelease];
}


@end
