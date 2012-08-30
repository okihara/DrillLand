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

@implementation BlockView

+(BlockView *) create:(BlockModel*)b ctx:(DungeonModel*)ctx
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
    
    // 破壊できるか表示
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"1" fontName:@"AppleGothic" fontSize:20];
    label.position =  ccp(30, 30);
    label.color = ccc3(0, 0, 0);
    label.visible = b.can_tap; // タップ出来ないときは数字を見せない
    [block addChild:label];
    
//    // 数字
//    int c = [ctx.route_map get:cdp(b.x, b.y)];
//    CCLabelTTF *cost = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", c] fontName:@"AppleGothic" fontSize:20];
//    cost.position =  ccp(40, 30);
//    cost.color = ccc3(0, 0, 255);
//    [block addChild:cost];
    
    return block;
}

-(BOOL)handle_event:(DungeonView*)ctx type:(int)type
{
    switch (type) {
        case 1:
            [ctx launch_particle:@"hit2" position:self.position];
            break;
        case 2:
            [ctx make_particle:self];
            
        default:
            break;
    }

    // ここでパーティクル作る
    return YES;
}

@end
