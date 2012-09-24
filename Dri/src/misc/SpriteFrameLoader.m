//
//  SpriteFrameLoader.m
//  Dri
//
//  Created by  on 12/09/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpriteFrameLoader.h"
#import "cocos2d.h"
#import "SBJson.h"

@implementation SpriteFrameLoader

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
        
        CCSpriteFrame * sprite_frame = [CCSpriteFrame frameWithTextureFilename:sheet_name rect:rect];
        [[sprite_frame texture] setAliasTexParameters];
        [frame_cache addSpriteFrame:sprite_frame name:key];
    }
}

@end
