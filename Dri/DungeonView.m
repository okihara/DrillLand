//
//  DungeonView.m
//  Dri
//
//  Created by  on 12/08/17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "DungeonView.h"
#import "XDMap.h"
#import "BlockModel.h"
#import "BlockView.h"

@implementation DungeonView

@synthesize delegate;

-(void) make_particle:(BlockModel*)b
{
    CCSprite* block = [view_map get_x:b.x y:b.y];
    CGPoint pos = block.position;
    
    CCParticleSystem *fire = [[[CCParticleExplosion alloc] init] autorelease];
    [fire setTexture:[[CCTextureCache sharedTextureCache] addImage:@"block01.png"] ];
    fire.totalParticles = 40;
    fire.speed = 200;
    fire.gravity = ccp(0.0, -500.0);
    fire.position = pos;
        
    [self->effect_layer addChild:fire];
}

-(id) init
{
	if( (self=[super init]) ) {
        
        disp_w = WIDTH;
        disp_h = HEIGHT;
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
        int y = j;
        
        BlockModel* block_base = [_dungeon get_x:x y:y];
        
        BlockView* block = [BlockView create:block_base];
        [block setPosition:ccp(30 + x * 60, 480 - (30 + y * 60))];
        [self->block_layer addChild:block];
        
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

-(void) notify_particle:(BlockModel*)block
{
    [self make_particle:block];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [delegate ccTouchesEnded:touches withEvent:event];
}

@end
