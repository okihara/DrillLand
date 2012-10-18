//
//  UserItem.h
//  Dri
//
//  Created by  on 12/09/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserItem : NSObject
{
    uint master_id;
    UInt16 type;
}

-(UInt32)unique_id;

@end
