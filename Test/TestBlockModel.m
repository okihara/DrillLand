//
//  Test.m
//  Test
//
//  Created by  on 12/12/24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestBlockModel.h"
#import "BlockModel.h"

@implementation TestBlockModel

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testInit
{
    block_model = [[BlockModel alloc] init];
    STAssertNotNil(block_model, @"createed");
}

- (void)testClear
{
    [block_model clear];
    STAssertEquals(block_model.block_id, (uint)ID_EMPTY, @"");
}

@end
