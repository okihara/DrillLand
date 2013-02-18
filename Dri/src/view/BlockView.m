//
//  BlockView.m
//  Dri
//
//  Created by  on 12/08/18.
//  Copyright 2012 Hiromitsu. All rights reserved.
//

#import "BlockView.h"
#import "BlockModel.h"
#import "DungeonView.h"


@implementation BlockView

@synthesize is_alive;
@synthesize is_change; // TODO: カプセル化違反
@synthesize pos;

- (id)init
{
	if (self=[super init]) {
        [self setup];
	}
	return self;
}

- (void)setup
{
    is_alive    = YES;
    is_change   = NO;
    is_touching = NO;

    self->events            = [[NSMutableArray array] retain];
    self->presentation_list = [[NSMutableArray array] retain];

}

- (void)dealloc
{
    [self->presentation_list release];
    [self->events release];
    [super dealloc];
}


//------------------------------------------------------------------------------


- (void)addPresentation:(NSObject<BlockPresentation> *)presentation
{
    [self->presentation_list addObject:presentation];
}

- (CCAction*)_updatePresentation:(NSObject<ViewContextProtocol>*)ctx event:(DLEvent*)e
{
    NSMutableArray *actions = [NSMutableArray array];
    
    for (NSObject<BlockPresentation>* p in self->presentation_list) {
        CCAction *action = [p handle_event:ctx event:e view:self];
        if (action) {
            [actions addObject:action];
        }
    }
    
    return [actions count] ? [CCSequence actionWithArray:actions] : nil;
}

- (CCAction*)handleEvent:(NSObject<ViewContextProtocol>*)ctx event:(DLEvent*)e
{
    return [self _updatePresentation:ctx event:e];
}


//==============================================================================
// アニメーション

-(CCFiniteTimeAction *)_playAnime:(BlockModel *)blockModel name:(NSString *)name
{
    CCAnimation *anim = [[CCAnimationCache sharedAnimationCache] animationByName:name];
    if (!anim) {
        return nil;
    }
    
    CCAnimate *animate = [CCAnimate actionWithAnimation:anim];
    if (anim.loops == NSUIntegerMax) {
        return [CCCallFuncO actionWithTarget:self
                                    selector:@selector(runAction:) 
                                      object:animate];
    } else {
        return animate;
    }
}

-(CCFiniteTimeAction*)playAnime:(BlockModel*)blockModel name:(NSString *)suffix
{
    NSString *animeName = [NSString stringWithFormat:@"%d%@", blockModel.block_id, suffix];
    return [self _playAnime:blockModel name:animeName];
}

@end
