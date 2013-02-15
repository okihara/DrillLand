//
//  TestMasterLoader.m
//  Dri
//
//  Created by  on 13/02/15.
//  Copyright (c) 2013 Hiromitsu. All rights reserved.
//

#import "TestMasterLoader.h"
#import "MasterLoader.h"

@implementation TestMasterLoader

// All code under test is in the iOS Application
- (void)testLoad {
    [MasterLoader load:@"block_master.json"];
    
    NSDictionary *master = [MasterLoader getMaster:@"block_master" 
                                         primaryId:10000];
    //STAssertEquals([master val
    STAssertEquals([[master valueForKey:@"primary_id"] intValue], 10000, @"");
}

- (void)testLoadOther {
    [MasterLoader load:@"item_master.json"];
    
    NSDictionary *master = [MasterLoader getMaster:@"item_master" 
                                         primaryId:10000];
    NSString *name = (NSString *)[master valueForKey:@"name"];
    STAssertTrue([name isEqualToString:@"SHORT-SWORD"], @"");
}

@end
