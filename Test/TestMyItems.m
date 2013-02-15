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
#import "DungeonModel.h"

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
    UInt64 unique_item_id = [my_items addItem:item];
    
    // アサート ---
    STAssertEquals(unique_item_id, (UInt64)1, @"");
}

- (void)testAddItem2
{
    // 準備 -------
    MyItems *my_items = [MyItems new];
    
    {
        UserItem *item    = [UserItem new];
        [my_items addItem:item];
    }
    
    UserItem *item    = [UserItem new];
    
    // 実行 -------
    UInt64 unique_item_id = [my_items addItem:item];
    
    // アサート ---
    STAssertEquals(unique_item_id, (UInt64)2, @"");
}

- (void)testGetList
{
    // 準備 -------
    MyItems *my_items = [MyItems new];
    
    {
        UserItem *item    = [UserItem new];
        [my_items addItem:item];
    }
    {
        UserItem *item    = [UserItem new];
        [my_items addItem:item];
    }
    
    // 実行 -------
    NSArray *item_list = [my_items getList];
    
    // アサート ---
    STAssertNotNil(item_list, @"");
    STAssertEquals([item_list count], (NSUInteger)2, @"");
}

- (void)testUse
{
    // 準備 -------
    MyItems *my_items = [MyItems new];
    
    UserItem *item    = [UserItem new];
    UInt64 unique_item_id = [my_items addItem:item];
    
    DungeonModel *dungeon_model = [DungeonModel new];
    BlockModel   *block_model   = [BlockModel new];
    
    // 実行 -------
    BOOL result = [my_items use:unique_item_id target:block_model dungeon:dungeon_model];
    
    // アサート ---
    STAssertTrue(result, @"");
}

- (void)getById
{
    // 準備 -------
    MyItems *my_items = [MyItems new];
    
    UserItem *item    = [UserItem new];
    UInt64 unique_item_id = [my_items addItem:item];
    
    // 実行 -------
    UserItem *result_item = [my_items getById:unique_item_id];
    
    // アサート ---
    STAssertEquals(result_item, item, @"");
}

@end
