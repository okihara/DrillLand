//
//  HelloWorldLayer.m
//  Dri
//
//  Created by  on 12/08/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
		// enable touch
        self.isTouchEnabled = YES;

		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		// add the label as a child to this Layer
		[self addChild: label];
        
        // setup model
        dungeon = [[DungeonModel alloc] init:NULL];
        [dungeon add_observer:self];

        [dungeon set_state:ccp(0,0) type:0];
	}
	return self;
}

- (void) updateView:(TileMap*)map
{
    [self removeAllChildrenWithCleanup:YES];
    
    // ブロック
    for (int j = 0; j < 6; j++) {
        for (int i = 0; i < 5; i++) {
            if ([map get_value:i y:j] == 0 ) continue;
            CCSprite *block = [CCSprite spriteWithFile:@"Icon.png"];
            [self addChild:block];
            [block setPosition:ccp(30 + i * 60, 30 + j * 60)];
        }
    }
    
    // 数字
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    CGPoint pos = ccp(2,2);
    [self->dungeon set_state:pos type:0];
    NSLog(@"hoge");
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [super dealloc];
}

@end
