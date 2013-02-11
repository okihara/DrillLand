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
#import "DungeonModel.h"
#import "DLEvent.h"
// ↑これらに依存している

BOOL reached = NO;

@interface DummyObserver : NSObject<DungenModelObserver>
{
}
@end

@implementation DummyObserver
- (void)notify:(DungeonModel*)dungeon_model event:(DLEvent*)e
{
    //STAssertEquals(e.type, 0, @"hoge");
    reached = YES;
}
@end


@implementation TestItem

- (void)testNew
{
    UserItem *user_item = [UserItem new];
    
    STAssertNotNil(user_item, @"");
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
    
    DungeonModel *dungeon_model = [DungeonModel new];
    [dungeon_model addObserver:[DummyObserver new]];
    
    // 実行 -------
    BOOL ok = [user_item use:block_model dungeon:dungeon_model];
    
    // アサート ---
    STAssertTrue(ok, @"");
    STAssertTrue(block_model.hp > 11, @"");
    // TODO: 回復のイベントが飛んでいる
    STAssertTrue(reached, @"イベントがオブザーバーまで届いていない");
}

@end
