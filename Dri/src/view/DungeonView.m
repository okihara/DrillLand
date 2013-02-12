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

@implementation DungeonView

@synthesize player;
@synthesize offset_y;
@synthesize fade_layer;
@synthesize block_layer;
@synthesize effect_layer;

-(id) init
{
	if(self=[super init]) {
        
        self->disp_w = DM_WIDTH;
        self->disp_h = DV_DISP_H;

        self->offset_x = DV_OFFSET_X;
        self->offset_y = 0;
        
        self->latest_remove_y = -1;
        
        self->selected_block = nil;
        
        self->view_map = [[ObjectXDMap alloc] init];
        
        self->base_layer = [[CCLayer alloc] init];
        self->base_layer.position = ccp(self->offset_x, self->offset_y);
        [self addChild:self->base_layer];
        
        CCSprite *sky = [CCSprite spriteWithFile:@"sky00.png"];
        sky.position = ccp(160 - self->offset_x, 480 - 224 / 2);
        [self->base_layer addChild:sky];
        
        self->player_layer = [[CCLayer alloc] init];
        [self->base_layer addChild:self->player_layer];
        
        self->block_layer = [[CCLayer alloc] init];
        [self->base_layer addChild:self->block_layer];
        
        self->effect_layer = [[CCLayer alloc] init];
        [self->base_layer addChild:self->effect_layer];
        
        self->fade_layer = [[CCLayerColor layerWithColor:ccc4(0, 0, 0, 0)] retain];
        [self addChild:self->fade_layer];
    
        self->effect_launcher = [[EffectLauncher alloc] init];
        self->effect_launcher.target_layer = self->effect_layer;
        
        [self update_curring_range];
	}
	return self;
}

-(void)dealloc
{
    [self->effect_launcher release];
    [self->view_map release];    
    [super dealloc];
}


//------------------------------------------------------------------------------
//
-(void)add_player:(BlockView*)block
{
    [self->player_layer addChild:block];
}

-(BlockView*)get_block_view:(DLPoint)pos
{
    return [self->view_map get_x:pos.x y:pos.y];
}

//==============================================================================
//
// ブロックの明るさを計算アップデート
//
//==============================================================================

// TODO: BlockView に移動？
// 指定したポイントを基準に離れるほど暗くなる
- (void)updateColor:(BlockView*)block_view basePos:(DLPoint)center_pos
{
    int xx = abs(block_view.pos.x - center_pos.x);
    int yy = abs(center_pos.y - block_view.pos.y);
    int bright = 255 - 255 * (xx + yy) / LIGHT_RANGE * 1.0f;
    unsigned char color = bright < 0 ? 0 : bright;
    block_view.color = ccc3(color, color, color);
}

- (void)update_block_color:(DungeonModel *)dungeon_model center_pos:(DLPoint)center_pos
{
    for (int y = self->curring_top; y < self->curring_bottom; y++) {
        for (int x = 0; x < self->disp_w; x++) {
            BlockView *block_view = [self->view_map get_x:x y:y];
            if (!block_view) continue;
            [self updateColor:block_view basePos:center_pos];
        }
    }
}

//==============================================================================
//
// ブロックの描画
//
//==============================================================================

- (void)update_block:(int)y x:(int)x dungeon_model:(DungeonModel *)dungeon_model
{
    BlockView  *block_view  = [self->view_map get_x:x y:y];
    BlockModel *block_model = [dungeon_model get:cdp(x, y)];
    
    // 既に描画済みなら描画しない
    if (block_view || block_model.block_id == ID_EMPTY) {
        return;
    }
    
    block_view = [BlockViewBuilder build:block_model ctx:dungeon_model];
    block_view.position = [self mapPosToViewPoint:cdp(x, y)];
    block_view.pos = cdp(x, y);
    
    [self->block_layer addChild:block_view];
    [self->view_map set_x:x y:y value:block_view];
}

