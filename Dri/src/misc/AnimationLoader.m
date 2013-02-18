//
//  AnimationLoader.m
//  Dri
//
//  Created by  on 12/09/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnimationLoader.h"
#import "cocos2d.h"
#import "SBJson.h"

@implementation AnimationLoader

-(CCSpriteFrame*)load_frame:(NSDictionary*)frame
{
    //int duration = [frame objectForKey:@"duration"];
    NSArray* layer_list = [frame objectForKey:@"layer"];
    NSDictionary* l1 = [layer_list objectAtIndex:0];
    CCSpriteFrameCache* frame_cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSString* name = [l1 objectForKey:@"uv"];
    return [frame_cache spriteFrameByName:name];
}

-(CCAnimation*)load_action:(NSDictionary*)jsonItem delay:(float)delay
{
    NSArray* frame_list = [jsonItem objectForKey:@"frame"];
    NSUInteger count = [frame_list count];
    NSMutableArray* sprite_frame_list = [NSMutableArray arrayWithCapacity:count];
    for (NSDictionary* frame in frame_list) {
        CCSpriteFrame* sprite_frame = [self load_frame:frame];
        [sprite_frame_list addObject:sprite_frame];
    }
    CCAnimation *anim = [CCAnimation animationWithSpriteFrames:sprite_frame_list delay:delay];
    BOOL loop = [[jsonItem valueForKey:@"loop"] boolValue];
    anim.loops = loop ? NSUIntegerMax : 1;
    return anim;
}

-(void)load_animation:(NSString*)filename
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
    NSString *jsonData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    id jsonItem = [jsonData JSONValue];
    NSDictionary *action = [(NSDictionary*)jsonItem objectForKey:@"action"];
    
    CCAnimationCache* anim_cache = [CCAnimationCache sharedAnimationCache];
    
    for (NSString *key in [action keyEnumerator]) {
        // TODO: ！恐怖とりあえずすぎる！
        float delay;
        if ([key isEqualToString:@"13000atk"]) {
            delay = 0.033f;
        } else {
            delay = 0.072f;
        }
        CCAnimation *anim = [self load_action:[action objectForKey:key] delay:delay];
        
        [anim_cache addAnimation:anim name:key];
    }
}

@end
