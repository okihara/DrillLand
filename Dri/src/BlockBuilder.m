//
//  BlockBuilder.m
//  Dri
//
//  Created by  on 12/08/27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockBuilder.h"
#import "BlockModel.h"
#import "BreakableBehaivior.h"

@implementation BlockBuilder

-(id)init
{
    if(self=[super init]) {
        builder_map = [[NSMutableDictionary alloc] init];
        [self setupBuilders];
    }
    return self;
}

-(void)setupBuilders
{
    [self setBuilderWithName:@"PLAYER" builder:@selector(build_player)];
    [self setBuilderWithName:@"NORMAL" builder:@selector(build_normal)];
}

-(void)setBuilderWithName:(NSString *)name builder:(SEL)builder_method
{
    [builder_map setObject:[NSValue valueWithPointer:builder_method] forKey:name];
}

-(BlockModel*)buildWithName:(NSString *)name
{
    NSValue* value = [builder_map objectForKey:name];
    if (!value) return nil;
    SEL sel = [value pointerValue];
    if (!sel) return nil;
    return [self performSelector:sel];
}

-(void)dealloc
{
    [builder_map release];
    [super dealloc];
}

// ---------------------------------------------------------------------

-(BlockModel*)build_player
{
    BlockModel* b = [[BlockModel alloc] init];
    b.hp = 7;
    b.atk = 3;
    b.pos = cdp(2, 2);
    
    // PlayerBehavior を attach する
    
    return b;
}

-(BlockModel*)build_normal
{
    BlockModel* b = [[BlockModel alloc] init];
    [b clear];
    
    // NormalBehavior を attach する
    [b attach_behaivior:[[[BreakableBehaivior alloc] init] autorelease]];
    
    return b;
}

@end
