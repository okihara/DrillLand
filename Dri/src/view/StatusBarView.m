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
        
        self->bg = [CCLayerColor layerWithColor:ccc4(0, 25, 0, 255)];
        self->bg.position = ccp(-320 / 2, - 40 / 2);
        [self addChild:self->bg];
        
        self->name = [FontFactory makeLabel:@"okihara lv.8"];
        self->name.anchorPoint = ccp(0,0);
        self->name.position = ccp(-150, 6);
        [self addChild:self->name];
        
        self->hp = [FontFactory makeLabel:@"HP: 10  EXP: 0"];
        self->hp.anchorPoint = ccp(0, 0);
        self->hp.position = ccp(-150, -14);
        [self addChild:self->hp];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(update_hp:) name:@"UpdateHP" object:nil];
    }
    return self;
}

@end
