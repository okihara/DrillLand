//
//  DungeonPreloadScene.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "DungeonPreloadScene.h"
#import "DungeonScene.h"
#import "QuestFactory.h"

@implementation DungeonPreloadScene

- (id)init
{
    if( (self=[super init]) ) {
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"NOW LOADING..." fontName:DL_FONT_NAME fontSize:20];
        label.position =  ccp(8, 440);
        label.anchorPoint = ccp(0, 0);
        [self addChild:label];

        CCLabelTTF *tips = [CCLabelTTF labelWithString:@"<TIPS>" fontName:DL_FONT_NAME fontSize:15];
        tips.position =  ccp(160, 240);
        [self addChild:tips];
        
        CCLabelTTF *tips_body = [CCLabelTTF labelWithString:@"I have a pen." fontName:DL_FONT_NAME fontSize:15];
        tips_body.position =  ccp(160, 210);
        [self addChild:tips_body];
    }
    return self;
}

- (void)start_load:(uint)dungeon_id
{
    // setup dungeon model
    self->dungeon_model = [[DungeonModel alloc] init];

    // setup quest
    switch (dungeon_id) {
            
        case 0:
        {
            Quest *quest = [QuestFactory make_test_0];
            [self->dungeon_model addObserver:quest];
        }
            break;
            
        case 1:
        {
            Quest *quest = [QuestFactory make_test_1];
            [self->dungeon_model addObserver:quest];
        }
            break;
            
        case 2:
        {
            Quest *quest = [QuestFactory make_test_2];
            [self->dungeon_model addObserver:quest];
        }
            break;
            
        default:
            break;
    }

    
    // load dungeon data
    if (dungeon_id==3) {
        [self->dungeon_model loadRandom:0];
    } else {
        [self->dungeon_model loadFile:[NSString stringWithFormat:@"floor%03d.json", dungeon_id]];
    }
}

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];

    DungeonPreloadScene *this = self;
    CCCallBlock *cb = [CCCallBlock actionWithBlock:^(){
        CCScene *next_scene = [DungeonScene sceneWithDungeonModel:this->dungeon_model];
        CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:0.5f scene:next_scene withColor:ccc3(0, 0, 0)];
        [[CCDirector sharedDirector] replaceScene:trans];        
    }];
    
    CCSequence *seq = [CCSequence actions:[CCDelayTime actionWithDuration:0.5f], cb, nil];
    
    [self runAction:seq];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    // IMPLEMENT:
    // EXAMPLE:
    //CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:1.0 scene:[DungeonScene scene] withColor:ccc3(0, 0, 0)];
    //[[CCDirector sharedDirector] replaceScene:trans];
}

+ (CCScene *)sceneWithDungeonId:(uint)dungeon_id
{
    CCScene *scene = [CCScene node];
    DungeonPreloadScene *layer = [DungeonPreloadScene node];
    [scene addChild:layer];
    
    [layer start_load:dungeon_id];
    
    return scene;
}

@end
