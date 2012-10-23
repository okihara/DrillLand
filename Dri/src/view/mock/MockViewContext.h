//
//  MockViewContext.h
//  Dri
//
//  Created by  on 12/10/23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DLView.h"
#import "EffectLauncher.h"

@interface MockViewContext : CCLayer<ViewContextProtocol>
{
    CCLayerColor *fade_layer;
    CCLayer *effect_layer;
    CCLayer *block_layer;
    
    EffectLauncher *effect_launcher;
}

@property (nonatomic, readonly, retain) CCLayerColor *fade_layer;
@property (nonatomic, readonly, retain) CCLayer *effect_layer;
@property (nonatomic, readonly, retain) CCLayer *block_layer;

@end