- (void)update_view_line:(int)y dungeon_model:(DungeonModel *)dungeon_model
{
    for (int x = 0; x < self->disp_w; x++) {
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
- (void)update_view:(DungeonModel *)dungeon_model
{
    // clear
    [self->block_layer removeAllChildrenWithCleanup:YES];
    [self->view_map clear];

    // curring を考慮して更新
    [self update_view_lines:dungeon_model];
    
    //
    [self update_block_color:dungeon_model center_pos:cdp(2, 3)];
}

// カリングを考慮して描画
// スクロール後、画面外を削って次に必要なブロックを描画
- (void)update_dungeon_view:(DungeonModel*)dungeon_model
{
    [self remove_block_view_outside:dungeon_model];
    [self update_view_lines:dungeon_model];
}


//------------------------------------------------------------------------------
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

- (void)remove_block_view_outside:(DungeonModel *)dungeon_model
{
    for (int y = self->latest_remove_y + 1; y < self->curring_top; y++) {
        [self remove_block_view_line:y _model:dungeon_model];
        self->latest_remove_y = y;
    }
}

//==============================================================================
//
// スクロール関係
// カリング関係
//
//==============================================================================

// 一番現在移動できるポイントが中央にくるまでスクロール？
// プレイヤーの位置が４段目ぐらいにくるよまでスクロール
// 一度いった時は引き返せない
// self->offset_y に依存
- (void)update_offset_y:(int)target_y
{
    int threshold = 3;
    
    int by = (int)(self->offset_y / BLOCK_WIDTH);
    int diff = target_y - by;
    int num_scroll = diff - threshold; 
    if (num_scroll > 0) {
        self->offset_y += BLOCK_WIDTH * num_scroll;
    }
    
    // ここらへんはフロアの情報によって決まる
    // current_floor_max_rows * block_height + margin
    int max_scroll = (DM_HEIGHT - self->disp_h) * BLOCK_WIDTH + 30;
    if (offset_y > max_scroll) {
        self->offset_y = max_scroll;   
    }
}

// カリングの計算
// 通常は 4~8 一気にスクロールする量による
// debug 用に -2 とかすると描画領域が狭くなる
// TODO: top と bottom で分けたほうがいいかも
// スクロールしたあとに消すってすれば top のカリングは 0 でもいいね
- (void)update_curring_range
{
    int visible_y = (int)(self->offset_y / BLOCK_WIDTH);
    self->curring_top  = visible_y - CURRING_VAR < 0 ? 0 : visible_y - CURRING_VAR;
    int num_draw = self->disp_h + CURRING_VAR;
    self->curring_bottom = visible_y + num_draw  > DM_HEIGHT ? DM_HEIGHT : visible_y + num_draw; 
}

// 実際の処理
-(void)scroll_to
{
    // カリングの幅を更新
    [self update_curring_range];
    
    // アクションを実行
    CCMoveTo *act_move = [CCMoveTo actionWithDuration:0.4f position:ccp(self->offset_x, self->offset_y)];
    CCEaseInOut *ease = [CCEaseInOut actionWithAction:act_move rate:2];
    [self->base_layer runAction:ease];
}


//==============================================================================
//
// notify
//
//==============================================================================

// TODO: DungeonScene においてもいいような。。。
// TODO: PLAYER も同じように扱いたい。。。
- (CCAction*)notify:(DungeonModel*)dungeon_ event:(DLEvent*)e
{
    BlockModel *b = (BlockModel*)e.target;
    
    if(b.block_id == ID_PLAYER) {
        
        BlockView* block = self.player;
        return [block handle_event:self event:e];
        
    } else {
        
        BlockView *block = [view_map get_x:b.pos.x y:b.pos.y];
        return [block handle_event:self event:e];
        
    }
}


//==============================================================================
// HELPER
// TODO: 別のクラスに移動
//==============================================================================

- (CGPoint)mapPosToViewPoint:(DLPoint)pos
{
    return ccp(BLOCK_WIDTH / 2 + pos.x * BLOCK_WIDTH,
               480 - (BLOCK_WIDTH / 2 + pos.y * BLOCK_WIDTH));
}

// スクリーン座標から viewMap の座標へ変換
- (DLPoint)viewPointToMapPos:(CGPoint)point
{
    int x = (UInt32)((      point.x - DV_OFFSET_X)      / BLOCK_WIDTH);
    int y = (UInt32)((480 - point.y + self->offset_y) / BLOCK_WIDTH);
    return cdp(x, y);
}


// =============================================================================
// エフェクト 委譲
// =============================================================================

-(void)launch_particle:(NSString*)name position:(CGPoint)pos
{
    [self->effect_launcher launch_particle:name position:pos];
}

-(CCFiniteTimeAction*)launch_effect:(NSString *)name target:(CCNode*)target params:(NSDictionary*)params
{
    return [self->effect_launcher launch_effect:name target:target params:params];
}

// =============================================================================
// タッチされた時におっきくする
// =============================================================================
- (void)on_touch_start:(DLPoint)pos
{
    BlockView *b_view = [self->view_map get_x:pos.x y:pos.y];
    b_view.scale *= 2.0;
    b_view.zOrder = 10000;
}


@end
