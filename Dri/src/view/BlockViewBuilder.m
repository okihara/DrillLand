//
//  BlockViewBuilder.m
//  Dri
//
//  Created by  on 12/09/17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockViewBuilder.h"
#import "BlockView.h"

#import "BreakablePresentation.h"
#import "BloodyPresentation.h"
#import "PlayerPresentation.h"
#import "BasicPresentation.h"
#import "AttackablePresentation.h"
#import "GettableItemPresentation.h"

@implementation BlockViewBuilder

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
    label.color = ccc3(120, 0, 0);
    label.visible = b.can_tap; // タップ出来ないときは数字を見せない
    [block addChild:label];
}


// -----------------------------------------------------------------------------

+(NSString*)name_from_block_type:(enum ID_BLOCK)block_id
{
    return [NSString stringWithFormat:@"blk%05d.png", block_id];
}

// type/block_id によって presentation を追加
// type という概念でここは残る
+(void)attach_presentation:(BlockView *)block_view block_model:(BlockModel *)block_model
{
    {
        NSObject<BlockPresentation> *p = [[BasicPresentation alloc] init];
        [block_view add_presentation:p];
        [p release];
    }
    
    switch (block_model.block_id) {
            
        case ID_EMPTY:
        {
            //[self add_route_num:b ctx:ctx block:block];
        }
            break;
            
        case ID_PLAYER:
        {
            block_view.scale = 2.0;
            
            {
                NSObject<BlockPresentation>* p = [[BloodyPresentation alloc] init];
                [block_view add_presentation:p];
                [p release];
            }
            
            {
                NSObject<BlockPresentation>* p = [[PlayerPresentation alloc] init];
                [block_view add_presentation:p];
                [p release];
            }
            
            {
                NSObject<BlockPresentation>* p = [[AttackablePresentation alloc] init];
                [block_view add_presentation:p];
                [p release];
            }
            
            [block_view play_anime:@"walk"];
        }
            break;
            
        case ID_ENEMY_BLOCK_0:
            [block_view play_anime:@"action0"];
        case ID_ENEMY_BLOCK_1:
        {
            block_view.scale = 2.0;
            
            [self add_can_destroy_num:block_model block:block_view];
            
            {
                NSObject<BlockPresentation>* p = [[BreakablePresentation alloc] init];
                [block_view add_presentation:p];
                [p release];
            }

            {
                NSObject<BlockPresentation>* p = [[BloodyPresentation alloc] init];
                [block_view add_presentation:p];
                [p release];
            }
            
            {
                NSObject<BlockPresentation>* p = [[AttackablePresentation alloc] init];
                [block_view add_presentation:p];
                [p release];
            }
        }            
            break;
            
        case ID_ITEM_BLOCK_0:
        {
            [self add_can_destroy_num:block_model block:block_view];
            
            {
                NSObject<BlockPresentation> *p = [[GettableItemPresentation alloc] init];
                [block_view add_presentation:p];
                [p release];
            }
        }
            break;
            
        case ID_ITEM_BLOCK_1:
        {
            [self add_can_destroy_num:block_model block:block_view];
            
            {
                NSObject<BlockPresentation>* p = [[GettableItemPresentation alloc] init];
                [block_view add_presentation:p];
                [p release];
            }
        }
            break;
            
        case ID_ITEM_BLOCK_2:
        {
            [self add_can_destroy_num:block_model block:block_view];
            
            {
                NSObject<BlockPresentation>* p = [[BreakablePresentation alloc] init];
                [block_view add_presentation:p];
                [p release];
            }
        }
            break;
            
        default:
        {
            [self add_can_destroy_num:block_model block:block_view];
            
            {            
                NSObject<BlockPresentation>* p = [[BreakablePresentation alloc] init];
                [block_view add_presentation:p];
                [p release];
            }
        }
            break;
    }
}

+(BlockView*)build:(BlockModel*)block_model ctx:(DungeonModel*)dungeon_model
{
    NSString *filename = [BlockViewBuilder name_from_block_type:block_model.view_id];
    BlockView* block_view = [BlockView spriteWithFile:filename];
    [block_view setup];
    [[block_view texture] setAliasTexParameters];
    [self attach_presentation:block_view block_model:block_model];
    return block_view;
}

@end
