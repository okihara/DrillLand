//
//  StatusBarView.m
//  Dri
//
//  Created by  on 12/09/16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StatusBarView.h"
#import "DL.h"
#import "FontFactory.h"

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
        
        self->name = [FontFactory makeLabel:@"okihara lv.8"];//[CCLabelBMFont labelWithString:@"okihara lv.8" fntFile:@"ebit.fnt"];
        self->name.position = ccp(-80, 0);
        [self addChild:self->name];
        
        self->hp = [FontFactory makeLabel:@"HP: 10"];
        self->hp.position = ccp(40, 0);
        [self addChild:self->hp];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(update_hp:) name:@"UpdateHP" object:nil];
    }
    return self;
}

@end
