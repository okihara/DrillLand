//
//  GetExpView.m
//  Dri
//
//  Created by  on 12/10/19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GetExpView.h"
#import "FontFactory.h"

@implementation GetExpView

-(void) suicide
{
    [self removeFromParentAndCleanup:YES];
}

-(CCAction*)make_action
{
    CCMoveBy *action = [CCMoveBy actionWithDuration:0.7f position:ccp(0, 60)];
    CCFiniteTimeAction *ease = [CCEaseOut actionWithAction:action rate:2];
    CCMoveBy *action2 = [CCMoveBy actionWithDuration:0.4f position:ccp(0, 400)];
    CCFiniteTimeAction *ease2 = [CCEaseIn actionWithAction:action2 rate:3];
    CCCallFunc *suicide = [CCCallFunc actionWithTarget:self selector:@selector(suicide)];
    
    return [CCSequence actions:ease, ease2, suicide, nil];
}

-(id) initWithNumExp:(UInt32)num_exp
{
    if(self=[super init]) {
        ccColor3B color = ccc3(255, 255, 255);
        NSString *str = [NSString stringWithFormat:@"XP +%d", num_exp];
        self->content_text = [FontFactory makeLabel:str color:color];
        [self addChild:self->content_text];
    }    
    return self;
}

+(void)spawn:(CCNode*)parent position:(CGPoint)pos num_exp:(UInt32)num_exp
{
    GetExpView *node = [[GetExpView alloc] initWithNumExp:num_exp];
    node.position = pos;
    [parent addChild:node];
    [node runAction:[node make_action]];
}

@end
