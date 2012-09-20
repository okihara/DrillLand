//
//  BloddyPresentation.m
//  Dri
//
//  Created by  on 12/09/02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BloodyPresentation.h"
#import "DungeonView.h"
#import "DamageNumView.h"

@implementation BloodyPresentation

-(CCAction*)handle_event:(DungeonView *)ctx event:(DLEvent*)e view:(BlockView *)view_
{
    BlockModel *b = (BlockModel*)e.target;
    
    switch (e.type) {
            
        case DL_ON_DAMAGE:
        {
            CCFiniteTimeAction *shake;
            if (b.type == ID_PLAYER) {
                shake = [ctx launch_effect_shake:@"shake" target:ctx params:nil];
            } else {
                shake = [ctx launch_effect_shake:@"shake" target:ctx params:nil];
                //shake = [CCDelayTime actionWithDuration:0];
            }

            CCCallBlock *act = [CCCallBlock actionWithBlock:^{

                // effect
                [ctx launch_particle:@"blood" position:view_.position];
                
                // damage num
                NSNumber *num = (NSNumber*)[e.params objectForKey:@"damage"];
                int damage = num ? [num intValue] : 0;
                CGPoint pos = [ctx model_to_local:b.pos];
                [ctx launch_effect:@"damage" position:pos param1:damage];
            }];
          
            return [CCSequence actions:shake, act, [CCDelayTime actionWithDuration:0.5], nil];
        }   
            break;
            
        // TODO: BloodyPresentation に書くものなのか？？
        // Healable Presentation 作る？
        case DL_ON_HEAL:
        {
            CCCallBlock *act = [CCCallBlock actionWithBlock:^{
                // effect
                [ctx launch_particle:@"heal" position:view_.position];
            }];
            
            CCCallBlock *act2 = [CCCallBlock actionWithBlock:^{
                // damage num
                BlockModel *b = (BlockModel*)e.target;
                NSNumber *num = (NSNumber*)[e.params objectForKey:@"damage"];
                int damage = num ? [num intValue] : 0;
                CGPoint pos = [ctx model_to_local:b.pos];
                [ctx launch_effect2:@"damage" position:pos param1:damage];
            }];
            return [CCSequence actions:act, [CCDelayTime actionWithDuration:1.0], act2, [CCDelayTime actionWithDuration:0.5], nil];
        }
            break;
            
        case DL_ON_ATTACK:
        {
            // TODO: とりあえずすぎる
            // TODO: Attackable Presentation 作り、移動する
            [view_ stopAllActions];
            
            // TODO: ないわー
            if (b.type == ID_PLAYER) {
                CCFiniteTimeAction *anim_attack = [view_ play_anime_one:@"atk000"];
                CCCallBlock *act_walk = [CCCallFuncO actionWithTarget:view_ selector:@selector(play_anime:) object:@"walk"];
                return [CCSequence actions:[CCTargetedAction actionWithTarget:view_ action:anim_attack], act_walk, nil];
            } else {
                CCFiniteTimeAction *anim_attack = [view_ play_anime_one:@"attack"];
                CCCallFuncO *act_walk = [CCCallFuncO actionWithTarget:view_ selector:@selector(play_anime:) object:@"action0"];
                return [CCSequence actions:[CCTargetedAction actionWithTarget:view_ action:anim_attack], act_walk, nil];
            }
        }
            break;
            
        default:
            return nil;
            break;
    }
}

@end
