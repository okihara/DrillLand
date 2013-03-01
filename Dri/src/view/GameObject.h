//
//  GameObject.h
//  
//
//  Created by  on 13/03/02.
//  Copyright (c) 2013 Hiromitsu. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"

@interface GameObject : CCSprite
-(CCFiniteTimeAction*)play:(NSString *)animeName;
@end
