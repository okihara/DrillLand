//
//  BlockView.m
//  Dri
//
//  Created by  on 12/08/18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockView.h"
#import "BlockModel.h"

@implementation BlockView

+(BlockView *) create:(BlockModel*)b
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
    
    return block;
}

-(BOOL)handle_event:(NSString*)event
{
    return NO;
}

@end
