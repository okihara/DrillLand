//
//  GettableItemPresentation.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "GettableItemPresentation.h"
#import "DungeonView.h"

@implementation GettableItemPresentation

-(CCAction*)handle_event:(DungeonView *)dungeon_view event:(DLEvent*)event view:(BlockView *)block_view
{
    BlockModel *block = event.target;

    switch (event.type) {

        case DL_ON_DESTROY:
        {
//            CCMoveBy *act_1 = [CCTargetedAction actionWithTarget:block_view action:[CCFadeOut actionWithDuration:0.3f]];
            
            // アクション：移動
            CCMoveBy *mb = [CCTargetedAction actionWithTarget:block_view action:[CCMoveBy actionWithDuration:0.1f position:ccp(0, BLOCK_WIDTH)]];
            CCDelayTime *delay = [CCDelayTime actionWithDuration:0.3f];
            // implement here
            // TODO: この NO にして remove するのなんとかならんか
            CCCallBlock *act_2 = [CCCallBlock actionWithBlock:^{
                block_view.is_alive = NO;
                [dungeon_view remove_block_view_if_dead:block.pos];
            }];
            return [CCSequence actions:mb, delay, act_2, nil];
        }
            break;

        default:
            return nil;
            break;
    }
}

@end

