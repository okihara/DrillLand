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
    CCNode<CCRGBAProtocol> *target_ = (CCNode<CCRGBAProtocol>*)target;

    // 2秒で指定した色を減色するアニメーションを定義
    NSValue *v = [params objectForKey:@"color"];
    ccColor3B color;
    if (v) {
        [v getValue:&color];
    } else {
        color = ccc3(255, 255, 255);
    }
    target_.color = color;
    target_.opacity = 0xFF;
    CCFiniteTimeAction *action2 = [CCFadeTo actionWithDuration:1.0f opacity:0];
    
    // 定義したアニメーションをスプライトへセット
    [target_ runAction:action2];
    
    return nil;
}

+ (BOOL)register_me:(NSObject<EffectLauncherProtocol>*)launcher {
    return [launcher register_effect:[EffectColorFlash class] name:@"COLORFLASH"];
}

@end

