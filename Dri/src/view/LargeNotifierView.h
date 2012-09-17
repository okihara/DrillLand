//
//  LargeNotifierView.h
//  Dri
//
//  Created by  on 12/09/10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LargeNotifierView : CCNode {
    CCLayerColor  *base_layer;
    CCSprite      *base_view;
    CCSprite      *content_view;
    CCLabelBMFont *content_text;
}

@end
