//
//  SequenceBuilder.m
//  Dri
//
//  Created by  on 13/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SequenceBuilder.h"
#import "cocos2d.h"
#import "DungeonModel.h"
#import "DungeonView.h"
#import "DungeonSceneEventQueue.h"


@implementation SequenceBuilder

-(CCAction*)build:(CCLayer*)scene 
     dungeonModel:(DungeonModel*)dungeonModel 
      dungeonView:(DungeonView*)dungeonView
       eventQueue:(DungeonSceneEventQueue*)eventQueue
{
    // -------------------------------------------------------------------------
    // シーケンス再生中はタップ不可
    scene.isTouchEnabled = NO;
    
    // アクションのシーケンスを作成
    NSMutableArray *action_list = [NSMutableArray array];
    
    // -------------------------------------------------------------------------
    // プレイヤーの移動フェイズ(ブロックの移動フェイズ)
    CCAction *act_player_move = [dungeonView.player get_action_update_player_pos:dungeonModel view:dungeonView];
    if (act_player_move) {
        [action_list addObject:act_player_move];
    }
    
    // -------------------------------------------------------------------------
    // プレイヤーを中心にして、ブロックの明るさを変える
    [dungeonView update_block_color:dungeonModel center_pos:dungeonModel.player.pos];
    
    
    // -------------------------------------------------------------------------
    // ブロック毎のターン処理
    // アニメーション開始
    CCAction *act_animate = [eventQueue animate:dungeonModel
                                          dungeonView:dungeonView];
    NSLog(@"act_animate %@", act_animate);
    if (act_animate) {
        [action_list addObject:act_animate];
    }
    
    // -------------------------------------------------------------------------
    // TODO: これは入れるのか？？
    // エネミー死亡エフェクトフェイズ(相手のブロックの死亡フェイズ)
    // エネミーチェンジフェイズ
    
    // -------------------------------------------------------------------------
    // 画面の描画
    CCAction *act_update_view = [CCCallFuncO actionWithTarget:dungeonView selector:@selector(update_dungeon_view:) object:dungeonModel];
    [action_list addObject:act_update_view];
    
    // -------------------------------------------------------------------------
    // スクロールフェイズ
    CCAction *act_scroll = [CCCallFuncO actionWithTarget:scene
                                                selector:@selector(_doScroll)];
    [action_list addObject:act_scroll];
    
    // -------------------------------------------------------------------------
    // 現在の階層を更新
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"UpdateFloor" object:[NSNumber numberWithInt:(dungeonModel.lowest_empty_y - 4)]];
    
    
    // -------------------------------------------------------------------------
    // タッチをオンに
    //    CCAction *act_to_touchable = [CCCallFuncO actionWithTarget:scene selector:@selector(enableTouch)];
    CCAction *actToTouchable = [CCCallBlock actionWithBlock:^(void){
        scene.isTouchEnabled = YES;
    }];
    [action_list addObject:actToTouchable];
    
    // -------------------------------------------------------------------------
    // 実行
    return [CCSequence actionWithArray:action_list];
}

@end
