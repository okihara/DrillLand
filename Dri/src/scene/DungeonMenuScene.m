//
//  DungeonResultScene.m
//  Dri
//
//  Created by  on 12/08/29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DungeonMenuScene.h"
#import "DungeonScene.h"
#import "HomeScene.h"
#import "DungeonPreloadScene.h"
#import "DebugBlockScene.h"
#import "DungeonOverScene.h"

@implementation DungeonMenuScene

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	CCLayer *layer = [DungeonMenuScene node];
	[scene addChild:layer];
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init]) ) {
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"ITEM MENU" fontName:DL_FONT_NAME fontSize:20];
        label.position = ccp(160, 440);
        [self addChild:label];
        
		// enable touch
        self.isTouchEnabled = YES;
        
        // IMPLEMENT:
        CCMenuItemFont *item_home = [CCMenuItemFont itemWithString:@"EXIT" target:self selector:@selector(didPressButton_home:)];
        CCMenuItemFont *item_reload = [CCMenuItemFont itemWithString:@"RELOAD" target:self selector:@selector(didPressButton_reload:)];
        CCMenuItemFont *item_block = [CCMenuItemFont itemWithString:@"BLOCK" target:self selector:@selector(didPressButton_block:)];
        
        CCMenu *menu = [CCMenu menuWithItems:
                        item_home,
                        item_reload,
                        item_block,
                        nil];
        menu.position = ccp(160, 220);
        [menu alignItemsVertically];
        [self addChild:menu];
	}
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [[CCDirector sharedDirector] popScene];
}

- (void)didPressButton_home:(CCMenuItem *)sender
{
    CCScene *next_scene = [DungeonOverScene scene];
    CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:0.5f scene:next_scene withColor:ccc3(0, 0, 0)];
    [[CCDirector sharedDirector] replaceScene:trans];
}

- (void)didPressButton_reload:(CCMenuItem *)sender
{
    CCScene *scene = [DungeonPreloadScene sceneWithDungeonId:0];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)didPressButton_block:(CCMenuItem *)sender
{
    CCScene *next_scene = [DebugBlockScene scene];
    [[CCDirector sharedDirector] replaceScene:next_scene];    
}


@end
