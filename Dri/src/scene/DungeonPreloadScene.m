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
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"DUNGEONPRELOAD" fontName:DL_FONT_NAME fontSize:20];
        label.position =  ccp(160, 440);
        [self addChild:label];

        // enable touch
        self.isTouchEnabled = YES;

        // IMPLEMENT:
    }
    return self;
}

- (void)start_load:(uint)dungeon_id
{
    // setup dungeon model
    self->dungeon_model = [[DungeonModel alloc] init];

    // setup quest
    Quest *quest = [QuestFactory make_test];
    [self->dungeon_model add_observer:quest];
    
    // load dungeon data
    [self->dungeon_model load_from_file:[NSString stringWithFormat:@"floor%03d.json", dungeon_id]];
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
    
    CCSequence *seq = [CCSequence actions:[CCDelayTime actionWithDuration:0.01f], cb, nil];
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
