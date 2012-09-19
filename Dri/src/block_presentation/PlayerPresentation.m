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
            
        default:
            return nil;
            break;
    }
}

@end
