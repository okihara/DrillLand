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
    DungeonModel *dungeonModel = [e.params objectForKey:@"dungeon_model"];

    switch (e.type) {
            
        case DL_ON_DAMAGE:
        {
            CCFiniteTimeAction *shake;
            shake = [ctx launch_effect:@"shake" target:ctx params:nil];
            return shake;
        }
            break;
            
        case DL_ON_DESTROY:
        {
            // TODO: ここでシーン遷移するのはどう考えてもおかしいやろ
            // DungeonScene にイベント投げるぐらいにするべき
            return [CCCallBlock actionWithBlock:^(){
                [[CCDirector sharedDirector] replaceScene:[DungeonOverScene scene]];
            }];
        }   
            break;
            
        case DL_ON_MOVE:
        {
            return [self get_action_update_player_pos:dungeonModel view:ctx];
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (CCAction*)get_action_update_player_pos:(DungeonModel *)_dungeon view:(DungeonView*)view
{
    int length = [_dungeon.routeList count];
    if (length == 0) return nil;
    
    float duration = 0.15 / length;
    NSMutableArray *action_list = [NSMutableArray arrayWithCapacity:length];
    for (NSValue *v in _dungeon.routeList) {
        
        DLPoint nextPos;
        [v getValue:&nextPos];
        CGPoint cgpos = [view mapPosToViewPoint:nextPos];
        CCMoveTo *act_move = [CCMoveTo actionWithDuration:duration position:cgpos];
        
        [action_list addObject:act_move];
    }
    
    CCAction *action = [CCSequence actionWithArray:action_list];
    //CCEaseInOut *ease = [CCEaseInOut actionWithAction:acttion rate:2];
    [action retain]; // この retain いる？
    return action;
}

@end
