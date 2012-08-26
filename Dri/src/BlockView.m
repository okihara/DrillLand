//
//  BlockView.m
//  Dri
//
//  Created by  on 12/08/18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockView.h"
#import "BlockModel.h"
#import "PlayerModel.h"
#import "DungeonView.h"

@implementation BlockView

+(BlockView *) create:(BlockModel*)b ctx:(DungeonModel*)ctx
{
    // ブロック
    NSString *filename;
    switch (b.type) {
        case 1:
            filename = @"block01.png";
            break;
        case 2:
            filename = @"block02.png";
            break;
        case 3:
            filename = @"block03.png";
            break;
        case 4:
            filename = @"block04.png";
            break;
        case 5:
            filename = @"mon001.png";
            break;
        case 6:
            filename = @"mon002.png";
            break;
        case 99:
            filename = @"block99.png";
            break;
        default:
            filename = @"block00.png";
            break;
    }
    
    BlockView* block = [BlockView spriteWithFile:filename];
    
    // 数字
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
//    
//    // 自機
//    if (ctx.player.pos.x == b.x && ctx.player.pos.y == b.y) {
//        CCLabelTTF *cost = [CCLabelTTF labelWithString:@"@" fontName:@"AppleGothic" fontSize:20];
//        cost.position =  ccp(30, 30);
//        cost.color = ccc3(0, 255, 0);
//        [block addChild:cost];
//    }
    
    return block;
}

-(BOOL)handle_event:(DungeonView*)ctx type:(int)type
{
    switch (type) {
        case 1:
            [ctx make_particle03:self];
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
