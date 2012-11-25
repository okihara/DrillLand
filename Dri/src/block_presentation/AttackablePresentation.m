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
            [block_view stopAllActions];
            
            // 俺のターンエフェクトがいるならここに書く
            // 

            // ---
            CCFiniteTimeAction *anim_attack = [block_view play_attack:block_model];
            CCFiniteTimeAction *anim_front  = [block_view play_front:block_model];
            
            return [CCSequence actions:
                    [CCTargetedAction actionWithTarget:block_view action:anim_attack],
                    [CCDelayTime actionWithDuration:1.0f / 10],
                    anim_front,
                    nil];
        }
            break;

        default:
            return nil;
            break;
    }
}

@end
