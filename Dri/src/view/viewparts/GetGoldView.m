//
//  GetGoldView.m
//  Dri
//
//  Created by  on 12/10/19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GetGoldView.h"
#import "FontFactory.h"


@implementation GetGoldView

-(void)suicide
{
    [self removeFromParentAndCleanup:YES];
}

-(CCAction*)make_action
{    
    CCJumpBy *j1 = [CCJumpBy actionWithDuration:0.3   position:ccp(0, 0) height:30.0 jumps:1];
    CCJumpBy *j2 = [CCJumpBy actionWithDuration:0.15  position:ccp(0, 0) height:15.0 jumps:1];
    CCJumpBy *j3 = [CCJumpBy actionWithDuration:0.075 position:ccp(0, 0) height:7.5  jumps:1];
    CCJumpBy *j4 = [CCJumpBy actionWithDuration:0.037 position:ccp(0, 0) height:3.7  jumps:1];
    CCJumpBy *j5 = [CCJumpBy actionWithDuration:0.018 position:ccp(0, 0) height:1.8  jumps:1];
    //CCDelayTime *delay = [CCDelayTime actionWithDuration:0.7];
    CCFadeOut *fo = [CCFadeOut actionWithDuration:0.7];
    CCCallFunc *suicide = [CCCallFunc actionWithTarget:self selector:@selector(suicide)];
    
//    return [CCSequence actions:j1, j2, j3, j4, j5, delay, fo, suicide, nil];
    return [CCSequence actions:j1, j2, j3, j4, j5, fo, suicide, nil];
}

-(id)initWithNumExp:(UInt32)num_exp
{
    if(self=[super init]) {
        ccColor3B color = ccc3(255, 255, 255);
        NSString *str = [NSString stringWithFormat:@"+%d G", num_exp];
        self->content_text = [FontFactory makeLabel:str color:color];
        self->content_text.position = ccp(20, 0);
        [self addChild:self->content_text];
        
        CCSprite *coin_icon = [CCSprite spriteWithFile:@"coin.png"];
        coin_icon.position = ccp(-24, 0);
        coin_icon.scale = 0.5f;
        
        [self addChild:coin_icon];
    }    
    return self;
}

+(void)spawn:(CCNode*)parent position:(CGPoint)pos num_exp:(UInt32)num_exp
{
    GetGoldView *node = [[GetGoldView alloc] initWithNumExp:num_exp];
    node.position = pos;
    [parent addChild:node];
    [node runAction:[node make_action]];
}

@end