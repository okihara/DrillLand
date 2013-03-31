//
//  EnemyPresentation.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "SimpleAudioEngine.h"

#import "EnemyPresentation.h"
#import "DungeonView.h"
#import "BlockModel.h"

#import "GetExpView.h"
#import "GetGoldView.h"

@implementation EnemyPresentation

-(CCAction*)handle_event:(DungeonView *)dungeon_view event:(DLEvent*)event view:(BlockView *)block_view
{
    BlockModel *block = event.target;

    switch (event.type) {

        case DL_ON_DAMAGE:
        {
            // アクション：演出(shake)
            CCFiniteTimeAction *shake = [dungeon_view launch_effect:@"shake" target:block_view params:nil];
            return [CCSequence actions:shake, [CCDelayTime actionWithDuration:0], nil];
        }
            break;
            
        case DL_ON_DESTROY:
        {
            // アクション：演出
            CCCallBlock *act_0 = [CCCallBlock actionWithBlock:^{
                [dungeon_view launch_particle:@"block" position:block_view.position];
            }];

            // アクション：移動
            CCMoveBy *act_1 = [CCDelayTime actionWithDuration:0.05f];
            
            CCCallBlock *act_2 = [CCCallBlock actionWithBlock:^{

                // アクション：生成
                // coin
                [GetGoldView spawn:dungeon_view.effect_layer position:block_view.position num_exp:10];
                
                // exp
                [GetExpView spawn:dungeon_view.effect_layer position:block_view.position num_exp:3];
                
                // アクション：効果音
                [[SimpleAudioEngine sharedEngine] playEffect:@"death3.wav"];
                
                // --
                block_view.is_alive = NO;
                [dungeon_view remove_block_view_if_dead:block.pos];
            }];
            
            return [CCSequence actions:act_0, act_1, act_2, nil];
        }
            break;            

        default:
            return nil;
            break;
    }
}

@end
