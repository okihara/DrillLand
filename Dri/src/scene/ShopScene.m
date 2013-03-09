//
//  ShopScene.m
//  Dri
//
//  Created by  on 13/03/09.
//  Copyright 2013 Hiromitsu. All rights reserved.
//

#import "ShopScene.h"
#import "CCBReader.h"

@implementation ShopScene

- (void)pressedButton:(id)sender
{
    [[CCDirector sharedDirector] popScene];
}

- (void)pressedButtonBuy:(id)sender
{
    // [[CCDirector sharedDirector] popScene];
}

@end
