//
//  BasicNotifierView.m
//  Dri
//
//  Created by  on 12/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BasicNotifierView.h"


@implementation BasicNotifierView

-(id) init
{
    if(self=[super init]) {
        
        CGPoint start_pos = ccp(160, 480 + 60);
        CGPoint end_pos = ccp(160, 280);
        
        self.position = start_pos;

        self->base_layer = [CCLayerColor layerWithColor:ccc4(0, 0, 255, 255) width:280 height:60];
        self->base_layer.position = ccp(-140, -30);
        [self addChild:self->base_layer];

        self->content_text = [[CCLabelTTF labelWithString:@"XXX is level up now!" fontName:@"AppleGothic" fontSize:20] retain];
        self->content_text.color = ccc3(255, 255, 255);
        [self addChild:self->content_text];

        CCFiniteTimeAction* enter = [CCMoveTo actionWithDuration:0.1 position:end_pos];
        CCActionInterval* nl = [CCActionInterval actionWithDuration:1.0];
        CCFiniteTimeAction* exit  = [CCMoveTo actionWithDuration:0.1 position:start_pos];
        CCSequence* seq = [CCSequence actions:enter, nl, exit, nil];
        [self runAction:seq];
    }
    return self;
}
@end
