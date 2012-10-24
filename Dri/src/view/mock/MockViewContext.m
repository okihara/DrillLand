//
//  MockViewContext.m
//  Dri
//
//  Created by  on 12/10/23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MockViewContext.h"
#import "DLView.h"
#import "DL.h"

@implementation MockViewContext

@synthesize fade_layer;
@synthesize effect_layer;
@synthesize block_layer;

-(id) init
{
	if(self=[super init]) {
        
        // ---
        self->block_layer = [CCLayer new];
        [self addChild:self->block_layer];
        
        // ---
        self->effect_layer = [[CCLayer alloc] init];
        [self addChild:self->effect_layer];
        
        self->effect_launcher = [[EffectLauncher alloc] init];
        self->effect_launcher.target_layer = self->effect_layer;
        
        // fade_layer
        self->fade_layer = [[CCLayerColor layerWithColor:ccc4(0, 0, 0, 0)] retain];
        [self addChild:self->fade_layer];
    }
    return self;
}

- (void)launch_particle:(NSString*)name position:(CGPoint)pos
{
    [self->effect_launcher launch_particle:name position:pos];
}

-(CCFiniteTimeAction*)launch_effect:(NSString *)name target:(CCNode*)target params:(NSDictionary*)params
{
    return [self->effect_launcher launch_effect:name target:target params:params];
}

- (void)remove_block_view_if_dead:(DLPoint)pos
{
    [self->block_layer removeAllChildrenWithCleanup:YES];
}

@end
