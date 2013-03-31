//
//  StatusScene.m
//  Dri
//
//  Created by  on 13/03/09.
//  Copyright 2013 Hiromitsu. All rights reserved.
//

#import "StatusScene.h"


@implementation StatusScene

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [[CCDirector sharedDirector] popScene];
}

- (void)onEnter
{
    [super onEnter];
    
    // ここから 作成したノードに触るにはどうしたらいいの？？
    label_atk.string  = @"99";
    label_def.string  = @"9";
    label_xp.string   = @"999";
    label_gold.string = @"1090";
}

@end
