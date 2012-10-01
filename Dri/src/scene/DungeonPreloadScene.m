//
//  DungeonPreloadScene.m
//  Dri
//
//  Created by  on 12/08/24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DungeonPreloadScene.h"
#import "SBJson.h"
#import "DungeonScene.h"
#import "DL.h"
#import "SpriteFrameLoader.h"
#import "AnimationLoader.h"
#import "HomeScene.h"

@implementation DungeonPreloadScene

+(CCScene*)scene {
	CCScene *scene = [CCScene node];
	DungeonPreloadScene *layer = [DungeonPreloadScene node];
	[scene addChild: layer];
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init]) ) {

        CCLabelTTF *label = [CCLabelTTF labelWithString:@"loading" fontName:DL_FONT_NAME fontSize:20];
        label.position =  ccp(160, 440);
        [self addChild:label];

        // ---
        [CCMenuItemFont setFontName:DL_FONT_NAME];

        SpriteFrameLoader *frame_loader = [[[SpriteFrameLoader alloc] init] autorelease];
        AnimationLoader *animation_loader = [[[AnimationLoader alloc] init] autorelease];
        
        [frame_loader load_sprite:@"link2.json"];
        [animation_loader load_animation:@"linkatk.json"];

        
        [frame_loader load_sprite:@"link_f.json"];
        [animation_loader load_animation:@"link.json"];
        
        [frame_loader load_sprite:@"mon.json"];
        [animation_loader load_animation:@"mon001.json"];
        
        // -- texture
        [[CCTextureCache sharedTextureCache] addImage:@"block01.png"];
    }
	return self;
}

-(void)onEnter
{
    [super onEnter];
    
    [[CCDirector sharedDirector] replaceScene:[HomeScene scene]];
}

@end
