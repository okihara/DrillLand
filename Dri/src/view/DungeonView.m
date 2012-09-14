//
//  DungeonView.m
//  Dri
//
//  Created by  on 12/08/17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "../DL.h"
#import "DungeonView.h"
#import "XDMap.h"
#import "BlockModel.h"
#import "BlockView.h"
#import "DamageNumView.h"

@implementation DungeonView

@synthesize delegate;
@synthesize curring_top, curring_bottom;
@synthesize player;


// ========================================================================
// エフェクト用のヘルパー
// ========================================================================

-(void)launch_particle:(NSString*)name position:(CGPoint)pos
{
    [self->effect_launcher launch_particle:name position:pos];
}

-(void)launch_effect:(NSString *)name position:(CGPoint)pos param1:(int)p1
{
    // color flash
    // shake
    
    [DamageNumView spawn:p1 target:self->effect_layer position:pos];
    return;
}

// ========================================================================

-(id) init
{
	if(self=[super init]) {
        
        disp_w = WIDTH;
        disp_h = HEIGHT;
        offset_y = 0;
        
        self->view_map = [[ObjectXDMap alloc] init];
        
        self->block_layer = [[CCLayer alloc]init];
        [self addChild:self->block_layer];
        
        CCSprite *sky = [CCSprite spriteWithFile:@"sky00.png"];
        sky.position = ccp(160, 480 - 120 + 53 + 10);
        [self addChild:sky];
        
        self->effect_layer = [[CCLayer alloc]init];
        [self addChild:self->effect_layer];
             
        self->effect_launcher = [[EffectLauncher alloc] init];
        self->effect_launcher.target_layer = self->effect_layer;
        
	}
	return self;
}


// ========================================================================

-(void)add_block:(BlockView*)block
{
    [self->effect_layer addChild:block];    
}


//===============================================================
//
// ブロックの描画
//
//===============================================================

// update
- (void)update_view_line:(int)y _model:(DungeonModel *)dungeon_
{
    for (int x = 0; x < disp_w; x++) {
        
        BlockView *block = [view_map get_x:x y:y];
        
        // 既に描画済みなら描画しない
        if (block) {
            continue;
        }
        
        BlockModel *block_model = [dungeon_ get_x:x y:y];
        block = [BlockView create:block_model ctx:dungeon_];
        block.position = [self model_to_local:cdp(x, y)];
        
        [self->block_layer addChild:block];
        [view_map set_x:x y:y value:block];
    }
}

- (void)update_view_lines:(DungeonModel *)_dungeon
{
    for (int y = self.curring_top; y < self.curring_bottom; y++) {
        [self update_view_line:y _model:_dungeon];
    }
}

// 最初に一回しか呼ばないかも
// update_view -> update_view_lines -> update_view_line
- (void)update_view:(DungeonModel *)_dungeon
{
    // clear
    [self->block_layer removeAllChildrenWithCleanup:YES];
    [view_map clear];

    // curring を考慮して更新
    [self update_view_lines:_dungeon];
}


//--------------------------------------------
// remove

- (void)remove_block_view:(DLPoint)pos
{
    BlockView *block = [self->view_map get_x:pos.x y:pos.y];
    [self->block_layer removeChild:block cleanup:NO];
    [view_map set_x:pos.x y:pos.y value:nil];
}

- (void)remove_block_view_line:(int)y _model:(DungeonModel *)_dungeon
{
    for (int x = 0; x < disp_w; x++) {
        [self remove_block_view:cdp(x, y)];
    }
}


//===============================================================
//
// プレゼンテーションの更新
//
//===============================================================

- (void)update_presentation_all:(DungeonModel *)dungeon_ phase:(enum DL_PHASE)phase
{
    // curring を考慮して更新
    for (int y = self.curring_top; y < self.curring_bottom; y++) {
        for (int x = 0; x < disp_w; x++) {
            BlockModel *block_model = [dungeon_ get_x:x y:y];
            BlockView  *block_view  = [self->view_map get_x:x y:y];
            [block_view update_presentation:self model:block_model phase:phase];
        }
    }
}

-(void)update_presentation:(DungeonModel *)dungeon_ phase:(enum DL_PHASE)phase
{
    // TODO: PLAYER も同じように扱いたい。。。
    [self update_presentation_all:dungeon_ phase:phase];
    [self.player update_presentation:self model:dungeon_.player phase:phase];
}


//===============================================================
//
// notify
//
//===============================================================

// TODO: DungeonScene においてもいいような。。。

-(void) notify:(DungeonModel*)dungeon_ event:(DLEvent*)e
{
    // TODO: PLAYER も同じように扱いたい。。。
    
    BlockModel *b = (BlockModel*)e.target;
    
    if(b.type == ID_PLAYER) {
        BlockView* block = self.player;
        [block handle_event:self event:e];
    } else {
        BlockView *block = [view_map get_x:b.pos.x y:b.pos.y];
        [block handle_event:self event:e];
    }
}

//===============================================================
//
// HELPER
//
//===============================================================

- (CGPoint)model_to_local:(DLPoint)pos
{
    return ccp(30 + pos.x * BLOCK_WIDTH, 480 - (30 + pos.y * BLOCK_WIDTH));
}


@end
