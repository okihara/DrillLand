//
//  BlockView.m
//  Dri
//
//  Created by  on 12/08/18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockView.h"
#import "BlockModel.h"
#import "DungeonView.h"


@implementation BlockView

@synthesize is_alive;
@synthesize is_change; // TODO: カプセル化違反

- (id)init
{
	if (self=[super init]) {
        [self setup];
	}
	return self;
}

- (void)setup
{
    self->events = [[NSMutableArray array] retain];
    self->presentation_list = [[NSMutableArray array] retain];
    is_alive = YES;
    is_change = NO;
}

- (void)dealloc
{
    [self->presentation_list release];
    [self->events release];
    [super dealloc];
}

- (void)add_presentation:(NSObject<BlockPresentation>*)presentation
{
    [self->presentation_list addObject:presentation];
}

//==============================================================================

-(CCFiniteTimeAction*)play_attack:(BlockModel*)block_model
{
    NSString *anime_name;

    switch (block_model.block_id) {
            
        case ID_PLAYER:
            anime_name = @"atk000";
            break;
            
        default:
            anime_name = @"attack";
            break;
    }
    
    return [self play_anime_one:anime_name];
}

-(CCFiniteTimeAction*)play_front:(BlockModel*)block_model
{
    NSString *anime_name;

    switch (block_model.block_id) {
            
        case ID_PLAYER:
            anime_name = @"walk";
            break;
            
        default:
            anime_name = @"action0";
            break;
    }
    
    return [CCCallFuncO actionWithTarget:self selector:@selector(play_anime:) object:anime_name];
}


//==============================================================================

- (CCAction*)_update_presentation:(NSObject<ViewContextProtocol>*)ctx event:(DLEvent*)e
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


//----------------------------------------------------------------

//- (CCAction*)handle_event:(DungeonView*)ctx event:(DLEvent*)e
- (CCAction*)handle_event:(NSObject<ViewContextProtocol>*)ctx event:(DLEvent*)e
{
    return [self _update_presentation:ctx event:e];
}


//----------------------------------------------------------------
// animation helper

- (void)play_anime:(NSString*)name
{
    CCAnimation *anim = [[CCAnimationCache sharedAnimationCache] animationByName:name];
    CCAction* act = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:anim]];
    [self runAction:act];   
}

// TODO: ないわーこれはないわー
- (CCFiniteTimeAction*)play_anime_one:(NSString*)name
{
    CCAnimation *anim = [[CCAnimationCache sharedAnimationCache] animationByName:name];
    CCFiniteTimeAction* act = [CCAnimate actionWithAnimation:anim];
    return act;
}


//===============================================================
//
// プレイヤーの移動系
//
//===============================================================

// CCAction を返す
// ルートにそって移動する CCAction を返す
// TODO: 若干浮いてるね

- (CCAction*)get_action_update_player_pos:(DungeonModel *)_dungeon view:(DungeonView*)view
{
    int length = [_dungeon.route_list count];
    if (length == 0) return nil;
    
    float duration = 0.15 / length;
    NSMutableArray* action_list = [NSMutableArray arrayWithCapacity:length];
    for (NSValue* v in _dungeon.route_list) {
        DLPoint pos;
        [v getValue:&pos];
        
        CGPoint cgpos = [view model_to_local:pos];
        CCMoveTo *act_move = [CCMoveTo actionWithDuration:duration position:cgpos];
        [action_list addObject:act_move];
    }
    
    CCAction* action = [CCSequence actionWithArray:action_list];
    //CCEaseInOut *ease = [CCEaseInOut actionWithAction:acttion rate:2];
    [action retain];
    return action;
}

@end
