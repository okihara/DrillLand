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


//===============================================================
//
//
//
//===============================================================

- (CCAction*)_update_presentation:(DungeonView *)ctx event:(DLEvent*)e
{
    // TODO: プレイヤーその他で処理が別れとる(´；ω；｀)ﾌﾞﾜｯ
    
    BlockModel *b = (BlockModel*)e.target;
    NSMutableArray *actions = [NSMutableArray array];
    
    if (b.type == ID_PLAYER){
        
        for (NSObject<BlockPresentation>* p in self->presentation_list) {
            CCAction *action = [p handle_event:ctx event:e view:ctx.player];
            if (action) {
                [actions addObject:action];
            }
        }
        
    } else {
        
        for (NSObject<BlockPresentation>* p in self->presentation_list) {
            CCAction *action = [p handle_event:ctx event:e view:self];
            if (action) {
                [actions addObject:action];
            }
        }
        
    }
    
    if ([actions count]) {
        return [CCSequence actionWithArray:actions];
    } else {
        return nil;
    }
}


//----------------------------------------------------------------

- (CCAction*)handle_event:(DungeonView*)ctx event:(DLEvent*)e
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
