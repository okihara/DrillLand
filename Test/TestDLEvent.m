//
//  TestDLEvent.m
//  Dri
//
//  Created by  on 13/01/11.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "TestDLEvent.h"

@implementation TestDLEvent

// All code under test is in the iOS Application
- (void)testNew
{
    // 準備 -------
    DLEvent *event = [DLEvent new];
    
    // 実行 -------
    
    // アサート ---
    STAssertNotNil(event, @"create");
}

@end
