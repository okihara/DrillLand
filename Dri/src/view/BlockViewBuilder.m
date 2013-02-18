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
#import "EnemyPresentation.h"
#import "ItemBoxPresentation.h"

@implementation BlockViewBuilder

// 経路探索の結果を数字で表示
+ (void)add_route_num:(BlockModel *)b ctx:(DungeonModel *)ctx block:(BlockView *)block
{
    // int c = [ctx.route_map get:b.pos];
    int c = 99;
    CCLabelTTF *cost = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", c] fontName:@"AppleGothic" fontSize:20];
    cost.position =  ccp(40, 30);
    cost.color = ccc3(0, 0, 255);
    [block addChild:cost];
}

// 破壊できるか表示をアタッチする
+ (void)add_can_destroy_num:(BlockModel *)b block:(BlockView *)block
{
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

// -----------------------------------------------------------------------------

+ (void)setup_view:(BlockView *)block_view block_model:(BlockModel *)block_model
{
    // block_view へ移動
    switch (block_model.block_id) {
            
        case ID_EMPTY:
            break;
            
        case ID_PLAYER:
            [block_view runAction:[block_view playAnime:block_model name:@"front"]];
            break;
            
        case ID_ENEMY_BLOCK_0:
            [block_view runAction:[block_view playAnime:block_model name:@"front"]];
            break;
            
        case ID_ENEMY_BLOCK_1:
            break;
            
        default:
            break;
    }
    
    [self add_can_destroy_num:block_model block:block_view];
    block_view.scale = 2.0;
}

// type/block_id によって presentation を追加
// type という概念でここは残る
+(void)attach_presentation:(BlockView *)block_view block_model:(BlockModel *)block_model
{
    // 基本のプレゼン
    {
        NSObject<BlockPresentation> *p = [[BasicPresentation alloc] init];
        [block_view addPresentation:p];
        [p release];
    }
    
    switch (block_model.view_type) {
            
        case VIEW_TYPE_NULL:
        {
            //[self add_route_num:b ctx:ctx block:block];
        }
            break;
            
        case VIEW_TYPE_BLOCK:
        {
            {            
                NSObject<BlockPresentation>* p = [[BreakablePresentation alloc] init];
                [block_view addPresentation:p];
                [p release];
            }
        }
            break;
            
        case VIEW_TYPE_PLAYER:
        {
            {
                NSObject<BlockPresentation>* p = [[PlayerPresentation alloc] init];
                [block_view addPresentation:p];
                [p release];
            }
            
            {
                NSObject<BlockPresentation>* p = [[BloodyPresentation alloc] init];
                [block_view addPresentation:p];
                [p release];
            }
            
            {
                NSObject<BlockPresentation>* p = [[AttackablePresentation alloc] init];
                [block_view addPresentation:p];
                [p release];
            }
        }
            break;
            
        case VIEW_TYPE_ENEMY:
        {            
            {
                NSObject<BlockPresentation>* p = [[EnemyPresentation alloc] init];
                [block_view addPresentation:p];
                [p release];
            }
            
//            {
//                NSObject<BlockPresentation>* p = [[BreakablePresentation alloc] init];
//                [block_view add_presentation:p];
//                [p release];
//            }

            {
                NSObject<BlockPresentation>* p = [[BloodyPresentation alloc] init];
                [block_view addPresentation:p];
                [p release];
            }
            
            {
                NSObject<BlockPresentation>* p = [[AttackablePresentation alloc] init];
                [block_view addPresentation:p];
                [p release];
            }
        }            
            break;
            
        case VIEW_TYPE_ITEM_BASIC:
        {
            {
                NSObject<BlockPresentation> *p = [[GettableItemPresentation alloc] init];
                [block_view addPresentation:p];
                [p release];
            }
            
            [self add_can_destroy_num:block_model block:block_view];
        }
            break;
                        
        case VIEW_TYPE_ITEM_BOX:
        {
            {
                NSObject<BlockPresentation>* p = [ItemBoxPresentation new];
                [block_view addPresentation:p];
                [p release];
            }
        }
            break;
            
        default:
            break;
    }
    
}

+(BlockView*)build:(BlockModel*)block_model ctx:(DungeonModel*)dungeon_model
{
    NSString *filename = [BlockViewBuilder name_from_block_type:block_model.view_id];
    BlockView* block_view = [BlockView spriteWithFile:filename];
    [block_view setup];
    [[block_view texture] setAliasTexParameters];
    
    [self setup_view:block_view block_model:block_model];
    [self attach_presentation:block_view block_model:block_model];
    
    return block_view;
}

@end
