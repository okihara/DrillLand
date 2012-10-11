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
    CCLayerColor *base_layer;
    CCSprite     *base_view;
    CCSprite     *content_view;
    CCLabelBMFont *content_text;
    ccTime duration_sec;
}

+(void)setup:(CCNode*)target_node_;

+(void)notify:(NSString*)message target:(CCNode*)node;
+(void)notify:(NSString*)message target:(CCNode*)node duration:(ccTime)sec;

-(id) initWithMessage:(NSString*)message duration:(ccTime)sec;


@end
