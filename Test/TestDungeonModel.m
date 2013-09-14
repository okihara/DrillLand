//
//  TestDungeonModel.m
//  Dri
//
//  Created by  on 13/01/11.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "TestDungeonModel.h"
#import "DungeonModel.h"

@implementation TestDungeonModel

- (void)setUp
{
    [super setUp];
}

- (void)testNew
{
    // 準備 -------
    DungeonModel *dungeon_model = [DungeonModel new];
    
    // 実行 -------
    
    // アサート ---
    STAssertNotNil(dungeon_model, @"create");
}

- (void)testMovePlayer
{
    // 準備 -------
    DungeonModel *dungeon_model = [DungeonModel new];
    
    // 実行 -------
    [dungeon_model move_player:cdp(0, 3)];
    
    // アサート ---
    STAssertEquals(dungeon_model.player.pos.x, 1, @"");
    STAssertEquals(dungeon_model.player.pos.y, 3, @"");
}



@end
