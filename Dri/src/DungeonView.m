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
@synthesize curring_top, curring_bottom;
@synthesize player;

-(void)launch_particle:(NSString*)name position:(CGPoint)pos
{
    [self->effect_launcher launch_particle:name position:pos];
}

-(void)launch_effect:(NSString *)name
{
    // color flash
    // shake
    return;
}

-(id) init
{
	if(self=[super init]) {
        
        disp_w = WIDTH;
        disp_h = HEIGHT;
        offset_y = 0;
        
        self->view_map = [[ObjectXDMap alloc] init];
        
        self->block_layer = [[CCLayer alloc]init];
        [self addChild:self->block_layer];
        
        self->effect_layer = [[CCLayer alloc]init];
        [self addChild:self->effect_layer];
             
        self->effect_launcher = [[EffectLauncher alloc] init];
        self->effect_launcher.target_layer = self->effect_layer;
        
	}
	return self;
}

-(void)add_block:(BlockView*)block
{
    [self->effect_layer addChild:block];    
}

- (void)remove_view_line:(int)y _model:(DungeonModel *)_dungeon
{
    for (int x = 0; x < disp_w; x++) {
        BlockView *block = [self->view_map get_x:x y:y];
        [self->block_layer removeChild:block cleanup:YES];
        [view_map set_x:x y:y value:nil];
    }
}

- (void)update_view_line:(int)y _model:(DungeonModel *)dungeon_
{
    for (int x = 0; x < disp_w; x++) {
        BlockModel *block_model = [dungeon_ get_x:x y:y];
        BlockView *block = [BlockView create:block_model ctx:dungeon_];
        block.position = ccp(30 + x * 60, 480 - (30 + y * 60));
        
        [self->block_layer addChild:block];
        [view_map set_x:x y:y value:block];
    }
}

- (void)update_player_pos:(DungeonModel *)_dungeon
{
    CCMoveTo *act_move = [CCMoveTo actionWithDuration:0.07 position:ccp(30 + _dungeon.player.pos.x * 60, 480 - (30 + _dungeon.player.pos.y * 60))];
    CCEaseInOut *ease = [CCEaseInOut actionWithAction:act_move rate:2];
    [self->player runAction:ease];
}

- (void)update_view:(DungeonModel *)_dungeon
{
    // clear
    [self->block_layer removeAllChildrenWithCleanup:YES];
    [view_map clear];
    
    // curring を考慮して更新
    for (int y = self.curring_top; y < self.curring_bottom; y++) {
        [self update_view_line:y _model:_dungeon];
    }
    
    // player の移動
    [self update_player_pos:_dungeon];
}

-(void)update_presentation:(DungeonModel *)dungeon_
{
    // curring を考慮して更新
    for (int y = self.curring_top; y < self.curring_bottom; y++) {
        for (int x = 0; x < disp_w; x++) {
            BlockModel *block_model = [dungeon_ get_x:x y:y];
            BlockView  *block_view  = [self->view_map get_x:x y:y];
            [block_view update_presentation:self model:block_model];
        }
    }
    
    // PLAYER の分 TODO: 同じように扱いたい。。。
    [self.player update_presentation:self model:dungeon_.player];
}

- (void) notify:(int)type dungeon:(DungeonModel*)dungeon_ params:(id)params
{
    // TODO: ここは、ひたすらQueにためるだけ
    BlockModel* b = (BlockModel*)params;
    switch (type) {
        case 0:
            //[self update_view:dungeon_]; // 画面更新
            break;
        default:
            
            if(b.type == ID_PLAYER) {
                BlockView* block = self.player;
                [block handle_event:self type:type model:b];
            } else {
                BlockView* block = [view_map get_x:b.pos.x y:b.pos.y];
                [block handle_event:self type:type model:b];
            }

            break;
    }
}

@end
