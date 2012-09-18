//
//  HelloWorldLayer.h
//  Dri
//
//  Created by  on 12/08/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

#import "cocos2d.h"
#import "LargeNotifierView.h"
#import "DungeonModel.h"
#import "StatusBarView.h"


@class DungeonView;

@interface DungeonScene : CCLayerColor<DungenModelObserver>
{
    int offset_y;

    DungeonModel *dungeon_model;
    
    CCLayerColor      *fade_layer;
    LargeNotifierView *large_notify;
    StatusBarView     *statusbar;
    
    DungeonView       *dungeon_view;
    int latest_remove_y;

    NSMutableArray *events;
}

+ (CCScene *)scene;

// --
- (void)run_sequence;
- (CCAction*)animate;

// --
- (void)update_curring_range;

// TODO: スクロール関係は別クラスに
- (void)update_offset_y:(int)target_y;
- (void)scroll_to;

@end
