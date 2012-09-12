//
//  BlockView.m
//  Dri
//
//  Created by  on 12/08/18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockView.h"
#import "BlockModel.h"
#import "DungeonView.h"
#import "BreakablePresentation.h"
#import "BloodyPresentation.h"

@implementation BlockView

@synthesize is_alive;

- (void)setup
{
    self->events = [[NSMutableArray array] retain];
    self->presentation_list = [[NSMutableArray array] retain];
    is_alive = YES;
}

- (id)init
{
	if (self=[super init]) {
        [self setup];
	}
	return self;
}

- (void)dealloc
{
    [self->presentation_list release];
    [self->events release];
    [super dealloc];
}

- (void)add_presentation:(NSObject<BlockPresentation>*)presentation
{
    [self->presentation_list addObject:presentation];
}


//===============================================================
//
//
//
//===============================================================

- (void)_update_presentation:(DungeonView *)ctx type:(int)type b:(BlockModel *)b
{
    if (b.type == ID_PLAYER){
        
        for (NSObject<BlockPresentation>* p in self->presentation_list) {
            [p handle_event:ctx event:type model:b view:ctx.player];
        }
        
    } else {
        
        for (NSObject<BlockPresentation>* p in self->presentation_list) {
            [p handle_event:ctx event:type model:b view:self];
        }
        
    }
}

- (void)update_presentation:(DungeonView*)ctx model:(BlockModel*)b
{
    for (NSDictionary* event in self->events) {
        
        int type = [(NSNumber*)[event objectForKey:@"type"] intValue];
        BlockModel* b = (BlockModel*)[event objectForKey:@"model"];

        [self _update_presentation:ctx type:type b:b];
    }
    
    [self->events removeAllObjects];
    
    // 描画イベント全部処理して、死んでたら
    if (self.is_alive == NO) {
        [ctx remove_block_view:b.pos];
    }
}


//----------------------------------------------------------------

- (BOOL)handle_event:(DungeonView*)ctx type:(int)type model:(BlockModel*)b
{
    NSDictionary* event = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:type], @"type", b, @"model", nil];
    [self->events addObject:event];
    return YES;
}


//----------------------------------------------------------------
// animation helper

- (void)play_anime:(NSString*)name
{
    CCAnimation *anim = [[CCAnimationCache sharedAnimationCache] animationByName:name];
    CCAction* act = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:anim]];
    [self runAction:act];   
}


//===============================================================
//
// どちらかというと builder
//
//===============================================================

+ (void)add_route_num:(BlockModel *)b ctx:(DungeonModel *)ctx block:(BlockView *)block
{
    // 経路探索の結果を数字で表示
    int c = [ctx.route_map get:b.pos];
    CCLabelTTF *cost = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", c] fontName:@"AppleGothic" fontSize:20];
    cost.position =  ccp(40, 30);
    cost.color = ccc3(0, 0, 255);
    [block addChild:cost];
}

+ (void)add_can_destroy_num:(BlockModel *)b block:(BlockView *)block
{
    // 破壊できるか表示
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"1" fontName:@"AppleGothic" fontSize:20];
    label.position =  ccp(30, 30);
    label.color = ccc3(0, 0, 0);
    label.visible = b.can_tap; // タップ出来ないときは数字を見せない
    [block addChild:label];
}

+ (BlockView *)create:(BlockModel*)b ctx:(DungeonModel*)ctx
{
    // ブロック
    NSString *filename;
    switch (b.type) {
        case ID_NORMAL_BLOCK:
            filename = @"block01.png";
            break;
        case ID_GROUPED_BLOCK_1:
            filename = @"block02.png";
            break;
        case ID_GROUPED_BLOCK_2:
            filename = @"block03.png";
            break;
        case ID_GROUPED_BLOCK_3:
            filename = @"block04.png";
            break;
        case ID_ENEMY_BLOCK_0:
            filename = @"mon001.png";
            break;
        case ID_ENEMY_BLOCK_1:
            filename = @"mon002.png";
            break;
        case ID_UNBREAKABLE_BLOCK:
            filename = @"block99.png";
            break;
        default:
            filename = @"block00.png";
            break;
    }
    
    BlockView* block = [BlockView spriteWithFile:filename];
    [block setup];
    
    switch (b.type) {
        case ID_EMPTY:
        {
            [self add_route_num:b ctx:ctx block:block];
        }
            break;
        case ID_PLAYER:
        {
            NSObject<BlockPresentation>* p;
            p = [[BloodyPresentation alloc] init];
            [block add_presentation:p];
            [p release];
            
            [block play_anime:@"walk"];
        }
            break;
        case ID_ENEMY_BLOCK_0:
        case ID_ENEMY_BLOCK_1:
        {
            [self add_can_destroy_num:b block:block];
            
            NSObject<BlockPresentation>* p;
            
            p = [[BreakablePresentation alloc] init];
            [block add_presentation:p];
            [p release];
            
            p = [[BloodyPresentation alloc] init];
            [block add_presentation:p];
            [p release];
        }            
            break;
        default:
        {
            [self add_can_destroy_num:b block:block];
            
            NSObject<BlockPresentation>* p;
            
            p = [[BreakablePresentation alloc] init];
            [block add_presentation:p];
            [p release];
        }
            break;
    }

    return block;
}

@end
