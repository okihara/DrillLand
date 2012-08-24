//
//  MyCocos2DClass.m
//  Dri
//
//  Created by  on 12/08/25.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerView.h"


@implementation PlayerView

-(id) init
{
	if( (self=[super init]) ) {
        [self initWithSpriteFrameName:@"link_f8.png"];
        self.position = ccp(160, 240);
        self.scale = 2.0;
        [self action:@"walk"];
	}
	return self;
}

-(void)action:(NSString*)name
{
    CCAnimation *anim = [[CCAnimationCache sharedAnimationCache] animationByName:name];
    CCAction* act = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:anim]];
    [self runAction:act];   
}

@end
