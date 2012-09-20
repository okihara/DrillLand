//
//  BasicNotifierView.m
//  Dri
//
//  Created by  on 12/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BasicNotifierView.h"
#import "FontFactory.h"


@implementation BasicNotifierView

+(void)notify:(NSString*)message target:(CCNode*)node;
{
    CCNode* notifier = [[BasicNotifierView alloc] initWithMessage:message];
    [node addChild:notifier];
}

-(void) suicide
{
    [self removeFromParentAndCleanup:YES];
}

-(id) initWithMessage:(NSString*)message
{
    if(self=[super init]) {
                
        CGPoint start_pos = ccp(160, 480 + 60); 
        CGPoint end_pos   = ccp(160, 480 - 150); 

        self.position = start_pos;

        self->base_layer = [CCLayerColor layerWithColor:ccc4(0, 0, 255, 255) width:280 height:60];
        self->base_layer.position = ccp(-140, -30);
        [self addChild:self->base_layer];

        self->content_text = [FontFactory makeLabel:message]; 
        [self addChild:self->content_text];

        CCFiniteTimeAction* enter = [CCMoveTo actionWithDuration:0.1 position:end_pos];
        CCActionInterval* nl = [CCDelayTime actionWithDuration:1.0];
        CCFiniteTimeAction* exit  = [CCMoveTo actionWithDuration:0.1 position:start_pos];
        CCCallFuncO *suicide = [CCCallFuncO actionWithTarget:self selector:@selector(suicide)];
        CCSequence* seq = [CCSequence actions:enter, nl, exit, suicide, nil];

        [self runAction:seq];
    }
    return self;
}

@end
