//
//  PlayerPresentation.h
//  Dri
//
//  Created by  on 12/09/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockView.h"

@interface PlayerPresentation : NSObject<BlockPresentation>

- (CCAction*)get_action_update_player_pos:(DungeonModel *)_dungeon view:(DungeonView*)view;

@end
