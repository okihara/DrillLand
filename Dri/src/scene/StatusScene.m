//
//  StatusScene.m
//  Dri
//
//  Created by  on 13/03/09.
//  Copyright 2013 Hiromitsu. All rights reserved.
//

#import "StatusScene.h"


@implementation StatusScene

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [[CCDirector sharedDirector] popScene];
}

@end
