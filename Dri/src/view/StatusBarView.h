//
//  StatusBarView.h
//  Dri
//
//  Created by  on 12/09/16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface StatusBarView : CCNode {
    CCLayerColor *bg;
    CCLabelTTF *hp;
    CCLabelTTF *exp;
    CCLabelBMFont *name;
    CCLabelTTF *level;
}

@end
