//
//  StatusBarView.m
//  Dri
//
//  Created by  on 12/09/16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StatusBarView.h"
#import "DL.h"

@implementation StatusBarView

-(void)update_hp:(NSNotification *)aNotification
{
    NSNumber *value = (NSNumber*)[aNotification object];
    [self->hp setString:[NSString stringWithFormat:@"HP: %d", [value intValue]]];
}

- (id)init
{
    if(self=[super init]) {
        
        self->bg = [CCLayerColor layerWithColor:ccc4(0, 64, 0, 255)];
        self->bg.position = ccp(-320 / 2, - 40 / 2);
        [self addChild:self->bg];
        
        self->name = [[CCLabelTTF labelWithString:@"OKIHARA " fontName:DL_FONT fontSize:20] retain];
        self->name.position = ccp(-100, 0);
        [self addChild:self->name];
        
        self->hp = [[CCLabelTTF labelWithString:@"HP: 10" fontName:DL_FONT fontSize:20] retain];
        [self addChild:self->hp];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(update_hp:) name:@"UpdateHP" object:nil];
    }
    return self;
}

@end
