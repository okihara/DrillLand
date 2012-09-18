//
//  DLEvent.h
//  Dri
//
//  Created by  on 12/09/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum DL_EVENT_TYPE {
    DL_ON_ATTACK,
    DL_ON_CANNOT_TAP,
    DL_ON_HIT,
    DL_ON_DAMAGE,
    DL_ON_DESTROY,
    DL_ON_HEAL,
    DL_ON_CLEAR,
    DL_ON_CHANGE
};

@interface DLEvent : NSObject
{
    enum DL_EVENT_TYPE type;
    id target;
    NSMutableDictionary *params;
}

@property (readonly, assign) enum DL_EVENT_TYPE type;
@property (readonly, assign) id target;
@property (readonly, assign) NSMutableDictionary *params;

+(DLEvent*)eventWithType:(enum DL_EVENT_TYPE)type target:(id)target;

@end
