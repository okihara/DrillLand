//
//  HelloWorldLayer.h
//  Dri
//
//  Created by  on 12/08/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "LargeNotifierView.h"

@class DungeonModel;
@class DungeonView;

@interface DungeonScene : CCLayerColor
{
    int offset_y;

    DungeonModel *dungeon_model;
    
    CCLayerColor      *fade_layer;
    DungeonView       *dungeon_view;
    LargeNotifierView *large_notify;
}

+(CCScene *) scene;
-(void)update_curring_range;

// TODO: スクロール関係は別クラスに
-(float)get_offset_y_by_player_pos;
-(void)scroll_to;

@end
