//
//  DamageNumView.h
//  Dri
//
//  Created by  on 12/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface DamageNumView : CCNode {
    CCLabelBMFont *content_text;
}

+(void)spawn:(int)num target:(CCNode*)parent position:(CGPoint)pos;
-(id) initWithString:(NSString*)str;

@end
