//
//  HomeScene.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "HomeScene.h"
#import "DungeonScene.h"

@implementation HomeScene

- (id)init
{
    if( (self=[super init]) ) {
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"HOME" fontName:@"AppleGothic" fontSize:20];
        label.position =  ccp(160, 240);
        [self addChild:label];

        // enable touch
        self.isTouchEnabled = YES;

        // IMPLEMENT:
    }
    return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    // IMPLEMENT:
    // EXAMPLE:
    // [[CCDirector sharedDirector] replaceScene:[DungeonScene scene]];
}

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [HomeScene node];
    [scene addChild:layer];
    return scene;
}

@end

