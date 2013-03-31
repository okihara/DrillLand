//
//  ItemBoxPresentation.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "ItemBoxPresentation.h"
#import "DungeonView.h"

@implementation ItemBoxPresentation

-(CCAction*)handle_event:(DungeonView *)dungeon_view event:(DLEvent*)event view:(BlockView *)block_view
{
    BlockModel *block_model = event.target;

    switch (event.type) {

        case DL_ON_DESTROY:
        {
            // アクション：演出
            // implement here
            CCCallBlock *act_0 = [CCCallBlock actionWithBlock:^{
                [dungeon_view launch_particle:@"block" position:block_view.position];
                
                // アクション：移動（いなくなるのは移動と同じ）
                block_view.is_alive = NO;
                [dungeon_view remove_block_view_if_dead:block_model.pos];
            }];
            
            return act_0;
        }
            break;

        default:
            return nil;
            break;
    }
}

@end

