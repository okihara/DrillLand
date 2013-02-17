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

-(CCFiniteTimeAction*)play_attack:(BlockModel*)block_model
{
    NSString *anime_name = [NSString stringWithFormat:@"%datk", block_model.block_id];
    return [self play_anime_onece:anime_name];
}

-(CCFiniteTimeAction*)play_front:(BlockModel*)block_model
{
    NSString *anime_name = [NSString stringWithFormat:@"%dfront", block_model.block_id];
    return [CCCallFuncO actionWithTarget:self selector:@selector(play_anime:) object:anime_name];
}

// animation helper
- (void)play_anime:(NSString*)name
{
    CCAnimation *anim = [[CCAnimationCache sharedAnimationCache] animationByName:name];
    //NSAssert(anim, @"anim should be not nil");
    if (!anim) {
        return;
    }

    CCAction *act = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:anim]];
    [self runAction:act];
}

// TODO: ないわーこれはないわー
- (CCFiniteTimeAction*)play_anime_onece:(NSString*)name
{
    CCAnimation *anim = [[CCAnimationCache sharedAnimationCache] animationByName:name];
    //NSAssert(anim, @"anim should be not nil");

    return anim ? [CCAnimate actionWithAnimation:anim] : nil;
}

//
//==============================================================================


@end
