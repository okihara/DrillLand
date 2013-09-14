//
//  TestObjectXDMap.m
//  Dri
//
//  Created by Masataka Okihara on 2013/04/26.
//
//

#import "TestObjectXDMap.h"
#import "XDMap.h"

@implementation TestObjectXDMap

-(void)testNew
{
    ObjectXDMap *xdmap = nil;
    xdmap = [ObjectXDMap new];
    
    STAssertNotNil(xdmap, @"create");
}

-(void)testGet
{
    ObjectXDMap *xdmap = nil;
    xdmap = [ObjectXDMap new];
    [xdmap fill:(id)1];
    
    STAssertEquals([xdmap get_x:0 y:0], (id)1, @"");
}

-(void)testGetOutbound
{
    ObjectXDMap *xdmap = nil;
    xdmap = [ObjectXDMap new];
    [xdmap fill:(id)1];
    
    STAssertEquals([xdmap get_x:CAP_W y:0], (id)nil, @"");
}

@end
