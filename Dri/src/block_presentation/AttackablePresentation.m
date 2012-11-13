//
//  AttackablePresentation.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "AttackablePresentation.h"
#import "DungeonView.h"

@implementation AttackablePresentation

-(CCAction*)handle_event:(DungeonView *)dungeon_view event:(DLEvent*)event view:(BlockView *)block_view
{
    BlockModel *block_model = (BlockModel*)event.target;

    switch (event.type) {

        case DL_ON_ATTACK:
        {
            // TODO: とりあえずすぎる
            // TODO: Attackable Presentation 作り、移動する
            [block_view stopAllActions];
            
            // 俺のターンエフェクト
            // いるならここに
            
            // TODO: ないわー
            // ここで分岐とかないわー
            if (block_model.block_id == ID_PLAYER) {
                CCFiniteTimeAction *anim_attack = [block_view play_anime_one:@"atk000"];
                CCCallBlock *act_walk = [CCCallFuncO actionWithTarget:block_view selector:@selector(play_anime:) object:@"walk"];
                return [CCSequence actions:
                        [CCTargetedAction actionWithTarget:block_view action:anim_attack],
                        [CCDelayTime actionWithDuration:1.0f / 10],
                        act_walk,
                        nil];
            } else {
                CCFiniteTimeAction *anim_attack = [block_view play_anime_one:@"attack"];
                CCCallFuncO *act_walk = [CCCallFuncO actionWithTarget:block_view selector:@selector(play_anime:) object:@"action0"];
                return [CCSequence actions:
                        [CCTargetedAction actionWithTarget:block_view action:anim_attack],
                        [CCDelayTime actionWithDuration:1.0f / 10],
                        act_walk,
                        nil];
            }
        }
            break;

        default:
            return nil;
            break;
    }
}

@end
