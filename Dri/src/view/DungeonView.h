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

@class XDMap;
@class BlockView;

@interface DungeonView : CCLayer
{
    // この２つは１つの型に出来る
    int disp_w;
    int disp_h;
    
    int offset_y;
    int latest_remove_y;

    int curring_top;
    int curring_bottom;
    
    ObjectXDMap *view_map;
    
    CCLayer *effect_layer;
    CCLayer *block_layer;
    
    EffectLauncher *effect_launcher;
}

@property (nonatomic, readwrite, retain) BlockView* player;
@property (readonly) int offset_y;


- (void)add_block:(BlockView*)block;

// 描画
- (void)update_view_line:(int)y _model:(DungeonModel *)dungeon_;
- (void)update_view_lines:(DungeonModel *)_dungeon;
- (void)update_view:(DungeonModel *)_dungeon;
- (void)update_dungeon_view:(DungeonModel*)dungeon_model;

- (void)remove_block_view:(DLPoint)pos;
- (void)remove_block_view_line:(int)y _model:(DungeonModel *)_dungeon;
- (void)remove_block_view_if_dead:(DLPoint)pos;

// スクロール関係
// カリングの計算
- (void)update_offset_y:(int)target_y;
- (void)update_curring_range;
- (void)scroll_to;

// イベントハンドラ
- (CCAction*)notify:(DungeonModel*)dungeon_ event:(DLEvent*)e;

// ヘルパ
- (CGPoint)model_to_local:(DLPoint)pos;

// TODO: ガチで別クラスへ
- (void)launch_particle:(NSString*)name position:(CGPoint)pos;
//- (void)launch_effect:(NSString *)name position:(CGPoint)pos param1:(int)p1;
-(CCFiniteTimeAction*)launch_effect:(NSString *)name target:(CCNode*)target params:(NSDictionary*)params;


//- (void)launch_effect2:(NSString *)name position:(CGPoint)pos param1:(int)p1;
//- (CCFiniteTimeAction*)launch_effect_shake:(NSString *)name target:(CCNode*)target params:(NSDictionary*)params;
//
@end
