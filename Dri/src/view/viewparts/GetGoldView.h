//
//  GetGoldView.h
//  Dri
//
//  Created by  on 12/10/19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GetGoldView : CCSprite
{
    CCSprite *icon;
    CCLabelBMFont *content_text;
}

+(void)spawn:(CCNode*)parent position:(CGPoint)pos num_exp:(UInt32)num_gold;

@end
