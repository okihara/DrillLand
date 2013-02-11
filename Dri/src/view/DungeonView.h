//
//  DungeonView.h
//  Dri
//
//  Created by  on 12/08/17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EffectLauncher.h"
#import "DungeonModel.h"
#import "DLEvent.h"
#import "BlockView.h"
#import "cocos2d.h"
#import "DLView.h"

@class XDMap;
@class BlockView;

#define DV_DISP_H 8
#define LIGHT_RANGE 6
#define CURRING_VAR 6
#define DV_OFFSET_X -36

// memo: DungeonView の使い方は、物理エンジンの扱い方と同じにしたほうが良いかも
// ?
@interface DungeonView : CCLayer<ViewContextProtocol>
{
    // この２つは１つの型に出来る
    int disp_w;
    int disp_h;

    
    // スクロール/カリング
    int offset_x;
    int offset_y;
    
    int latest_remove_y;

    int curring_top;
    int curring_bottom;
    
    
    ObjectXDMap *view_map;
    
    // -- レイヤー
    CCLayer      *base_layer;
    CCLayer      *player_layer;
    CCLayer      *block_layer;
    CCLayer      *effect_layer;
    CCLayerColor *fade_layer;
    
    // --- 
    EffectLauncher *effect_launcher;
    
    // ---
    BlockView *selected_block;
}

@property (nonatomic, readonly, retain) CCLayerColor *fade_layer;
@property (nonatomic, readonly, retain) CCLayer *block_layer;
@property (nonatomic, readonly, retain) CCLayer *effect_layer;
@property (nonatomic, readwrite, retain) BlockView* player;
@property (nonatomic, readonly) int offset_y;


-(void)add_player:(BlockView*)block;
-(BlockView*)get_block_view:(DLPoint)pos;


// 描画
- (void)update_block:(int)y x:(int)x dungeon_model:(DungeonModel *)dungeon_model;
- (void)update_view:(DungeonModel *)_dungeon;

- (void)remove_block_view:(DLPoint)pos;
- (void)remove_block_view_if_dead:(DLPoint)pos;

// ライトの処理
- (void)update_block_color:(DungeonModel *)dungeon_model center_pos:(DLPoint)center_pos;

//
- (void)on_touch_start:(DLPoint)pos;

// スクロール関係
// カリングの計算
- (void)update_offset_y:(int)target_y;
- (void)scroll_to;

// イベントハンドラ
- (CCAction*)notify:(DungeonModel*)dungeon_ event:(DLEvent*)e;

// ヘルパ
- (CGPoint)model_to_local:(DLPoint)pos;


@end
