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

// All code under test is in the iOS Application
- (void)testAppDelegate
{
    // 準備 -------
    DungeonModel *dungeon_model = [DungeonModel new];
    
    // 実行 -------
    
    // アサート ---
    STAssertNotNil(dungeon_model, @"create");
}

@end
