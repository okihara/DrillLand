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

@implementation DungeonPreloadScene

+(CCScene*)scene {
	CCScene *scene = [CCScene node];
	DungeonPreloadScene *layer = [DungeonPreloadScene node];
	[scene addChild: layer];
	return scene;
}

-(CCSpriteFrame*)load_frame:(NSDictionary*)frame
{
    //int duration = [frame objectForKey:@"duration"];
    NSArray* layer_list = [frame objectForKey:@"layer"];
    NSDictionary* l1 = [layer_list objectAtIndex:0];
    CCSpriteFrameCache* frame_cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSString* name = [l1 objectForKey:@"uv"];
    return [frame_cache spriteFrameByName:name];
}

-(CCAnimation*)load_action:(NSDictionary*)jsonItem
{
    NSArray* frame_list = [jsonItem objectForKey:@"frame"];
    NSUInteger count = [frame_list count];
    NSMutableArray* sprite_frame_list = [NSMutableArray arrayWithCapacity:count];
    for (NSDictionary* frame in frame_list) {
        CCSpriteFrame* sprite_frame = [self load_frame:frame];
        [sprite_frame_list addObject:sprite_frame];
    }
    return [CCAnimation animationWithSpriteFrames:sprite_frame_list delay:0.08f];
}

-(void)load_animation:(NSString*)filename
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
    NSString *jsonData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    id jsonItem = [jsonData JSONValue];
    NSDictionary *action = [(NSDictionary*)jsonItem objectForKey:@"action"];
    
    CCAnimationCache* anim_cache = [CCAnimationCache sharedAnimationCache];
    
    for (NSString *key in [action keyEnumerator]) {
        CCAnimation* anim = [self load_action:[action objectForKey:key]];
        [anim_cache addAnimation:anim name:key];
    }
}

//----------------------------------------------------------------------------------------

-(void)load_sprite:(NSString*)filename
{
    CCSpriteFrameCache* frame_cache = [CCSpriteFrameCache sharedSpriteFrameCache];

    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
    NSString *jsonData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    id jsonItem = [jsonData JSONValue];
    NSDictionary *frames = [(NSDictionary*)jsonItem objectForKey:@"frames"];
    NSDictionary *meta = [(NSDictionary*)jsonItem objectForKey:@"meta"];
    NSString* sheet_name = [meta objectForKey:@"image"];

    for (NSString* key in [frames keyEnumerator]) {
        NSDictionary* fr = [[frames objectForKey:key] objectForKey:@"frame"];
        float x = [(NSNumber*)[fr objectForKey:@"x"] floatValue];
        float y = [(NSNumber*)[fr objectForKey:@"y"] floatValue];
        float w = [(NSNumber*)[fr objectForKey:@"w"] floatValue];
        float h = [(NSNumber*)[fr objectForKey:@"h"] floatValue];
        CGRect rect = CGRectMake(x, y, w, h);
        
        [frame_cache addSpriteFrame:[CCSpriteFrame frameWithTextureFilename:sheet_name rect:rect] name:key];
    }
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init]) ) {
        
        [self load_sprite:@"link_f.json"];
        [self load_animation:@"link.json"];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"loading" fontName:DL_FONT fontSize:20];
        label.position =  ccp(160, 240);
        [self addChild:label];
	}
	return self;
}

-(void)onEnter
{
    [super onEnter];
    
    [[CCDirector sharedDirector] replaceScene:[DungeonScene scene]];
}

@end
