//
//  Test.m
//  Test
//
//  Created by  on 12/12/24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Test.h"
#import "BlockModel.h"

@implementation Test

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
    BlockModel *block_model = [[BlockModel alloc] init];
    STAssertNotNil(block_model, @"createed");
}

@end
