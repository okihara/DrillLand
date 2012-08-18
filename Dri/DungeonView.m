//
//  DungeonView.m
//  Dri
//
//  Created by  on 12/08/17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "DungeonView.h"

@implementation DungeonView

@synthesize delegate;

-(id) init
{
	if( (self=[super init]) ) {
        
        // ---
        disp_w = 5;
        disp_h = 10;
        offset_y = 0;
        
        CCSprite *block = [CCSprite spriteWithFile:@"Icon.png"];
        [self addChild:block];
	}
	return self;
}

- (void)update_view_line:(int)j _model:(DungeonModel *)_dungeon
{
    for (int i = 0; i < disp_w; i++) {
        
        int x = i;
        int y = offset_y + j;
        
        BlockBase* b = [_dungeon get_x:x y:y]; 
        if (b.type == 0) continue;
        
        // ブロック
        CCSprite *block = [CCSprite spriteWithFile:@"Icon.png"];
        [self addChild:block];
        [block setPosition:ccp(30 + i * 60, 480 - (30 + j * 60))];
        
        // 数字
        if (b.can_tap == YES) {
            CCLabelTTF *label = [CCLabelTTF labelWithString:@"1" fontName:@"AppleGothic" fontSize:20];
            label.position =  ccp(30 + i * 60, 480 - (30 + j * 60));
            [self addChild: label];
        }
    }
}

- (void)update_view:(DungeonModel *)_dungeon
{
    for (int j = 0; j < disp_h; j++) {
        [self update_view_line:j _model:_dungeon];
    }
}

- (void) notify:(DungeonModel*)_dungeon
{
    [self removeAllChildrenWithCleanup:YES];    
    [self update_view:_dungeon];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [delegate ccTouchesEnded:touches withEvent:event];
}

@end
