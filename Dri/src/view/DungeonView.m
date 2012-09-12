//
//  DungeonView.m
//  Dri
//
//  Created by  on 12/08/17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "../DL.h"
#import "DungeonView.h"
#import "XDMap.h"
#import "BlockModel.h"
#import "BlockView.h"

@implementation DungeonView

@synthesize delegate;
@synthesize curring_top, curring_bottom;
@synthesize player;


// ========================================================================
// エフェクト用のヘルパー
// ========================================================================

-(void)launch_particle:(NSString*)name position:(CGPoint)pos
{
    [self->effect_launcher launch_particle:name position:pos];
}

-(void)launch_effect:(NSString *)name
{
    // color flash
    // shake
    return;
}

// ========================================================================

-(id) init
{
	if(self=[super init]) {
        
        disp_w = WIDTH;
        disp_h = HEIGHT;
        offset_y = 0;
        
        self->view_map = [[ObjectXDMap alloc] init];
        
        self->block_layer = [[CCLayer alloc]init];
        [self addChild:self->block_layer];
        
        CCSprite *sky = [CCSprite spriteWithFile:@"sky00.png"];
        sky.position = ccp(160, 480 - 120 + 53 + 10);
        [self addChild:sky];
        
        self->effect_layer = [[CCLayer alloc]init];
        [self addChild:self->effect_layer];
             
        self->effect_launcher = [[EffectLauncher alloc] init];
        self->effect_launcher.target_layer = self->effect_layer;
        
	}
	return self;
}


// ========================================================================

-(void)add_block:(BlockView*)block
{
    [self->effect_layer addChild:block];    
}


//===============================================================
//
// ブロックの描画
//
//===============================================================

- (void)update_view_line:(int)y _model:(DungeonModel *)dungeon_
{
    for (int x = 0; x < disp_w; x++) {
        BlockModel *block_model = [dungeon_ get_x:x y:y];
        BlockView *block = [BlockView create:block_model ctx:dungeon_];
        block.position = [self model_to_local:cdp(x, y)];
        
        [self->block_layer addChild:block];
        [view_map set_x:x y:y value:block];
    }
}

- (void)update_view_lines:(DungeonModel *)_dungeon
{
    for (int y = self.curring_top; y < self.curring_bottom; y++) {
        [self update_view_line:y _model:_dungeon];
    }
}

- (void)update_view:(DungeonModel *)_dungeon
{
    // clear
    [self->block_layer removeAllChildrenWithCleanup:YES];
    [view_map clear];

    // curring を考慮して更新
    [self update_view_lines:_dungeon];
}

- (void)remove_view_line:(int)y _model:(DungeonModel *)_dungeon
{
    for (int x = 0; x < disp_w; x++) {
        BlockView *block = [self->view_map get_x:x y:y];
        [self->block_layer removeChild:block cleanup:YES];
        [view_map set_x:x y:y value:nil];
    }
}


//===============================================================
//
// プレゼンテーションの更新
//
//===============================================================

- (void)update_presentation_all:(DungeonModel *)dungeon_
{
    // curring を考慮して更新
    for (int y = self.curring_top; y < self.curring_bottom; y++) {
        for (int x = 0; x < disp_w; x++) {
            BlockModel *block_model = [dungeon_ get_x:x y:y];
            BlockView  *block_view  = [self->view_map get_x:x y:y];
            [block_view update_presentation:self model:block_model];
        }
    }
}

-(void)update_presentation:(DungeonModel *)dungeon_
{
    // TODO: PLAYER も同じように扱いたい。。。
    [self update_presentation_all:dungeon_];
    [self.player update_presentation:self model:dungeon_.player];
}


//===============================================================
//
// notify
//
//===============================================================

- (void) notify:(int)type dungeon:(DungeonModel*)dungeon_ params:(id)params
{
    // TODO: ここは、ひたすらQueにためるだけ
    BlockModel* b = (BlockModel*)params;
    switch (type) {
        case 0:
            //[self update_view:dungeon_]; // 画面更新
            break;
        default:
            
            // TODO: PLAYER も同じように扱いたい。。。
            if(b.type == ID_PLAYER) {
                BlockView* block = self.player;
                [block handle_event:self type:type model:b];
            } else {
                BlockView* block = [view_map get_x:b.pos.x y:b.pos.y];
                [block handle_event:self type:type model:b];
            }

            break;
    }
}


//===============================================================
//
// HELPER
//
//===============================================================

- (CGPoint)model_to_local:(DLPoint)pos
{
    return ccp(30 + pos.x * BLOCK_WIDTH, 480 - (30 + pos.y * BLOCK_WIDTH));
}


//===============================================================
//
// プレイヤーの移動系
//
//===============================================================

// CCAction を返す
// ルートにそって移動する CCAction を返す

- (CCAction*)get_action_update_player_pos:(DungeonModel *)_dungeon
{
    int length = [_dungeon.route_list count];
    if (length == 0) return nil;
    
    float duration = 0.15 / length;
    NSMutableArray* action_list = [NSMutableArray arrayWithCapacity:length];
    for (NSValue* v in _dungeon.route_list) {
        DLPoint pos;
        [v getValue:&pos];
        
        CGPoint cgpos = [self model_to_local:pos];
        CCMoveTo *act_move = [CCMoveTo actionWithDuration:duration position:cgpos];
        [action_list addObject:act_move];
    }
    
    CCAction* action = [CCSequence actionWithArray:action_list];
    //CCEaseInOut *ease = [CCEaseInOut actionWithAction:acttion rate:2];
    [action retain];
    return action;
}

- (void)update_player_pos:(DungeonModel *)_dungeon {

    CCAction* action = [self get_action_update_player_pos:_dungeon];
    if (!action) {
        return;
    }
    [self->player runAction:action];
}

@end
