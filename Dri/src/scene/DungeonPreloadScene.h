//
//  DungeonPreloadScene.h
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class DungeonModel;

@interface DungeonPreloadScene : CCLayer
{
    DungeonModel *dungeon_model;
}

+ (CCScene *)sceneWithDungeonId:(uint)dungeon_id;

@end

