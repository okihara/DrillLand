//
//  BlockBase.h
//  Dri
//
//  Created by  on 12/08/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockBase : NSObject
{
    int hp;
    int type;
    BOOL can_tap;
    unsigned int group_id;
    id group_info;
}

@end
