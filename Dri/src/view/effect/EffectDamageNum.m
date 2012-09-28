//
//  EffectDmageNum.m
//  Dri
//
//  Created by  on 12/09/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EffectDamageNum.h"
#import "cocos2d.h"
#import "DamageNumView.h"

@implementation EffectDamageNum

+ (CCFiniteTimeAction*)launch:(CCNode*)target params:(NSDictionary*)params effect_layer:(CCLayer*)effect_layer
{    
    NSNumber *num = (NSNumber*)[params objectForKey:@"damage"];
    int damage = num ? [num intValue] : 0;
    [DamageNumView spawn:damage target:effect_layer position:target.position];
    return nil;
}

+ (BOOL)register_me:(NSObject<EffectLauncherProtocol>*)launcher {
    return [launcher register_effect:[EffectDamageNum class] name:@"damage"];
}

@end
