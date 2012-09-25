//
//  Effect.h
//  Dri
//
//  Created by  on 12/09/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol EffectProtocol;

// -------------
@protocol EffectLauncherProtocol <NSObject>

- (BOOL)register_effect:(NSObject<EffectProtocol>*)effect name:(NSString*)name;

@end


// -------------
@protocol EffectProtocol <NSObject>

- (CCFiniteTimeAction*)launch:(CCNode*)target params:(NSDictionary*)params effect_layer:(CCLayer*)effect_layer;
+ (BOOL)register_me:(NSObject<EffectLauncherProtocol>*)launcher;

@end
