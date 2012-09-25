//
//  EffectLauncher.h
//  Dri
//
//  Created by  on 12/08/30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"



@interface EffectLauncher : NSObject

@property (nonatomic, readwrite, retain) CCLayer* target_layer;

-(void)launch_particle:(NSString*)name position:(CGPoint)pos;
-(CCFiniteTimeAction*)launch_effect:(NSString *)name target:(CCNode*)target params:(NSDictionary*)params;

@end
