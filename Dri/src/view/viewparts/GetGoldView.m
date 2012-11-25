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

-(CCAction*)make_action:(float)mag
{
    CCJumpBy *j1 = [CCJumpBy actionWithDuration:0.3   position:ccp(30 * mag, 0) height:30.0 jumps:1];
    CCJumpBy *j2 = [CCJumpBy actionWithDuration:0.15  position:ccp(15 * mag, 0) height:15.0 jumps:1];
    CCJumpBy *j3 = [CCJumpBy actionWithDuration:0.075 position:ccp(7.5* mag, 0) height:7.5  jumps:1];
    CCJumpBy *j4 = [CCJumpBy actionWithDuration:0.037 position:ccp(3.7* mag, 0) height:3.7  jumps:1];
    CCJumpBy *j5 = [CCJumpBy actionWithDuration:0.018 position:ccp(1.8* mag, 0) height:1.8  jumps:1];
//    CCFadeOut *fo = [CCFadeOut actionWithDuration:0.7];
    CCMoveTo *fo = [CCMoveTo actionWithDuration:0.4 position:ccp(300, 500)];
    CCCallFunc *suicide = [CCCallFunc actionWithTarget:self selector:@selector(suicide)];
    CCEaseIn *last = [CCEaseIn actionWithAction:fo rate:5.0];
//    return [CCSequence actions:j1, j2, j3, j4, j5, delay, fo, suicide, nil];
    
    CCSequence *seq = [CCSequence actions:j1, j2, j3, j4, j5, last, suicide, nil];
//    CCMoveBy   *move_right = [CCMoveBy actionWithDuration:1.0 position:ccp(20, 0)];
    return [CCTargetedAction actionWithTarget:self->coin_icon action:[CCSpawn actions:seq, nil]];
}

-(id)initWithNumExp:(UInt32)num_exp
{
    if(self=[super init]) {
        
//        ccColor3B color = ccc3(255, 255, 255);
//        NSString *str = [NSString stringWithFormat:@"+%d G", num_exp];
//        self->content_text = [FontFactory makeLabel:str color:color];
//        self->content_text.position = ccp(20, 0);
//        [self addChild:self->content_text];
        
        self->coin_icon = [CCSprite spriteWithSpriteFrameName:@"coin0.png"];

        self->coin_icon.position = ccp(0, 0);
        self->coin_icon.scale = 2.0f;
        
        [self addChild:coin_icon];
    }    
    return self;
}

+ (void)_spawn:(UInt32)num_exp pos:(CGPoint)pos parent:(CCNode *)parent
{
    GetGoldView *node = [[GetGoldView alloc] initWithNumExp:num_exp];
    node.position = pos;
    
    [parent addChild:node];
    
    float mag = (float)(rand() % 400 - 200) / 100.0f;
    mag = 0.01f;
    [node runAction:[node make_action:mag]];
}

+(void)spawn:(CCNode*)parent position:(CGPoint)pos num_exp:(UInt32)num_exp
{
    int max_num = 1;
    for (int i = 0; i < max_num; ++i) {
        [self _spawn:num_exp pos:pos parent:parent];
    }
}

@end
