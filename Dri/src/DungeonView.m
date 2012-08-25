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
#import "PlayerModel.h"
#import "PlayerView.h"

@implementation DungeonView

@synthesize delegate;

-(void) make_particle02:(BlockModel*)b
{
    CCSprite* block = [view_map get_x:b.x y:b.y];
    CGPoint pos = block.position;
    
    CCParticleSystem *fire = [[[CCParticleExplosion alloc] init] autorelease];
    [fire setTexture:[[CCTextureCache sharedTextureCache] addImage:@"block01.png"] ];
    fire.totalParticles = 8;
    fire.life = 1.0;
    fire.speed = 100;
    fire.position = pos;
    
    [self->effect_layer addChild:fire];
}

-(void) make_particle01:(BlockModel*)b
{
    CCSprite* block = [view_map get_x:b.x y:b.y];
    CGPoint pos = block.position;
    
    CCParticleSystem *fire = [[[CCParticleExplosion alloc] init] autorelease];
    [fire setTexture:[[CCTextureCache sharedTextureCache] addImage:@"block01.png"] ];
    fire.totalParticles = 40;
    fire.speed = 200;
    fire.gravity = ccp(0.0, -500.0);
    fire.position = pos;
    fire.life = 0.7;
        
    [self->effect_layer addChild:fire];
}

-(void) make_particle:(BlockModel*)b
{
    [self make_particle01:b];
    [self make_particle02:b];
    
    CCParticleSystem *p = [[[CCParticleSystemQuad alloc] initWithFile:@"hit2.plist"] autorelease];
    CCSprite* block = [view_map get_x:b.x y:b.y];
    CGPoint pos = block.position;
    p.position = pos;
    [self->effect_layer addChild:p];
}

-(id) init
{
	if( (self=[super init]) ) {
        
        disp_w = WIDTH;
        disp_h = HEIGHT;
        offset_y = 0;
        
        self->view_map = [[ObjectXDMap alloc] init];
        
        self->block_layer = [[CCLayer alloc]init];
        [self addChild:self->block_layer];
        
        self->effect_layer = [[CCLayer alloc]init];
        [self addChild:self->effect_layer];
        
        self->player = [[PlayerView alloc] init];
        [self->effect_layer addChild:self->player];
	}
	return self;
}

- (void)update_view_line:(int)y _model:(DungeonModel *)_dungeon
{
    for (int x = 0; x < disp_w; x++) {
        
        BlockModel *block_base = [_dungeon get_x:x y:y];
        BlockView *block = [BlockView create:block_base ctx:_dungeon];
        block.position = ccp(30 + x * 60, 480 - (30 + y * 60));
        [self->block_layer addChild:block];
        
        [view_map set_x:x y:y value:block];
    }
}

- (void)update_view:(DungeonModel *)_dungeon
{
    [view_map clear];
    for (int y = 0; y < disp_h; y++) {
        [self update_view_line:y _model:_dungeon];
    }
    
    CCMoveTo *act_move = [CCMoveTo actionWithDuration:0.07 position:ccp(30 + _dungeon.player.pos.x * 60, 480 - (30 + _dungeon.player.pos.y * 60))];
    CCEaseInOut *ease = [CCEaseInOut actionWithAction:act_move rate:2];
    [self->player runAction:ease];
    //[self->player.position = ccp(30 + _dungeon.player.pos.x * 60, 480 - (30 + _dungeon.player.pos.y * 60));
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

@end
