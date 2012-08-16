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
        
        //
        disp_w = 5;
        disp_h = 6;
        offset_y = 0;
        
		// enable touch
        self.isTouchEnabled = YES;


        // setup model
        dungeon = [[DungeonModel alloc] init:NULL];
        [dungeon add_observer:self];

        [dungeon set_state:ccp(1,0) type:1];
	}
	return self;
}

- (void)update_view:(DungeonModel *)_dungeon
{
    for (int j = 0; j < disp_h; j++) {
        for (int i = 0; i < disp_w; i++) {
            int x = i;
            int y = offset_y + j;
            if ([_dungeon get_value:x y:y] == 0 ) continue;
            
            // ブロック
            CCSprite *block = [CCSprite spriteWithFile:@"Icon.png"];
            [self addChild:block];
            [block setPosition:ccp(30 + i * 60, 480 - (30 + j * 60))];
            
            // 数字
            if ([_dungeon get_can_value:x y:y] == 1) {
                CCLabelTTF *label = [CCLabelTTF labelWithString:@"1" fontName:@"AppleGothic" fontSize:16];
                label.position =  ccp(30 + i * 60, 480 - (30 + j * 60));
                [self addChild: label];
            }
        }
    }
}

- (void) notify:(DungeonModel*)_dungeon
{
    [self removeAllChildrenWithCleanup:YES];    
    [self update_view:_dungeon];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    // Choose one of the touches to work with
    UITouch *touch =[touches anyObject];
    CGPoint location =[touch locationInView:[touch view]];
    location =[[CCDirector sharedDirector] convertToGL:location];
    
    int x = (int)(location.x / 60);
    int y = (int)((480 - location.y) / 60) + offset_y;

    offset_y++;
    [self->dungeon erase:ccp(x, y)];
    
    NSLog(@"touched %d, %d offset_y %d", x, y, offset_y);
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [super dealloc];
}

@end
