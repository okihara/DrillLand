//
//  BlockView.h
//  Dri
//
//  Created by  on 12/08/18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class BlockBase;

@interface BlockView : CCSprite
{
    
}

+(BlockView *) create:(BlockBase *)b;

@end
