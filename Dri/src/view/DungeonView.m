//
//  DungeonView.m
//  Dri
//
//  Created by  on 12/08/17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "DL.h"
#import "DungeonView.h"
#import "XDMap.h"
#import "BlockModel.h"
#import "BlockView.h"
#import "BlockViewBuilder.h"

#define DISP_H 8

@implementation DungeonView

@synthesize player;
@synthesize offset_y;

-(id) init
{
	if(self=[super init]) {
        
        disp_w = WIDTH;
        disp_h = HEIGHT;
        offset_y = 0;
        latest_remove_y = -1;
        
        self->view_map = [[ObjectXDMap alloc] init];
        
        self->block_layer = [[CCLayer alloc] init];
        [self addChild:self->block_layer];
        
        CCSprite *sky = [CCSprite spriteWithFile:@"sky00.png"];
        sky.position = ccp(160, 480 - 64 - 11);
        [self addChild:sky];
        
        self->effect_layer = [[CCLayer alloc] init];
        [self addChild:self->effect_layer];
             
        self->effect_launcher = [[EffectLauncher alloc] init];
        self->effect_launcher.target_layer = self->effect_layer;
        
	}
	return self;
}

-(void)dealloc
{
    [self->effect_launcher release];
    [self->view_map release];
    
    [super dealloc];
}

// ========================================================================

-(void)add_block:(BlockView*)block
{
    // TODO: プレイヤーを一番上にするために。。。
    [self->effect_layer addChild:block];    
}

//===============================================================
//
// ブロックの描画
//
//===============================================================

- (void)update_block:(int)y x:(int)x dungeon_model:(DungeonModel *)dungeon_model
{
    BlockView *block = [view_map get_x:x y:y];
    BlockModel *block_model = [dungeon_model get:cdp(x, y)];
    
    
    // TODO: 何かしら変えるべき
    // -----------------------------------------------------
    if (block.is_change) {
        [self remove_block_view:block_model.pos];
    }
    // 既に描画済みなら描画しない
    if (block && !block.is_change) {
        return;
    }
    block.is_change = NO;
    // -----------------------------------------------------
    
    
    block = [BlockViewBuilder create:block_model ctx:dungeon_model];
    block.position = [self model_to_local:cdp(x, y)];
    
    [self->block_layer addChild:block];
    [view_map set_x:x y:y value:block];
}

- (void)update_view_line:(int)y dungeon_model:(DungeonModel *)dungeon_model
{
    for (int x = 0; x < disp_w; x++) {
        [self update_block:y x:x dungeon_model:dungeon_model];
    }
}

// curring_top から curring_bottom まで描画
- (void)update_view_lines:(DungeonModel *)dungeon_model
{
    for (int y = self->curring_top; y < self->curring_bottom; y++) {
        [self update_view_line:y dungeon_model:dungeon_model];
    }
}

// 最初に一回しか呼ばないかも
// update_view -> update_view_lines -> update_view_line
- (void)update_view:(DungeonModel *)_dungeon
{
    // clear
    [self->block_layer removeAllChildrenWithCleanup:YES];
    [view_map clear];

    // curring を考慮して更新
    [self update_view_lines:_dungeon];
}

- (void)remove_block_view_outside:(DungeonModel *)dungeon_model
{
    for (int y = self->latest_remove_y + 1; y < self->curring_top; y++) {
        [self remove_block_view_line:y _model:dungeon_model];
        self->latest_remove_y = y;
    }
}

// カリングを考慮して描画
// スクロール後、画面外を削って次に必要なブロックを描画
- (void)update_dungeon_view:(DungeonModel*)dungeon_model
{
    [self remove_block_view_outside:dungeon_model];
    [self update_view_lines:dungeon_model];
}


//--------------------------------------------
// remove

