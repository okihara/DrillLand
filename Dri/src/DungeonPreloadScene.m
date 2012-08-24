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
	}
	return self;
}

-(void)onEnter
{
    NSLog(@"preload on enter");
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"anim01.json"];
    NSString *jsonData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                          
    id jsonItem = [jsonData JSONValue];  

    //-------------------------------------------------
    CCDirector* director = [CCDirector sharedDirector];
    [director replaceScene:[DungeonScene scene]];
}

@end
