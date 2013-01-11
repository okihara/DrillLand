//
//  TestMyItems.m
//  Dri
//
//  Created by  on 13/01/11.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "TestMyItems.h"
#import "UserItem.h"
#import "MyItems.h"

@implementation TestMyItems

- (void)testNew
{
    // 準備 -------
    MyItems *my_items = [MyItems new];
    
    // 実行 -------
    
    // アサート ---
    STAssertNotNil(my_items, @"create");
}

- (void)testAddItem
{
    // 準備 -------
    MyItems *my_items = [MyItems new];
    UserItem *item    = [UserItem new];
    
    // 実行 -------
    UInt64 unique_item_id = [my_items add_item:item];
    
    // アサート ---
    STAssertEquals(unique_item_id, (UInt64)1, @"");
}

- (void)testAddItem2
{
    // 準備 -------
    MyItems *my_items = [MyItems new];
    
    {
        UserItem *item    = [UserItem new];
        [my_items add_item:item];
    }
    
    UserItem *item    = [UserItem new];
    
    // 実行 -------
    UInt64 unique_item_id = [my_items add_item:item];
    
    // アサート ---
    STAssertEquals(unique_item_id, (UInt64)2, @"");
}

- (void)testGetList
{
    // 準備 -------
    MyItems *my_items = [MyItems new];
    
    {
        UserItem *item    = [UserItem new];
        [my_items add_item:item];
    }
    {
        UserItem *item    = [UserItem new];
        [my_items add_item:item];
    }
    
    // 実行 -------
    NSArray *item_list = [my_items get_list];
    
    // アサート ---
    STAssertNotNil(item_list, @"");
    STAssertEquals([item_list count], (NSUInteger)2, @"");
}

@end