- (void)remove_block_view:(DLPoint)pos
{
    BlockView *block = [self->view_map get_x:pos.x y:pos.y];
    // TODO: cleanup = NO なの？？
    [self->block_layer removeChild:block cleanup:NO];
    [view_map set_x:pos.x y:pos.y value:nil];
}

- (void)remove_block_view_line:(int)y _model:(DungeonModel *)_dungeon
{
    for (int x = 0; x < disp_w; x++) {
        [self remove_block_view:cdp(x, y)];
    }
}

- (void)remove_block_view_if_dead:(DLPoint)pos
{
    BlockView *block = [self->view_map get_x:pos.x y:pos.y];
    if (block.is_alive == NO) {
        [self remove_block_view:pos];
    }
}

//===============================================================
//
// スクロール関係
// TODO: dungeon_view 移動
// カリングの機能は view が持つべき
//
//===============================================================

- (void)update_offset_y:(int)target_y
{
    // 一番現在移動できるポイントが中央にくるまでスクロール？
    // プレイヤーの位置が４段目ぐらいにくるよまでスクロール
    // 一度いった時は引き返せない
    
    // self->offset_y に依存
    
    int threshold = 3;
    
    int by = (int)(self->offset_y / BLOCK_WIDTH);
    int diff = target_y - by;
    int num_scroll = diff - threshold; 
    if (num_scroll > 0) {
        self->offset_y += BLOCK_WIDTH * num_scroll;
    }
    
    // ここらへんはフロアの情報によって決まる
    // current_floor_max_rows * block_height + margin
    int max_scroll = (HEIGHT - DISP_H) * BLOCK_WIDTH + 30;
    if (offset_y > max_scroll) {
        self->offset_y = max_scroll;   
    }
}

// カリングの計算
- (void)update_curring_range
{
    // 通常は 0
    // debug 用に -2 とかすると描画領域が狭くなる
    int curring_var = 0;
    
    // カリング
    int visible_y = (int)(self->offset_y / BLOCK_WIDTH);
    self->curring_top    = visible_y - curring_var < 0 ? 0 : visible_y - curring_var;
    int num_draw = DISP_H + curring_var;
    self->curring_bottom = visible_y + num_draw  > HEIGHT ? HEIGHT : visible_y + num_draw; 
}

// 実際の処理
-(void)scroll_to
{
    // カリングの幅を更新
    [self update_curring_range];
    
    // アクションを実行
    CCMoveTo *act_move = [CCMoveTo actionWithDuration: 0.4 position:ccp(0, self->offset_y)];
    CCEaseInOut *ease = [CCEaseInOut actionWithAction:act_move rate:2];
    [self runAction:ease];
}


//===============================================================
//
// notify
//
//===============================================================

// TODO: DungeonScene においてもいいような。。。

- (CCAction*)notify:(DungeonModel*)dungeon_ event:(DLEvent*)e
{
    // TODO: PLAYER も同じように扱いたい。。。
    
    BlockModel *b = (BlockModel*)e.target;
    
    if(b.type == ID_PLAYER) {
        
        BlockView* block = self.player;
        return [block handle_event:self event:e];
        
    } else {
        
        BlockView *block = [view_map get_x:b.pos.x y:b.pos.y];
        return [block handle_event:self event:e];
        
    }
}


//===============================================================
//
// HELPER
// TODO: 別のクラスに移動
//===============================================================

- (CGPoint)model_to_local:(DLPoint)pos
{
    return ccp(30 + pos.x * BLOCK_WIDTH, 480 - (30 + pos.y * BLOCK_WIDTH));
}


// ========================================================================
// エフェクト用のヘルパー
// TODO: 別クラスへ
// ========================================================================

-(void)launch_particle:(NSString*)name position:(CGPoint)pos
{
    [self->effect_launcher launch_particle:name position:pos];
}

-(CCFiniteTimeAction*)launch_effect:(NSString *)name target:(CCNode*)target params:(NSDictionary*)params
{
    return [self->effect_launcher launch_effect:name target:target params:params];
}

@end
