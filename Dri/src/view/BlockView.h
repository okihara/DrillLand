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

-(void)handle_event:(DungeonView *)ctx event:(DLEvent*)e view:(BlockView *)view_;

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
    NSMutableArray* events;
    NSMutableArray* events_move;
    NSMutableArray* events_attack;
    NSMutableArray* events_defense;
    NSMutableArray* events_destroy;    
    
    NSMutableArray* presentation_list;
    BOOL is_alive;
}

@property (readwrite, assign) BOOL is_alive;

+(BlockView *) create:(BlockModel*)b ctx:(DungeonModel*)ctx;
- (BOOL)handle_event:(DungeonView*)ctx event:(DLEvent*)e;
- (void)update_presentation:(DungeonView*)ctx model:(BlockModel*)b phase:(enum DL_PHASE)phase;
- (void)play_anime:(NSString*)name;
- (CCAction*)get_action_update_player_pos:(DungeonModel *)_dungeon view:(DungeonView*)view;

@end
