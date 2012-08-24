//
//  DungeonView.h
//  Dri
//
//  Created by  on 12/08/17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DungeonModel.h"

@class XDMap;
@class PlayerView;

@interface DungeonView : CCLayer<DungenModelObserver>
{
    id  delegate;
    int offset_y;
    int disp_w;
    int disp_h;
    
    TileMap2* view_map;
    
    CCLayer* effect_layer;
    CCLayer* block_layer;
    
    PlayerView* player;
}

@property (nonatomic, retain) id delegate;

@end
