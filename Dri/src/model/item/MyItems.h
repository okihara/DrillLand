//
//  MyItems.h
//  Dri
//
//  Created by  on 12/10/18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserItem;

@interface MyItems : NSObject
{
    NSMutableDictionary *my_items;
    UInt64 last_id;
}

-(NSArray*)get_list;
-(UInt64)add_item:(UserItem*)user_item;

@end
