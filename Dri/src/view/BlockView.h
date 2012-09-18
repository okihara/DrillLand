//
//  BlockView.h
//  Dri
//
//  Created by  on 12/08/18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DungeonModel.h"
#import "DLEvent.h"


@class BlockModel, DungeonView;
@class BlockView;

@protocol BlockPresentation <NSObject>

//-(void)handle_event:(DungeonView *)ctx event:(DLEvent*)e view:(BlockView *)view_;
-(CCAction*)handle_event:(DungeonView *)ctx event:(DLEvent*)e view:(BlockView *)view_;

@end

enum DL_PHASE {
    DL_ETC = 0,
    DL_MOVE,
    DL_ATTACK,
    DL_DEFENSE,
    DL_DESTROY
};

@interface BlockView : CCSprite
{
    BOOL is_alive;
    BOOL is_change;
    
    NSMutableArray* events;
    NSMutableArray* presentation_list;
}

@property (readwrite, assign) BOOL is_alive;
@property (readwrite, assign) BOOL is_change;

- (void)setup;
- (void)add_presentation:(NSObject<BlockPresentation>*)presentation;

// event
- (CCAction*)handle_event:(DungeonView*)ctx event:(DLEvent*)e;

// helper
- (void)play_anime:(NSString*)name;
- (CCFiniteTimeAction*)play_anime_one:(NSString*)name;

- (CCAction*)get_action_update_player_pos:(DungeonModel *)_dungeon view:(DungeonView*)view;

@end
