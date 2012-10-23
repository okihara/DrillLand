//
//  DLScene.h
//  Dri
//
//  Created by  on 12/10/23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol ViewContextProtocol <NSObject>

- (void)launch_particle:(NSString*)name position:(CGPoint)pos;
-(CCFiniteTimeAction*)launch_effect:(NSString *)name target:(CCNode*)target params:(NSDictionary*)params;

@end

@interface DLView : NSObject

@end
