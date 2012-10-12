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
            CCMoveBy *act_1 = [CCTargetedAction actionWithTarget:block_view action:[CCMoveBy actionWithDuration:0.1f position:ccp(0, 60)]];
            
            // implement here
            CCCallBlock *act_2 = [CCCallBlock actionWithBlock:^{
                block_view.is_alive = NO;
                [dungeon_view remove_block_view_if_dead:block.pos];
            }];
            return [CCSequence actions:act_1, act_2, nil];
        }
            break;

        default:
            return nil;
            break;
    }
}

@end

