//
//  EffectShake.m
//  Dri
//
//  Created by  on 12/09/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EffectShake.h"

@implementation EffectShake

+ (CCFiniteTimeAction*)launch:(CCNode*)target params:(NSDictionary*)params effect_layer:(CCLayer *)effect_layer
{    
    int amp = 6;
    int times = 4;
    
    CCFiniteTimeAction *r  = [CCMoveBy actionWithDuration:0.016 position:ccp(amp,0)];
    CCFiniteTimeAction *l  = [CCMoveBy actionWithDuration:0.033 position:ccp(-amp*2,0)];
    CCFiniteTimeAction *r2 = [CCMoveBy actionWithDuration:0.033 position:ccp(amp*2,0)];
    CCFiniteTimeAction *o  = [CCMoveBy actionWithDuration:0.016 position:ccp(-amp,0)];
    
    CCFiniteTimeAction *repeat = [CCRepeat actionWithAction:[CCSequence actions:l, r2, nil] times:times];
    CCFiniteTimeAction *shake = [CCSequence actions:r, repeat, o, nil];
    
    return [CCTargetedAction actionWithTarget:target action:shake];
}

+ (BOOL)register_me:(NSObject<EffectLauncherProtocol>*)launcher
{
    [launcher register_effect:[EffectShake class] name:@"shake"];
    return YES;
}

@end
