//
//  EffectColorFlash.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "EffectColorFlash.h"
#import "cocos2d.h"

@implementation EffectColorFlash

+ (CCFiniteTimeAction*)launch:(CCNode*)target params:(NSDictionary*)params effect_layer:(CCLayer*)effect_layer
{
    // implement
    return nil;
}

+ (BOOL)register_me:(NSObject<EffectLauncherProtocol>*)launcher {
    return [launcher register_effect:[EffectColorFlash class] name:@"COLORFLASH"];
}

@end

