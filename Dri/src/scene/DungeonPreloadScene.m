//
//  DungeonPreloadScene.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "DungeonPreloadScene.h"
#import "DungeonScene.h"

@implementation DungeonPreloadScene

- (id)init
{
    if( (self=[super init]) ) {
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"DUNGEONPRELOAD" fontName:DL_FONT_NAME fontSize:20];
        label.position =  ccp(160, 440);
        [self addChild:label];

        // enable touch
        self.isTouchEnabled = YES;

        // IMPLEMENT:
    }
    return self;
}

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
//
    CCCallBlock *cb = [CCCallBlock actionWithBlock:^(){
        CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:0.5f scene:[DungeonScene scene] withColor:ccc3(0, 0, 0)];
        [[CCDirector sharedDirector] replaceScene:trans];        
    }];
    
    CCSequence *seq = [CCSequence actions:[CCDelayTime actionWithDuration:0.01f], cb, nil];
    [self runAction:seq];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    // IMPLEMENT:
    // EXAMPLE:
    CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:1.0 scene:[DungeonScene scene] withColor:ccc3(0, 0, 0)];
    [[CCDirector sharedDirector] replaceScene:trans];
}

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [DungeonPreloadScene node];
    [scene addChild:layer];
    return scene;
}

@end

