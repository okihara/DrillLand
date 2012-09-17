//
//  FontFactory.h
//  Dri
//
//  Created by  on 12/09/17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FontFactory : NSObject

+(CCLabelBMFont*)makeLabel:(NSString*)string;
+(CCLabelBMFont*)makeLabel:(NSString*)string color:(ccColor3B)color;

@end
