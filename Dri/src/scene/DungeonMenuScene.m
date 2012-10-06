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
        CCMenuItemFont *item_home = [CCMenuItemFont itemWithString:@"HOME" target:self selector:@selector(didPressButtonHome:)];
        CCMenuItemFont *item_reload = [CCMenuItemFont itemWithString:@"RELOAD" target:self selector:@selector(didPressButton_reload:)];
        
        CCMenu *menu = [CCMenu menuWithItems:
                        item_home,
                        item_reload,
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

- (void)didPressButtonHome:(CCMenuItem *)sender
{
    CCScene *next_scene = [HomeScene scene];
    CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:0.5f scene:next_scene withColor:ccc3(0, 0, 0)];
    [[CCDirector sharedDirector] replaceScene:trans];
}

- (void)didPressButton_reload:(CCMenuItem *)sender
{
    CCScene *scene = [DungeonPreloadScene sceneWithDungeonId:0];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
