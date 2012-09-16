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
#import "BreakablePresentation.h"
#import "BloodyPresentation.h"
#import "PlayerPresentation.h"


@implementation BlockView

@synthesize is_alive;

- (void)setup
{
    self->events = [[NSMutableArray array] retain];
    self->presentation_list = [[NSMutableArray array] retain];
    is_alive = YES;
}

- (id)init
{
	if (self=[super init]) {
        [self setup];
	}
	return self;
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


//===============================================================
//
// プレイヤーの移動系
//
//===============================================================

// CCAction を返す
// ルートにそって移動する CCAction を返す

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

//===============================================================
//
// どちらかというと builder
//
//===============================================================

+ (void)add_route_num:(BlockModel *)b ctx:(DungeonModel *)ctx block:(BlockView *)block
{
    // 経路探索の結果を数字で表示
    int c = [ctx.route_map get:b.pos];
    CCLabelTTF *cost = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", c] fontName:@"AppleGothic" fontSize:20];
    cost.position =  ccp(40, 30);
    cost.color = ccc3(0, 0, 255);
    [block addChild:cost];
}

+ (void)add_can_destroy_num:(BlockModel *)b block:(BlockView *)block
{
    // 破壊できるか表示
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"1" fontName:@"AppleGothic" fontSize:20];
    label.position =  ccp(30, 30);
    label.color = ccc3(0, 0, 0);
    label.visible = b.can_tap; // タップ出来ないときは数字を見せない
    [block addChild:label];
}

+ (BlockView *)create:(BlockModel*)b ctx:(DungeonModel*)ctx
{
    // ブロック
    NSString *filename;
    switch (b.type) {
        case ID_NORMAL_BLOCK:
            filename = @"block01.png";
            break;
        case ID_GROUPED_BLOCK_1:
            filename = @"block02.png";
            break;
        case ID_GROUPED_BLOCK_2:
            filename = @"block03.png";
            break;
        case ID_GROUPED_BLOCK_3:
            filename = @"block04.png";
            break;
        case ID_ENEMY_BLOCK_0:
            filename = @"mon001.png";
            break;
        case ID_ENEMY_BLOCK_1:
            filename = @"mon002.png";
            break;
        case ID_UNBREAKABLE_BLOCK:
            filename = @"block99.png";
            break;
        case ID_ITEM_BLOCK_0:
            filename = @"block201.png";
            break;
        default:
            filename = @"block00.png";
            break;
    }
    
    BlockView* block = [BlockView spriteWithFile:filename];
    [block setup];
    
    switch (b.type) {
        case ID_EMPTY:
        {
            [self add_route_num:b ctx:ctx block:block];
        }
            break;
        case ID_PLAYER:
        {
            {
                NSObject<BlockPresentation>* p = [[BloodyPresentation alloc] init];
                [block add_presentation:p];
                [p release];
            }
            
            {
                NSObject<BlockPresentation>* p = [[PlayerPresentation alloc] init];
                [block add_presentation:p];
                [p release];
            }
            
            
            [block play_anime:@"walk"];
        }
            break;
        case ID_ENEMY_BLOCK_0:
        case ID_ENEMY_BLOCK_1:
        {
            [self add_can_destroy_num:b block:block];
            
            NSObject<BlockPresentation>* p;
            
            p = [[BreakablePresentation alloc] init];
            [block add_presentation:p];
            [p release];
            
            p = [[BloodyPresentation alloc] init];
            [block add_presentation:p];
            [p release];
        }            
            break;
        default:
        {
            [self add_can_destroy_num:b block:block];
            
            NSObject<BlockPresentation>* p;
            
            p = [[BreakablePresentation alloc] init];
            [block add_presentation:p];
            [p release];
        }
            break;
    }

    return block;
}

@end
