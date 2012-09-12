//
//  LargeNotifierView.m
//  Dri
//
//  Created by  on 12/09/10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LargeNotifierView.h"


@implementation LargeNotifierView

-(void) suicide
{
    [self removeFromParentAndCleanup:YES];
}

-(id) init
{
	if(self=[super init]) {
        
        self.position = ccp(160, 240);
        
        // make layer
        self->base_layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255) width:320 height:100];
        self->base_layer.position = ccp(-160, -50);
        [self addChild:self->base_layer];
        
        // make text
        self->content_text = [[CCLabelTTF labelWithString:@"The Beginning Cave" fontName:@"AppleGothic" fontSize:30] retain];
        self->content_text.color = ccc3(255, 255, 255);
        self->content_text.opacity = 0.0;
        [self addChild:self->content_text];

        // make action
        CCFiniteTimeAction* fi = [CCFadeIn actionWithDuration:1.0];
        CCFiniteTimeAction* fo= [CCFadeOut actionWithDuration:1.0];
        CCActionInterval* nl = [CCDelayTime actionWithDuration:2.0];
        CCCallFuncO *suicide = [CCCallFuncO actionWithTarget:self selector:@selector(suicide)];
        CCSequence* seq = [CCSequence actions:fi, nl, fo, suicide, nil];
        [self->content_text runAction:seq];
        [self->base_layer runAction:[seq copy]];
        
        CCFiniteTimeAction* mb = [CCMoveBy actionWithDuration:4.0 position:ccp(0, 50)];
        [self runAction:mb];
    }
	return self;
}

@end
