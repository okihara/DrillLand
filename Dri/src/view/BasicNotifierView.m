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

static NSMutableArray *notify_queue = nil;
static CCNode *target_node = nil;


- (void)run
{
    CGPoint start_pos = ccp(160, 480 + 60); 
    CGPoint end_pos   = ccp(160, 480 - 150); 
    
    self.position = start_pos;
    
    CCFiniteTimeAction* enter = [CCMoveTo actionWithDuration:0.1 position:end_pos];
    CCActionInterval* nl = [CCDelayTime actionWithDuration:self->duration_sec];
    CCFiniteTimeAction* exit  = [CCMoveTo actionWithDuration:0.1 position:start_pos];
    CCCallFuncO *suicide = [CCCallFuncO actionWithTarget:self selector:@selector(suicide)];
    CCSequence* seq = [CCSequence actions:enter, nl, exit, suicide, nil];
    
    [self runAction:seq];
}

-(id) initWithMessage:(NSString*)message duration:(ccTime)sec
{
    if(self=[super init]) {
        
        self->duration_sec = sec;

        self->base_layer = [CCLayerColor layerWithColor:ccc4(0, 0, 255, 255) width:280 height:60];
        self->base_layer.position = ccp(-140, -30);
        [self addChild:self->base_layer];
        
        self->content_text = [FontFactory makeLabel:message]; 
        [self addChild:self->content_text];
    }
    return self;
}

+(void)setup:(CCNode*)target_node_
{
    target_node = target_node_;
}

+(void)fire
{
    if ([notify_queue count] > 0) {
        BasicNotifierView *notifier = [notify_queue objectAtIndex:0];
        
        [notifier run];
        [target_node addChild:notifier];
    } 
}

+(void)notify:(NSString*)message target:(CCNode*)node duration:(ccTime)sec
{
    if (!notify_queue) {
        notify_queue = [[NSMutableArray array] retain];
    }

    CCNode *notifier = [[BasicNotifierView alloc] initWithMessage:message duration:(ccTime)sec];
    [notify_queue addObject:notifier];

    if ([notify_queue count] == 1) {
        [BasicNotifierView fire];
    }
}

+(void)notify:(NSString*)message target:(CCNode*)node;
{
    [BasicNotifierView notify:message target:node duration:1.0];
}

-(void) suicide
{
    [self removeFromParentAndCleanup:YES];
    [notify_queue removeObjectAtIndex:0];
    [BasicNotifierView fire];
}


@end
