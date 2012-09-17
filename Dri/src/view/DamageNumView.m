//
//  DamageNumView.m
//  Dri
//
//  Created by  on 12/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DamageNumView.h"
#import "DL.h"
#import "FontFactory.h"

@implementation DamageNumView

+(void)spawn:(int)num target:(CCNode*)parent position:(CGPoint)pos;
{
    [DamageNumView spawn:num target:parent position:pos color:ccc3(255, 255, 255)];
}

+(void)spawn:(int)num target:(CCNode*)parent position:(CGPoint)pos color:(ccColor3B)color
{
    CCNode* num_view = [[DamageNumView alloc] initWithString:[NSString stringWithFormat:@"%d", num] color:color];
    num_view.position = pos;
    [parent addChild:num_view];
}

-(void) suicide
{
    [self removeFromParentAndCleanup:YES];
}

-(id) initWithString:(NSString*)str color:(ccColor3B)color
{
     if(self=[super init]) {
        
         self->content_text = [FontFactory makeLabel:str color:color];
         self->content_text.scale = 1.0;
         [self addChild:self->content_text];
         
         CCJumpBy *j1 = [CCJumpBy actionWithDuration:0.3   position:ccp(0, 0) height:30.0 jumps:1];
         CCJumpBy *j2 = [CCJumpBy actionWithDuration:0.15  position:ccp(0, 0) height:15.0 jumps:1];
         CCJumpBy *j3 = [CCJumpBy actionWithDuration:0.075 position:ccp(0, 0) height:7.5  jumps:1];
         CCJumpBy *j4 = [CCJumpBy actionWithDuration:0.037 position:ccp(0, 0) height:3.7  jumps:1];
         CCJumpBy *j5 = [CCJumpBy actionWithDuration:0.018 position:ccp(0, 0) height:1.8  jumps:1];
            
         CCDelayTime *delay = [CCDelayTime actionWithDuration:0.7];
         CCFadeOut *fo = [CCFadeOut actionWithDuration:0.3];
         CCCallFuncO *suicide = [CCCallFuncO actionWithTarget:self selector:@selector(suicide)];
         
         [self->content_text runAction:[CCSequence actions:j1,j2,j3,j4,j5, delay, fo, suicide, nil]];
     }
    return self;
}

@end
