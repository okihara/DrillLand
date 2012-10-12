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


// TODO: なんていうか、switch でやるのはいけてないよねー
// Command パターン

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
        case ID_ITEM_BLOCK_0:
            filename = @"block200.png";
            break;
        case ID_ITEM_BLOCK_1:
            filename = @"block201.png";
            break;
        default:
            filename = @"block00.png";
            break;
    }
    
    BlockView* block = [BlockView spriteWithFile:filename];
    [block setup];
    [[block texture] setAliasTexParameters];
    
    switch (b.type) {
            
        case ID_EMPTY:
        {
            //[self add_route_num:b ctx:ctx block:block];
        }
            break;
            
        case ID_PLAYER:
        {
            block.scale = 2.0;

            {
                NSObject<BlockPresentation>* p = [[BloodyPresentation alloc] init];
                [block add_presentation:p];
                [p release];
            }
            
            {
                NSObject<BlockPresentation>* p = [[PlayerPresentation alloc] init];
                [block add_presentation:p];
                [p release];
            }
            
            {
                NSObject<BlockPresentation>* p = [[AttackablePresentation alloc] init];
                [block add_presentation:p];
                [p release];
            }
            
            [block play_anime:@"walk"];
        }
            break;
            
        case ID_ENEMY_BLOCK_0:
            [block play_anime:@"action0"];
        case ID_ENEMY_BLOCK_1:
        {
            block.scale = 2.0;

            [self add_can_destroy_num:b block:block];
            
            NSObject<BlockPresentation>* p;
            
            p = [[BreakablePresentation alloc] init];
            [block add_presentation:p];
            [p release];
            
            p = [[BloodyPresentation alloc] init];
            [block add_presentation:p];
            [p release];
            
            {
                NSObject<BlockPresentation>* p = [[AttackablePresentation alloc] init];
                [block add_presentation:p];
                [p release];
            }
        }            
            break;
            
        case ID_ITEM_BLOCK_0:
        {
            //block.scale = 2.0f;   
            [self add_can_destroy_num:b block:block];
            {
                NSObject<BlockPresentation>* p;
                p = [[BasicPresentation alloc] init];
                [block add_presentation:p];
                [p release];
            }
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
