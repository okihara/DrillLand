//
//  StatusScene.h
//  Dri
//
//  Created by  on 13/03/09.
//  Copyright 2013 Hiromitsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface StatusScene : CCLayer
{
    CCLabelBMFont *label_atk;
    CCLabelBMFont *label_def;
    CCLabelBMFont *label_xp;
    CCLabelBMFont *label_gold;
    
    NSDictionary *ref_userdata;
}

@end
