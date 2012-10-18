//
//  HelloWorldLayer.h
//  Dri
//
//  Created by  on 12/08/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "cocos2d.h"
#import "LargeNotifierView.h"
#import "DungeonModel.h"
#import "StatusBarView.h"

@class DungeonView;

@interface DungeonScene : CCLayerColor<DungenModelObserver>
{
    NSMutableArray *events;

    DungeonModel *dungeon_model;
    DungeonView  *dungeon_view;
    
    CCLayerColor *fade_layer;
    
    LargeNotifierView *large_notify;
    StatusBarView     *statusbar;
}

+ (CCScene *)sceneWithDungeonModel:(DungeonModel*)dungeon_model;
- (id) initWithDungeonModel:(DungeonModel*)dungeon_model;

@end
