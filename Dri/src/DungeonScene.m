//
//  HelloWorldLayer.m
//  Dri
//
//  Created by  on 12/08/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "DungeonScene.h"
#import "DungeonModel.h"
#import "DungeonView.h"
#import "PlayerModel.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation DungeonScene

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	DungeonScene *layer = [DungeonScene node];
	[scene addChild: layer];
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init]) ) {
 
        offset_y = 0;
        
        // setup dungeon view
        dungeon_view = [DungeonView node];
        [dungeon_view setDelegate:self];
        [self addChild:dungeon_view];
        
        // setup dungeon model
        dungeon = [[DungeonModel alloc] init:NULL];
        //[dungeon _setup];
        [dungeon add_observer:dungeon_view];
        [dungeon load_from_file:@"floor001.json"];
        
		// enable touch
        self.isTouchEnabled = YES;
	}
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    // Choose one of the touches to work with
    UITouch *touch =[touches anyObject];
    CGPoint location =[touch locationInView:[touch view]];
    location =[[CCDirector sharedDirector] convertToGL:location];
    int x = (int)(location.x / 60);
    int y = (int)((480 - location.y + offset_y) / 60);
    [self->dungeon hit:ccp(x, y)];

    // ここでタップ禁止にしてたいね
    // 一番現在移動できるポイントが中央にくるまでスクロール？
    // プレイヤーの位置が４段目ぐらいにくるよまでスクロール
    // 一度いった時は引き返せない
    int by = (int)(offset_y / 60);
    int diff = self->dungeon.player.pos.y - by;
    NSLog(@" scroll y:%d, player.y:%d diff %d", y, self->dungeon.player.pos.y, diff);
    if (diff - 2 > 0) {
        offset_y += 60 * (diff - 2);
    }
    // ここらへんはフロアの情報によって決まる
    // current_floor_max_rows * block_height + margin
    int max_scroll = (HEIGHT - 9) * 60 + 30;
    if (offset_y > max_scroll) offset_y = max_scroll;

    CCMoveTo *act_move = [CCMoveTo actionWithDuration: 0.4 position:ccp(0, offset_y)];
    CCEaseInOut *ease = [CCEaseInOut actionWithAction:act_move rate:2];
    [dungeon_view runAction:ease];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [super dealloc];
}

@end
