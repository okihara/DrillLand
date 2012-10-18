//
//  EffectLauncher.h
//  Dri
//
//  Created by  on 12/08/30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Effect.h"


@interface EffectLauncher : NSObject<EffectLauncherProtocol>
{
    NSMutableDictionary *effect_map;
}

@property (nonatomic, readwrite, retain) CCLayer *target_layer;

- (BOOL)register_effect:(Class)effect_class name:(NSString*)name;
- (CCFiniteTimeAction*)launch_effect:(NSString *)name target:(CCNode*)target params:(NSDictionary*)params;

- (void)launch_particle:(NSString*)name position:(CGPoint)pos;

@end
