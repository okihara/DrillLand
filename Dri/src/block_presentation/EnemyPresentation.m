//
//  EnemyPresentation.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "EnemyPresentation.h"
#import "DungeonView.h"

@implementation EnemyPresentation

-(CCAction*)handle_event:(DungeonView *)dungeon_view event:(DLEvent*)event view:(BlockView *)block_view
{
    switch (event.type) {

        case DL_ON_DAMAGE:
        {
            CCFiniteTimeAction *shake = [dungeon_view launch_effect:@"shake" target:block_view params:nil];
            return [CCSequence actions:shake, [CCDelayTime actionWithDuration:0], nil];
        }
            break;

        default:
            return nil;
            break;
    }
}

@end
