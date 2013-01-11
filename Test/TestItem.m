//
//  TestItem.m
//  Dri
//
//  Created by  on 13/01/08.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "TestItem.h"
#import "UserItem.h"
#import "BlockModel.h"

@implementation TestItem

- (void)testClear
{
    UserItem *user_item = [UserItem new];
    
    STAssertTrue([user_item unique_id] > 0, @"");
}

- (void)testUse_should_failed_no_target
{
}

- (void)testUse
{
    // 準備 -------
    UserItem *user_item = [UserItem new];
    
    BlockModel *block_model = [[BlockModel alloc] init];
    block_model.hp = 1;
    STAssertEquals(1, block_model.hp, @"");
    
    // 実行 -------
    BOOL ok = [user_item use_with_target:block_model];
    
    // アサート ---
    STAssertTrue(ok, @"");
    STAssertTrue(block_model.hp > 11, @"");
    // TODO: 回復のイベントが飛んでいる
    // STAssertTrue(NO, @"");
}

@end
