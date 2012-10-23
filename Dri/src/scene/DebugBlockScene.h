//
//  DebugBlockScene.h
//  Dri
//
//  Created by  on 12/10/23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MockViewContext.h"

@class BlockView;
@class BlockModel;

@interface DebugBlockScene : CCLayer
{
    int current_index;
    BlockModel *current_block_model;
    BlockView *current_block_view;
    
    MockViewContext *view_context;
}

+(CCScene *) scene;

@end
