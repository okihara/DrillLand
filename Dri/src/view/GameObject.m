//
//  GameObject.m
//  
//
//  Created by  on 13/03/02.
//  Copyright (c) 2013 Hiromitsu. All rights reserved.
//

#import "GameObject.h"

@interface GameObject()
-(CCFiniteTimeAction *)_play:(NSString *)name;
@end

@implementation GameObject

//------------------------------------------------------------------------------
// アニメーション

-(CCFiniteTimeAction*)play:(NSString *)animeName
{
    return [self _play:animeName];
}

-(CCFiniteTimeAction *)_play:(NSString *)name
{
    CCAnimation *anim = [[CCAnimationCache sharedAnimationCache] animationByName:name];
    if (!anim) {
        return nil;
    }
    
    CCAnimate *animate = [CCAnimate actionWithAnimation:anim];
    if (anim.loops == NSUIntegerMax) {
        return [CCCallFuncO actionWithTarget:self
                                    selector:@selector(runAction:) 
                                      object:animate];
    } else {
        return animate;
    }
}

@end
