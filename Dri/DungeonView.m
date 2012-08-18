//
//  DungeonView.m
//  Dri
//
//  Created by  on 12/08/17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "DungeonView.h"
#import "TileMap.h"
#import "BlockBase.h"

@implementation DungeonView

@synthesize delegate;

-(void) make_particle:(BlockBase*)b
{
    CCSprite* block = [view_map get_x:b.x y:b.y];
    CGPoint pos = block.position;
    
    CCParticleSystem *fire = [[[CCParticleExplosion alloc] init] autorelease];
    [fire setTexture:[[CCTextureCache sharedTextureCache] addImage:@"block01.png"] ];
    fire.totalParticles = 40;
    fire.speed = 100;
    fire.gravity = ccp(0.0, -500.0);
    fire.position = pos;
    
    NSLog(@"pos %f %f %u %u", pos.x, pos.y, b.x, b.y);
    
    [self->effect_layer addChild:fire];
}

-(id) init
{
	if( (self=[super init]) ) {
        
        disp_w = 5;
        disp_h = 10;
        offset_y = 0;
        
        self->view_map = [[TileMap2 alloc] init];
        self->block_layer = [[CCLayer alloc]init];
        [self addChild:self->block_layer];
        self->effect_layer = [[CCLayer alloc]init];
        [self addChild:self->effect_layer];
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
        NSString *filename;
        switch (b.type) {
            case 1:
                filename = @"block00.png";
                break;
            case 2:
                filename = @"block01.png";
                break;
            case 3:
                filename = @"block02.png";
                break;
            case 4:
                filename = @"block03.png";
                break;
            default:
                break;
        }
        CCSprite *block = [CCSprite spriteWithFile:filename];
        [self->block_layer addChild:block];
        [block setPosition:ccp(30 + i * 60, 480 - (30 + j * 60))];
        
        // 数字
        if (b.can_tap == YES) {
            CCLabelTTF *label = [CCLabelTTF labelWithString:@"1" fontName:@"AppleGothic" fontSize:20];
            label.position =  ccp(30, 30);
            label.color = ccc3(0, 0, 0);
            [block addChild:label];
        }
        
        [view_map set_x:x y:y value:block];
    }
}

- (void)update_view:(DungeonModel *)_dungeon
{
    [view_map clear];
    for (int j = 0; j < disp_h; j++) {
        [self update_view_line:j _model:_dungeon];
    }
}

- (void) notify:(DungeonModel*)_dungeon
{
    [self->block_layer removeAllChildrenWithCleanup:YES];    
    [self update_view:_dungeon];
}

-(void) notify_particle:(BlockBase*)block
{
    [self make_particle:block];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [delegate ccTouchesEnded:touches withEvent:event];
}

@end
