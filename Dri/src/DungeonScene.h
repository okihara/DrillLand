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

// HelloWorldLayer
@interface DungeonScene : CCLayerColor
{
    CCLayerColor* fade_layer;
    
    DungeonView *dungeon_view;
    DungeonModel *dungeon_model;
    
    LargeNotifierView* large_notify;
    int offset_y;
    int curring_top;
    int curring_bottom;
}

+(CCScene *) scene;
-(void)update_curring_range;

// TODO: スクロール関係は別クラスに
-(float)get_offset_y_by_player_pos;
-(void)scroll_to;

@end
