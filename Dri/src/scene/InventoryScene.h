//
//  InventoryScene.h
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class MyItems;
@class DungeonModel;

@interface InventoryScene : CCLayer
{
    DungeonModel *dungeon_model;
    MyItems      *my_items;
    NSMutableArray *menuItemList;
}

+(CCScene*)scene:(DungeonModel*)dungeon_model;

@end

