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
#import "DungeonSceneEventQueue.h"


@class DungeonView;
@class SequenceBuilder;

@interface DungeonScene : CCLayerColor<DungenModelObserver>
{
    SequenceBuilder        *seqBuilder;
    DungeonSceneEventQueue *eventQueue;

    DungeonModel *dungeon_model;
    DungeonView  *dungeon_view;
    
    CCLayerColor      *fade_layer;
    LargeNotifierView *large_notify;
    StatusBarView     *statusbar;
    
    CCMenuItemFont *itemItem;
    CCMenuItemFont *itemMenu;
}

+(CCScene *)sceneWithDungeonModel:(DungeonModel*)dungeon_model;

@end
