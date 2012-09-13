//
//  DungeonView.h
//  Dri
//
//  Created by  on 12/08/17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EffectLauncher.h"
#import "DungeonModel.h"
#import "DLEvent.h"

@class XDMap;
@class BlockView;

@interface DungeonView : CCLayer<DungenModelObserver>
{
    id  delegate;
    int offset_y;
    int disp_w;
    int disp_h;
    
    ObjectXDMap* view_map;
    
    CCLayer* effect_layer;
    CCLayer* block_layer;
    
    EffectLauncher* effect_launcher;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) int curring_top;
@property (nonatomic, assign) int curring_bottom;
@property (nonatomic, readwrite, retain) BlockView* player;

- (void)add_block:(BlockView*)block;

- (void)update_view_line:(int)y _model:(DungeonModel *)dungeon_;
- (void)update_view:(DungeonModel *)_dungeon;
- (void)update_presentation:(DungeonModel *)dungeon_;

- (void)launch_particle:(NSString*)name position:(CGPoint)pos;
- (void)launch_effect:(NSString *)name position:(CGPoint)pos;

- (CCAction*)get_action_update_player_pos:(DungeonModel *)_dungeon;

- (void)remove_block_view:(DLPoint)pos;
- (void)remove_block_view_line:(int)y _model:(DungeonModel *)_dungeon;


- (CGPoint)model_to_local:(DLPoint)pos;

@end
