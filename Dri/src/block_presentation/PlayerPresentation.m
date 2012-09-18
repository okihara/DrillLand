//
//  PlayerPresentation.m
//  Dri
//
//  Created by  on 12/09/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerPresentation.h"
#import "DungeonView.h"
#import "DungeonOverScene.h"

@implementation PlayerPresentation

-(CCAction*)handle_event:(DungeonView *)ctx event:(DLEvent*)e view:(BlockView *)view_
{
    switch (e.type) {
            
        case DL_ON_DESTROY:
        {
            // TODO: ここでシーン遷移するのはどう考えてもおかしいやろ
            return [CCCallBlock actionWithBlock:^(){
                [[CCDirector sharedDirector] replaceScene:[DungeonOverScene scene]];
            }];
        }   
            break;
        case DL_ON_ATTACK:
        {
            
            // TODO: とりあえずすぎる
            // TODO: Attackable Presentation 作り、移動する
            CCFiniteTimeAction *anim_attack = [view_ play_anime_one:@"attack"];
            [view_ stopAllActions];
            CCCallBlock *action_walk = [CCCallBlock actionWithBlock:^(){
                [view_ play_anime:@"walk"];
            }];
            return [CCSequence actions:[CCTargetedAction actionWithTarget:view_ action:anim_attack], action_walk, nil];
        }
            break;
            
        default:
            return nil;
            break;
    }
}

@end
