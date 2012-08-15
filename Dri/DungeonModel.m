//
//  DungeonModel.m
//  Dri
//
//  Created by  on 12/08/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DungeonModel.h"
#import "HelloWorldLayer.h"

@implementation DungeonModel

-(id) init:(NSArray*)initial
{
    if (self = [super init]) {
        map = [[TileMap alloc] init];
        [map copy_array];
    }
    return self;
}

-(void) add_observer:(id)_observer
{
    self->observer = _observer;
}

-(void) make_can_destroy_map:(CGPoint)pos
{
}

-(void) chk_by_recursive:(CGPoint)pos
{
}

-(void) erase:(CGPoint)pos
{
    [self set_state:pos type:0];
}

-(int) get_state:(CGPoint)pos
{
    return 0;
}

-(void) set_state:(CGPoint)pos type:(int)_type
{
    [self->map set_value:(int)pos.x y:(int)pos.y value:_type];
    [self->observer updateView:self->map];
}

-(int) get_can:(CGPoint)pos
{
    return 0;
}

-(void) set_can:(CGPoint) type:(int)_type
{
    
}

-(BOOL) get_done:(CGPoint)pos
{
    return NO;
}

-(void) set_done:(CGPoint)pos done:(BOOL)_done
{
}

-(BOOL) is_outbound:(CGPoint)pos
{
    return NO;
}

@end
