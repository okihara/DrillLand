//
//  BasicNotifierView.h
//  Dri
//
//  Created by  on 12/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BasicNotifierView : CCNode {
    CCLayerColor* base_layer;
    CCSprite*   base_view;
    CCSprite*   content_view;
    CCLabelTTF* content_text;
}

+(void)notify:(NSString*)message target:(CCNode*)node;

-(id) initWithMessage:(NSString*)message;

@end
